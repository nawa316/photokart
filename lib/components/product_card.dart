import 'package:flutter/material.dart';
import '../models/products.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  
  const ProductCard({super.key, required this.product});

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
        color: product.color,
      ),
      child: Stack(
        children: [
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
                fontSize: 10,
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
                fontSize: 10,
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