import 'package:flutter/material.dart';
import '../models/products.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int rank;
  
  const ProductCard({super.key, required this.product, required this.rank});

  // Generate random light colors
  Color getRandomLightColor() {
    final random = DateTime.now().millisecondsSinceEpoch * rank;
    final colors = [
      // Light purple variations
      const Color(0xFFF3E5F5),
      const Color(0xFFEDE7F6),
      const Color(0xFFE8EAF6),
      const Color(0xFFE3F2FD),
      // Light blue variations
      const Color(0xFFE1F5FE),
      const Color(0xFFE0F7FA),
      const Color(0xFFE0F2F1),
      // Light red/pink variations
      const Color(0xFFFCE4EC),
      const Color(0xFFF3E5F5),
      const Color(0xFFF1F8E9),
      // Light green variations
      const Color(0xFFF1F8E9),
      const Color(0xFFE8F5E8),
      const Color(0xFFF9FBE7),
      // Light orange/yellow variations
      const Color(0xFFFFF8E1),
      const Color(0xFFFFF3E0),
      const Color(0xFFFBE9E7),
    ];
    
    return colors[random % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        color: getRandomLightColor(),
      ),
      child: Stack(
        children: [
          // Ranking number badge (top left corner)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: rank == 1 
                    ? const Color(0xFFFFD700) // Gold for #1
                    : rank == 2 
                        ? const Color(0xFFC0C0C0) // Silver for #2
                        : rank == 3 
                            ? const Color(0xFFCD7F32) // Bronze for #3
                            : const Color(0xFFFFD166), // Yellow for others
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomRight: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Product Image
          Positioned(
            left: 44,
            top: 10,
            child: Container(
              width: 74,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Product Name
          Positioned(
            left: 34,
            top: 114,
            child: Text(
              product.name,
              style: const TextStyle(
                color: Color(0xFF304369),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Description
          Positioned(
            left: 136,
            top: 25,
            child: Text(
              'Description : ${product.description}',
              style: const TextStyle(
                color: Color(0xFF304369),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Rating and Reviews
          Positioned(
            left: 136,
            top: 48,
            child: Text(
              '${product.rating}       | ${product.reviewCount} Reviews',
              style: const TextStyle(
                color: Color(0xFF304369),
                fontSize: 8,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Stock
          Positioned(
            left: 284,
            top: 48,
            child: Text(
              'Stock  : ${product.stock} pcs',
              style: const TextStyle(
                color: Color(0xFF304369),
                fontSize: 8,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Sales
          Positioned(
            left: 136,
            top: 76,
            child: Text(
              'Sales  : ${product.sales} pcs',
              style: const TextStyle(
                color: Color(0xFF304369),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Price
          Positioned(
            left: 136,
            top: 96,
            child: Text(
              product.formattedPrice,
              style: const TextStyle(
                color: Color(0xFF304369),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}