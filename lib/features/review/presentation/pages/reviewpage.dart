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
  List<Review> _initialReviews = [];
  bool _isLoading = true;
  String? _errorMessage;
  List<Review> _optimisticReviews = [];

  @override
  void initState() {
    super.initState();
    final dataSource = ReviewRemoteDataSourceImpl(
      supabaseClient: Supabase.instance.client,
    );
    _reviewRepository = ReviewRepository(remoteDataSource: dataSource);
    _loadInitialReviews();
  }

  Future<void> _loadInitialReviews() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final reviews = await _reviewRepository.getReviewsByProduct(widget.productId);
      
      setState(() {
        _initialReviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load reviews: $e';
        _isLoading = false;
      });
    }
  }

  Map<int, int> _calculateDistribution(List<Review> reviews) {
    final distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in reviews) {
      distribution[review.stars] = (distribution[review.stars] ?? 0) + 1;
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    List<Review> effectiveReviews = _initialReviews;
    int totalReviews = effectiveReviews.length;
    Map<int, int> distribution = _calculateDistribution(effectiveReviews);
    final satisfiedCount = (distribution[5] ?? 0) + (distribution[4] ?? 0);
    final satisfiedPercentage = totalReviews > 0 
        ? (satisfiedCount / totalReviews * 100).round() 
        : 0;
    final averageRating = totalReviews > 0
      ? effectiveReviews.map((r) => r.stars).reduce((a, b) => a + b) / totalReviews
      : widget.currentRating;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            RatingHeader(productName: widget.productName),
            Expanded(
              child: _errorMessage != null
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
                            onPressed: _loadInitialReviews,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : StreamBuilder<List<Review>>(
                      stream: _reviewRepository.streamReviewsByProduct(widget.productId),
                      initialData: _initialReviews,
                      builder: (context, snapshot) {
                        if (_isLoading && !snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        effectiveReviews = snapshot.data ?? _initialReviews;
                        totalReviews = effectiveReviews.length;
                        distribution = _calculateDistribution(effectiveReviews);
                        final satisfiedCountLocal = (distribution[5] ?? 0) + (distribution[4] ?? 0);
                        final satisfiedPercentageLocal = totalReviews > 0 
                            ? (satisfiedCountLocal / totalReviews * 100).round() 
                            : 0;
                        final averageRatingLocal = totalReviews > 0
                            ? effectiveReviews.map((r) => r.stars).reduce((a, b) => a + b) / totalReviews
                            : widget.currentRating;

                        // Merge optimistic reviews with stream data (avoid duplicates by id)
                        final allReviewIds = <String>{};
                        final mergedReviews = <Review>[];
                        
                        // Add optimistic reviews first
                        for (final r in _optimisticReviews) {
                          allReviewIds.add(r.id);
                          mergedReviews.add(r);
                        }
                        
                        // Add stream reviews (skip if already in optimistic list)
                        for (final r in effectiveReviews) {
                          if (!allReviewIds.contains(r.id)) {
                            mergedReviews.add(r);
                          }
                        }
                        
                        final mergedDistribution = _calculateDistribution(mergedReviews);
                        final mergedTotal = mergedReviews.length;
                        final mergedSatisfied = (mergedDistribution[5] ?? 0) + (mergedDistribution[4] ?? 0);
                        final mergedPercentage = mergedTotal > 0 
                            ? (mergedSatisfied / mergedTotal * 100).round() 
                            : 0;
                        final mergedRating = mergedTotal > 0
                            ? mergedReviews.map((r) => r.stars).reduce((a, b) => a + b) / mergedTotal
                            : widget.currentRating;

                        return RefreshIndicator(
                          onRefresh: _loadInitialReviews,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                RatingSummaryCard(
                                  rating: mergedRating,
                                  totalReviews: mergedTotal,
                                  satisfiedPercentage: mergedPercentage,
                                  distribution: mergedDistribution,
                                ),
                                const SizedBox(height: 24),
                                if (mergedReviews.isEmpty)
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
                                  ...mergedReviews.map((review) => Padding(
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
                        );
                      },
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
          
          // If a review was submitted, add it to optimistic list for instant display
          if (result is Review && mounted) {
            setState(() {
              _optimisticReviews = [result, ..._optimisticReviews];
            });
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

  @override
  void dispose() {
    super.dispose();
  }
}

