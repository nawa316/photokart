import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/product_model.dart';

class ProductCardModel extends StatelessWidget {
  final ProductModel product;
  const ProductCardModel({super.key, required this.product});

  String _formatPrice(double price) {
    // Format price to Indonesian Rupiah format
    final priceStr = price.toStringAsFixed(2);
    final parts = priceStr.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    
    // Add thousand separators
    String formatted = '';
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        formatted = '.$formatted';
      }
      formatted = intPart[i] + formatted;
      count++;
    }
    
    return 'RP. $formatted,$decPart';
  }

  List<Color> _getGradientColors(String rarity) {
    // Return gradient colors based on rarity
    switch (rarity.toLowerCase()) {
      case 'rare':
        return [
          const Color(0xFFFDE7EA),
          const Color(0xFFFFECEF),
        ];
      case 'epic':
        return [
          const Color(0xFFFEE6F6),
          const Color(0xFFFFF0FB),
        ];
      case 'legendary':
        return [
          const Color(0xFFE5F3FF),
          const Color(0xFFF1F8FF),
        ];
      default:
        return [
          const Color(0xFFF4E7FF),
          const Color(0xFFF9F0FF),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final imgSize = w * 0.20;
    final nameWidth = w * 0.22;
    final fontSmall = w * 0.027;
    final fontNormal = w * 0.030;
    final fontBig = w * 0.033;

    return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getGradientColors(product.rarity),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.035,
            vertical: w * 0.030,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FOTO + NAMA
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product.imageUrl,
                      width: imgSize,
                      height: imgSize * 1.20,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: imgSize,
                          height: imgSize * 1.20,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: w * 0.015),
                  SizedBox(
                    width: nameWidth,
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF304369),
                        fontSize: fontNormal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: w * 0.035),
              // KOLOM KANAN FLEX
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Deskripsi
                    Text(
                      product.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF304369),
                        fontSize: fontNormal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: w * 0.010),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${product.rating.toStringAsFixed(1)} ★ | ${product.reviewCount} Reviews',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF304369),
                              fontSize: fontSmall,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.015),
                        Text(
                          'Stock : ${product.stock} pcs',
                          style: TextStyle(
                            color: const Color(0xFF304369),
                            fontSize: fontSmall,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.010),
                    Text(
                      'Sales : ${product.sales} pcs',
                      style: TextStyle(
                        color: const Color(0xFF304369),
                        fontSize: fontNormal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: w * 0.010),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatPrice(product.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF304369),
                              fontSize: fontBig,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: w * 0.045,
                          color: const Color(0xFF7B95CF),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

