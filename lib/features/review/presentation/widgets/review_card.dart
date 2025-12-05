import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final int rating;
  final String reviewText;
  final String variant;
  final List<String> imageUrls;

  const ReviewCard({
    super.key,
    required this.name,
    required this.rating,
    required this.reviewText,
    required this.variant,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xffe0e6ff),
                child: const Icon(
                  Icons.person,
                  color: Color(0xff1f2847),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xff1f2847),
                      ),
                    ),
                    const SizedBox(height: 2),
                    _StarRow(count: 5, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            reviewText,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xff5f6a8a),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Variant : $variant',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff1f2847),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < imageUrls.length - 1 ? 8 : 0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        width: 80,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final int count;
  final double size;

  const _StarRow({required this.count, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count,
        (_) => Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            Icons.star,
            size: size,
            color: const Color(0xffffc540),
          ),
        ),
      ),
    );
  }
}
