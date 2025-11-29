import 'package:flutter/material.dart';
import '../models/products.dart';
import '../components/app_header.dart';
import '../components/bottom_nav_bar.dart';

class UpdateStockPage extends StatefulWidget {
  final Product product;

  const UpdateStockPage({
    super.key,
    required this.product,
  });

  @override
  State<UpdateStockPage> createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends State<UpdateStockPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late int _stock;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.priceLabel);
    _stock = widget.product.stock;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _incrementStock() {
    setState(() {
      _stock += 1;
    });
  }

  void _decrementStock() {
    setState(() {
      if (_stock > 0) {
        _stock -= 1;
      }
    });
  }

  void _onSave() {
    debugPrint('Name: ${_nameController.text}');
    debugPrint('Description: ${_descriptionController.text}');
    debugPrint('Stock: $_stock');
    debugPrint('Price: ${_priceController.text}');
    Navigator.pop(context);
  }

  void _onNavTap(int index) {
    // sementara kosong, nanti bisa diisi logika pindah halaman
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'PhotoKart',
              showSearch: false,
              showBack: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: w * 0.06,
                  right: w * 0.06,
                  bottom: h * 0.04,
                  top: h * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _productImage(),

                    SizedBox(height: h * 0.03),

                    _label('Name'),
                    const SizedBox(height: 6),
                    _textField(controller: _nameController),

                    SizedBox(height: h * 0.02),

                    _label('Description'),
                    const SizedBox(height: 6),
                    _textField(controller: _descriptionController),

                    SizedBox(height: h * 0.02),

                    _label('Stock'),
                    const SizedBox(height: 6),
                    _stockRow(),

                    SizedBox(height: h * 0.02),

                    _label('Price'),
                    const SizedBox(height: 6),
                    _priceRow(),

                    SizedBox(height: h * 0.04),

                    _saveButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _productImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          widget.product.image,
          height: 220,
          width: 160,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF304369),
      ),
    );
  }

  Widget _textField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(
            color: Color(0xFF7B95CF),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(
            color: Color(0xFF7B95CF),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(
            color: Color(0xFF7B95CF),
            width: 1.2,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF304369),
      ),
    );
  }

  Widget _stockRow() {
    return Row(
      children: [
        _circleButton(
          icon: Icons.remove,
          onTap: _decrementStock,
        ),
        const SizedBox(width: 16),
        Text(
          '$_stock',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF304369),
          ),
        ),
        const SizedBox(width: 16),
        _circleButton(
          icon: Icons.add,
          onTap: _incrementStock,
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF7B95CF),
            width: 1.4,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF7B95CF),
        ),
      ),
    );
  }

  Widget _priceRow() {
    return Row(
      children: [
        Expanded(
          child: _textField(controller: _priceController),
        ),
        const SizedBox(width: 12),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFF7B95CF),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            'WON',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF304369),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _saveButton() {
    return Center(
      child: GestureDetector(
        onTap: _onSave,
        child: Container(
          width: 180,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFBFCBF0),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B95CF).withValues(alpha: 0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF304369),
            ),
          ),
        ),
      ),
    );
  }
}
