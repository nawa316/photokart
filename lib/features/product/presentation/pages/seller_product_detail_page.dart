import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/product_model.dart';
import '../../data/product_repository.dart';
import '../../presentation/widgets/custom_popup.dart';


class ProductDetailPage extends StatelessWidget {
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});
  String _formatPrice(double price) {
    final priceStr = price.toStringAsFixed(2);
    final parts = priceStr.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    
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
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "PhotoKart",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF304369),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF304369),
                ),
              ),

              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  product.imageUrl,
                  height: w * 1.1,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: w * 1.1,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 64),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatPrice(product.price),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF304369),
                    ),
                  ),
                  Text(
                    "Sales : ${product.sales} pcs",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF304369),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                "Stock : ${product.stock} pcs",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 18),
              const Text(
                "Description :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF304369),
                ),
              ),
              Text(product.description),

              const SizedBox(height: 24),

              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 5),
                  Text(
                    "${product.rating} (${product.reviewCount} reviews)",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF304369),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/editproduct/${product.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B95CF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Update"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          final isConfirm = await AppPopup.showDeleteConfirm(context);

                          if (isConfirm == true) {
                            try {
                              await ProductRepository().deleteProduct(product.id!);
                              if (context.mounted) {
                                // Show success popup first
                                await AppPopup.showDeleteSuccess(context);
                                // Then navigate back
                                if (context.mounted) {
                                  context.pop(true); // Return true to indicate product was deleted
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting product: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF7272),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Delete"),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
