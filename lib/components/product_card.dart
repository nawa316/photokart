import 'package:flutter/material.dart';
import '../models/products.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    final w = MediaQuery.of(context).size.width;      // lebar device
    final imgSize = w * 0.20;                         // ukuran foto fleksibel
    final nameWidth = w * 0.22;                       // lebar area nama
    final fontSmall = w * 0.027;
    final fontNormal = w * 0.030;
    final fontBig = w * 0.033;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: product.gradientColors,
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
                  child: Image.asset(
                    product.image,
                    width: imgSize,
                    height: imgSize * 1.20,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: w * 0.015),

                // Nama produk fleksibel
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
                    'Description : ${product.description}',
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
                          '${product.rating} ★ | ${product.reviewCount} Reviews',
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
                        product.priceLabel,
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
