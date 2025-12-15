import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/product_model.dart';
import '../../data/product_repository.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;
  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;
  late TextEditingController stockCtrl;
  late TextEditingController priceCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.product.name);
    descCtrl = TextEditingController(text: widget.product.description);
    stockCtrl = TextEditingController(text: widget.product.stock.toString());
    priceCtrl = TextEditingController(text: widget.product.price.toStringAsFixed(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF304369)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PhotoKart",
          style: TextStyle(
            color: Color(0xFF304369),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SizedBox(height: 10),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.product.imageUrl,
                  width: 180,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 180,
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 64),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),
            _label("Name"),
            _field(nameCtrl),

            const SizedBox(height: 20),
            _label("Description"),
            _field(descCtrl, maxLines: 5, minLines: 3),

            const SizedBox(height: 20),
            _label("Stock"),
            Row(
              children: [
                _roundBtn(Icons.remove, () {
                  int value = int.parse(stockCtrl.text);
                  if (value > 0) {
                    value--;
                    stockCtrl.text = value.toString();
                    setState(() {});
                  }
                }),
                const SizedBox(width: 12),
                Text(
                  stockCtrl.text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF304369),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                _roundBtn(Icons.add, () {
                  int value = int.parse(stockCtrl.text);
                  value++;
                  stockCtrl.text = value.toString();
                  setState(() {});
                }),
              ],
            ),

            const SizedBox(height: 20),
            _label("Price"),
            _field(priceCtrl, keyboard: TextInputType.number),

            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B95CF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () async {
                  try {
                    final updatedProduct = ProductModel(
                      id: widget.product.id,
                      name: nameCtrl.text,
                      description: descCtrl.text,
                      price: double.parse(priceCtrl.text),
                      stock: int.parse(stockCtrl.text),
                      userId: widget.product.userId,
                      imageUrl: widget.product.imageUrl,
                      rarity: widget.product.rarity,
                      createdAt: widget.product.createdAt,
                      sales: widget.product.sales,
                      rating: widget.product.rating,
                      reviewCount: widget.product.reviewCount,
                    );

                    await ProductRepository().updateProduct(updatedProduct);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.pop(true);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text("Save"),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF304369),
      ),
    );
  }

  Widget _field(TextEditingController c,
      {keyboard = TextInputType.text, int? maxLines, int? minLines}) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF7B95CF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF304369), width: 2),
        ),
      ),
    );
  }

  Widget _roundBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFF7B95CF)),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF304369)),
      ),
    );
  }
}
