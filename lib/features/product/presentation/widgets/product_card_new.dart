import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/products.dart';
import '../../domain/product_model.dart';

class ProductCard extends StatelessWidget {
  final dynamic product; // Can be Product or ProductModel
  final VoidCallback? onProductUpdated;
  
  const ProductCard({
    super.key,
    required this.product,
    this.onProductUpdated,
  });

  /// Parse price from priceLabel format (e.g. "RP. 120.000,00" -> 120000.0)
  double _parsePriceFromLabel(String label) {
    try {
      // Remove "RP. " prefix and replace dot with nothing, comma with dot
      String cleaned = label
          .replaceAll('RP. ', '')
          .replaceAll('.', '')
          .replaceAll(',', '.');
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle both Product and ProductModel types
    late String productId;
    late String productName;
    late double productPrice;
    late String productImage;
    late int productStock;
    late List<Color> gradientColors;

    if (product is ProductModel) {
      final pm = product as ProductModel;
      productId = pm.id ?? '';
      productName = pm.name;
      productPrice = pm.price;
      productImage = pm.imageUrl;
      productStock = pm.stock;
      gradientColors = [const Color(0xFFC2E7FF), const Color(0xFF85C8FC)];
    } else {
      final p = product as Product;
      productId = p.id;
      productName = p.name;
      productPrice = _parsePriceFromLabel(p.priceLabel);
      productImage = p.image;
      productStock = p.stock;
      gradientColors = p.gradientColors;
    }

    final w = MediaQuery.of(context).size.width;
    final imgSize = w * 0.20;
    final nameWidth = w * 0.22;
    final fontSmall = w * 0.027;
    final fontNormal = w * 0.030;
    final fontBig = w * 0.033;

    return GestureDetector(
      onTap: () {
        context.push('/product/$productId').then((_) {
          onProductUpdated?.call();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
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
                  child: product is ProductModel
                      ? Image.network(
                          productImage,
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
                        )
                      : Image.asset(
                          productImage,
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
                    productName,
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
                    'Description : ${product is ProductModel ? (product as ProductModel).description : (product as Product).description}',
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
                          '${product is ProductModel ? (product as ProductModel).rating : (product as Product).rating} ★ | ${product is ProductModel ? (product as ProductModel).reviewCount : (product as Product).reviewCount} Reviews',
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
                        'Stock : $productStock pcs',
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
                    'Sales : ${product is ProductModel ? (product as ProductModel).sales : (product as Product).sales} pcs',
                    style: TextStyle(
                      color: const Color(0xFF304369),
                      fontSize: fontNormal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: w * 0.010),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.02,
                          vertical: w * 0.005,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Rp ${productPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontNormal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        height: w * 0.045,
                        width: w * 0.045,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xFF304369),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
