import 'package:flutter/material.dart';

// pastikan nama folder sama persis dengan strukturmu
import '../widgets/rating_header.dart';
import '../widgets/rating_summary_card.dart';
import '../widgets/review_filter_chips.dart';
import '../widgets/review_card.dart';

class RatingReviewsPage extends StatelessWidget {
  const RatingReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            const RatingHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // jangan pakai const di list, cukup di widgetnya saja
                  children: [
                    const SizedBox(height: 8),
                    const RatingSummaryCard(),
                    const SizedBox(height: 18),
                    const ReviewFilterChips(),
                    const SizedBox(height: 24),
                    const ReviewCard(
                      name: 'Acrut',
                      rating: 5,
                      reviewText:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sed sodales urna. Vivamus auctor velit nec ipsum ultricies imperdiet. Ut maximus nunc nec tellus ultrices, eu dignissim libero mattis.',
                      variant: 'Photocard Rare',
                      imageUrls: [
                        'assets/images/miniteen.jpg',
                        'assets/images/ocl.png',
                        'assets/images/profil.jpg',
                        'assets/images/pyepuli.png',
                      ],
                    ),
                    const SizedBox(height: 16),
                    const ReviewCard(
                      name: 'Cruta',
                      rating: 4,
                      reviewText:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sed sodales urna. Vivamus auctor velit nec ipsum ultricies imperdiet. Ut maximus nunc nec tellus ultrices, eu dignissim libero mattis.',
                      variant: 'Photocard Rare',
                      imageUrls: [
                        'assets/images/tamtam.png',
                        'assets/images/miniteen.jpg',
                        'assets/images/profil.jpg',
                        'assets/images/ocl.png',
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RatingReviewsPage(),
    ),
  );
}

