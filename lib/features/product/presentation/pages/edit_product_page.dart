import 'package:flutter/material.dart';
import '../../domain/products.dart';


class EditProductPage extends StatefulWidget {
  final Product product;
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
    priceCtrl = TextEditingController(text: widget.product.price.toString());
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
                child: Image.asset(
                  widget.product.image,
                  width: 180,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),
            _label("Name"),
            _field(nameCtrl),

            const SizedBox(height: 20),
            _label("Description"),
            _field(descCtrl),

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
                onPressed: () {
                  Navigator.pop(
                    context,
                    Product(
                      id: widget.product.id,
                      name: nameCtrl.text,
                      description: descCtrl.text,
                      price: double.parse(priceCtrl.text),
                      stock: int.parse(stockCtrl.text),
                      sales: widget.product.sales,
                      rating: widget.product.rating,
                      reviewCount: widget.product.reviewCount,
                      image: widget.product.image,
                      color: widget.product.color,
                    ),
                  );
                },
                child: const Text("Save"),
              ),
            ),
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
      {keyboard = TextInputType.text}) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
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
