import 'package:flutter/material.dart';
import '../../domain/top_rating_view_model.dart';
import '../widgets/product_card_model.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/bottom_navbar.dart';

class TopRating extends StatefulWidget {
  const TopRating({super.key});

  @override
  State<TopRating> createState() => _TopRatingState();
}

class _TopRatingState extends State<TopRating> {
  final TopRatingViewModel _viewModel = TopRatingViewModel();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TopRatingViewState>(
      valueListenable: _viewModel.state,
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7FAFE),
          bottomNavigationBar: PhotoKartBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const AppHeader(title: 'Top Rating', showSearch: false),
                const SizedBox(height: 24),

                // Title section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Top Rated Products',
                    style: TextStyle(
                      color: Color(0xFF304369),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      try {
                        final metrics = notification.metrics;
                        if (metrics.extentAfter < 300 &&
                            _viewModel.hasMore &&
                            !_viewModel.loading) {
                          _viewModel.loadMoreProducts();
                        }
                      } catch (_) {}
                      return false;
                    },
                    child: _buildContent(state),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(TopRatingViewState state) {
    // Initial loading
    if (state.loading && state.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state with retry
    if (state.error && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF7B95CF)),
            const SizedBox(height: 16),
            const Text(
              'Failed to load products',
              style: TextStyle(
                color: Color(0xFF304369),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _viewModel.init(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B95CF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (state.products.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(color: Color(0xFF7B95CF), fontSize: 16),
        ),
      );
    }

    // Product list with ranking
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: state.products.length + (state.loading ? 1 : 0),
      itemBuilder: (context, index) {
        // Loading indicator at the end
        if (index >= state.products.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final product = state.products[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildRankedProductCard(product, index + 1),
        );
      },
    );
  }

  Widget _buildRankedProductCard(product, int rank) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          ProductCardModel(product: product),
          // Rank badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getRankColors(rank),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getRankColors(int rank) {
    if (rank == 1) {
      return [const Color(0xFFFFD700), const Color(0xFFFFAA00)]; // Gold
    } else if (rank == 2) {
      return [const Color(0xFFC0C0C0), const Color(0xFF999999)]; // Silver
    } else if (rank == 3) {
      return [const Color(0xFFCD7F32), const Color(0xFF996633)]; // Bronze
    } else {
      return [const Color(0xFF7B95CF), const Color(0xFF5A7AB8)]; // Default blue
    }
  }
}
