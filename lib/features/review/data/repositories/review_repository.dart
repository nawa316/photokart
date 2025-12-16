import '../datasources/review_remote_datasource.dart';
import '../../domain/entities/review.dart';

class ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepository({required this.remoteDataSource});

  Future<List<Review>> getReviewsByProduct(String productId) async {
    return await remoteDataSource.getReviewsByProduct(productId);
  }

  Future<Review> createReview({
    required String productId,
    required int stars,
    required String text,
  }) async {
    return await remoteDataSource.createReview(
      productId: productId,
      stars: stars,
      text: text,
    );
  }
}
