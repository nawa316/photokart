import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/review_remote_datasource.dart';
import '../../data/repositories/review_repository.dart';
import '../../domain/entities/review.dart';
import '../widgets/rating_header.dart';
import '../widgets/rating_summary_card.dart';
import '../widgets/review_card.dart';
import 'add_review_page.dart';

class RatingReviewsPage extends StatefulWidget {
  final String productId;
  final String productName;
  final double currentRating;
  
  const RatingReviewsPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.currentRating,
  });

  @override
  State<RatingReviewsPage> createState() => _RatingReviewsPageState();
}

class _RatingReviewsPageState extends State<RatingReviewsPage> {

  late final ReviewRepository _reviewRepository;
  List<Review> _reviews = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final dataSource = ReviewRemoteDataSourceImpl(
      supabaseClient: Supabase.instance.client,
    );
    _reviewRepository = ReviewRepository(remoteDataSource: dataSource);
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final reviews = await _reviewRepository.getReviewsByProduct(widget.productId);
      
      setState(() {
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load reviews: $e';
        _isLoading = false;
      });
    }
  }

  Map<int, int> _getStarDistribution() {
    final distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in _reviews) {
      distribution[review.stars] = (distribution[review.stars] ?? 0) + 1;
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    final totalReviews = _reviews.length;
    final distribution = _getStarDistribution();
    final satisfiedCount = (distribution[5] ?? 0) + (distribution[4] ?? 0);
    final satisfiedPercentage = totalReviews > 0 
        ? (satisfiedCount / totalReviews * 100).round() 
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            RatingHeader(productName: widget.productName),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadReviews,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadReviews,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                RatingSummaryCard(
                                  rating: widget.currentRating,
                                  totalReviews: totalReviews,
                                  satisfiedPercentage: satisfiedPercentage,
                                  distribution: distribution,
                                ),
                                const SizedBox(height: 24),
                                if (_reviews.isEmpty)
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Text(
                                        'No reviews yet',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  ..._reviews.map((review) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: ReviewCard(
                                      name: review.username ?? 'Anonymous',
                                      rating: review.stars,
                                      reviewText: review.text,
                                      timeAgo: review.getTimeAgo(),
                                      userAvatar: review.userAvatar,
                                    ),
                                  )),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReviewPage(
                productId: widget.productId,
                productName: widget.productName,
              ),
            ),
          );
          
          // Refresh reviews if a review was added
          if (result == true && mounted) {
            _loadReviews();
          }
        },
        backgroundColor: const Color(0xFF7B95CF),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

