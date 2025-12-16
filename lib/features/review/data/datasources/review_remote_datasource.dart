import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/review.dart';

abstract class ReviewRemoteDataSource {
  Future<List<Review>> getReviewsByProduct(String productId);
  Future<Review> createReview({
    required String productId,
    required int stars,
    required String text,
  });
  Stream<List<Review>> streamReviewsByProduct(String productId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final SupabaseClient supabaseClient;

  ReviewRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<Review>> getReviewsByProduct(String productId) async {
    try {
      final response = await supabaseClient
          .from('review')
          .select('*')
          .eq('productId', productId)
          .order('created', ascending: false) as List<dynamic>;

      // Fetch user data separately for each review
      final List<Review> reviews = [];
      
      for (var json in response) {
        final reviewData = json as Map<String, dynamic>;
        final userId = reviewData['userId'] as String;
        
        // Fetch user info
        String? username;
        String? userAvatar;
        
        try {
          final userResponse = await supabaseClient
              .from('users')
              .select('username, avatarUrl')
              .eq('id', userId)
              .maybeSingle();
          
          if (userResponse != null) {
            username = userResponse['username'] as String?;
            userAvatar = userResponse['avatarUrl'] as String?;
          }
        } catch (e) {
          // If user fetch fails, continue with null values
          // Silent fail - username and userAvatar will be null
        }

        reviews.add(Review(
          id: reviewData['id'] as String,
          userId: userId,
          productId: reviewData['productId'] as String,
          stars: reviewData['stars'] as int,
          text: reviewData['text'] as String,
          created: DateTime.parse(reviewData['created'] as String),
          username: username,
          userAvatar: userAvatar,
        ));
      }
      
      return reviews;
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }

  @override
  Future<Review> createReview({
    required String productId,
    required int stars,
    required String text,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final reviewData = {
        'id': const Uuid().v4(),
        'productId': productId,
        'userId': userId,
        'stars': stars,
        'text': text,
        'created': DateTime.now().toIso8601String(),
      };

      final response = await supabaseClient
          .from('review')
          .insert(reviewData)
          .select()
          .single();

      // Fetch user info separately
      String? username;
      String? userAvatar;
      
      try {
        final userResponse = await supabaseClient
            .from('users')
            .select('username, avatarUrl')
            .eq('id', userId)
            .maybeSingle();
        
        if (userResponse != null) {
          username = userResponse['username'] as String?;
          userAvatar = userResponse['avatarUrl'] as String?;
        }
      } catch (e) {
        // Silent fail - username and userAvatar will be null
      }

      return Review(
        id: response['id'] as String,
        userId: response['userId'] as String,
        productId: response['productId'] as String,
        stars: response['stars'] as int,
        text: response['text'] as String,
        created: DateTime.parse(response['created'] as String),
        username: username,
        userAvatar: userAvatar,
      );
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  @override
  Stream<List<Review>> streamReviewsByProduct(String productId) {
    // Stream realtime changes based on primary key
    final stream = supabaseClient
        .from('review')
        .stream(primaryKey: ['id'])
        .eq('productId', productId)
        .order('created', ascending: false);

    return stream.asyncMap((rows) async {
      // Optionally enrich with user info; keep lightweight for realtime
      final List<Review> list = [];
      for (final reviewData in rows) {
        String? username;
        String? userAvatar;
        try {
          final userResponse = await supabaseClient
              .from('users')
              .select('username, avatarUrl')
              .eq('id', reviewData['userId'] as String)
              .maybeSingle();
          if (userResponse != null) {
            username = userResponse['username'] as String?;
            userAvatar = userResponse['avatarUrl'] as String?;
          }
        } catch (_) {}

        list.add(
          Review(
            id: reviewData['id'] as String,
            userId: reviewData['userId'] as String,
            productId: reviewData['productId'] as String,
            stars: reviewData['stars'] as int,
            text: reviewData['text'] as String,
            created: DateTime.parse(reviewData['created'] as String),
            username: username,
            userAvatar: userAvatar,
          ),
        );
      }
      return list;
    });
  }
}
