import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/product_repository.dart';
import '../widgets/product_add_header.dart';

// Add this enum for rarity
enum ProductRarity {
  common,
  rare,
  very_rare,
  ultra_rare;
  
  String get displayName {
    switch (this) {
      case ProductRarity.common:
        return 'Common';
      case ProductRarity.rare:
        return 'Rare';
      case ProductRarity.very_rare:
        return 'Very Rare';
      case ProductRarity.ultra_rare:
        return 'Ultra Rare';
    }
  }
  
  static ProductRarity? fromString(String value) {
    try {
      return ProductRarity.values.firstWhere(
        (e) => e.toString().split('.').last == value.toLowerCase()
      );
    } catch (e) {
      return null;
    }
  }
}

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  XFile? _imageFile;
  final ImagePicker picker = ImagePicker();
  final ProductRepository _repository = ProductRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController stockController =
      TextEditingController(text: "0");
  final TextEditingController priceController =
      TextEditingController(text: "0");
  
  // Add rarity state variable
  ProductRarity? _selectedRarity;

  Future<void> pickImage() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _imageFile = picked;
      });
    }
  }

  Future<void> _addProduct() async {
    final name = nameController.text.trim();
    final desc = descController.text.trim();
    final stock = int.tryParse(stockController.text) ?? 0;

    // Price parsing: remove non-digit and non-dot chars
    final rawPrice = priceController.text;
    final priceStr = rawPrice.replaceAll(RegExp(r'[^0-9\.]'), '');
    final price = double.tryParse(priceStr) ?? 0.0;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter product name')),
      );
      return;
    }

    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter product description')),
      );
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product image')),
      );
      return;
    }

    // Add validation for rarity
    if (_selectedRarity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select product rarity')),
      );
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    // show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final Uint8List bytes = await _imageFile!.readAsBytes();
      final fileExt = (_imageFile!.name.contains('.')
              ? _imageFile!.name.split('.').last
              : 'jpg')
          .toLowerCase();

      // Update repository call to include rarity
      await _repository.createProduct(
        name: name,
        description: desc,
        stock: stock,
        price: price,
        rarity: _selectedRarity!.name, // This will be "common", "rare", etc.
        imageBytes: bytes,
        fileExt: fileExt,
        userId: userId,
      );

      Navigator.of(context).pop(); // remove loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );
      Navigator.of(context).pop(true); // Pop with success indicator
    } catch (e) {
      Navigator.of(context).pop(); // remove loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF304369),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String hint = "",
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0x55304369)),
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

  // Add method to build rarity dropdown
  Widget _buildRarityDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF7B95CF)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProductRarity>(
          value: _selectedRarity,
          isExpanded: true,
          hint: const Text(
            'Select rarity',
            style: TextStyle(color: Color(0x55304369)),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF304369)),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF304369),
          ),
          borderRadius: BorderRadius.circular(12),
          items: ProductRarity.values.map((rarity) {
            return DropdownMenuItem<ProductRarity>(
              value: rarity,
              child: Text(rarity.displayName),
            );
          }).toList(),
          onChanged: (ProductRarity? newValue) {
            setState(() {
              _selectedRarity = newValue;
            });
          },
        ),
      ),
    );
  }

  void _increaseStock() {
    int value = int.tryParse(stockController.text) ?? 0;
    value++;
    stockController.text = value.toString();
    setState(() {});
  }

  void _decreaseStock() {
    int value = int.tryParse(stockController.text) ?? 0;
    if (value > 0) value--;
    stockController.text = value.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    // frame foto fleksibel pakai rasio kartu Kpop (3:4)
    final double imageBoxWidth = w * 0.55;
    final double imageBoxHeight = imageBoxWidth * 4 / 3;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          children: [
            const ProductAddHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),

                    Center(
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: imageBoxWidth,
                          height: imageBoxHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(0xFF7B95CF),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.07),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: _imageFile == null
                              ? Center(
                                  child: Text(
                                    "Tap to add photo",
                                    style: TextStyle(
                                      color: const Color(0x77304369),
                                      fontSize: w * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FutureBuilder(
                                  future: _imageFile!.readAsBytes(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    return Image.memory(
                                      snapshot.data as Uint8List,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )

                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    _buildLabel("Name"),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: nameController,
                      hint: "Product Name",
                    ),

                    SizedBox(height: h * 0.02),

                    _buildLabel("Description"),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: descController,
                      hint: "Product Description",
                    ),

                    SizedBox(height: h * 0.02),

                    // ADD RARITY FIELD HERE
                    _buildLabel("Rarity"),
                    const SizedBox(height: 6),
                    _buildRarityDropdown(),

                    SizedBox(height: h * 0.02),

                    _buildLabel("Stock"),
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: _decreaseStock,
                          child: Container(
                            width: w * 0.11,
                            height: w * 0.11,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: const Color(0xFF7B95CF),
                                width: 2,
                              ),
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.remove,
                              size: w * 0.06,
                              color: const Color(0xFF304369),
                            ),
                          ),
                        ),

                        SizedBox(width: w * 0.04),

                        Expanded(
                          child: _buildTextField(
                            controller: stockController,
                            keyboardType: TextInputType.number,
                          ),
                        ),

                        SizedBox(width: w * 0.04),

                        GestureDetector(
                          onTap: _increaseStock,
                          child: Container(
                            width: w * 0.11,
                            height: w * 0.11,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: const Color(0xFF7B95CF),
                                width: 2,
                              ),
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.add,
                              size: w * 0.06,
                              color: const Color(0xFF304369),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.02),

                    _buildLabel("Price"),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: priceController,
                      hint: "0",
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: h * 0.04),

                    Center(
                      child: GestureDetector(
                        onTap: _addProduct,
                        child: Container(
                          width: w * 0.45,
                          height: w * 0.12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B95CF),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Add",
                              style: TextStyle(
                                fontSize: w * 0.045,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}