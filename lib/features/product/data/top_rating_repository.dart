import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/product_model.dart';

class TopRatingRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ProductModel>> fetchTopRatingProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      final response = await _supabase
          .from('product')
          .select()
          .order('sales', ascending: false)
          .order('rating', ascending: false)
          .range(start, end);

      final data = response as List<dynamic>? ?? [];
      return data
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      print('Error fetching top rating products: $e');
      return [];
    }
  }
}
