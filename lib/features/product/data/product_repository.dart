import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../domain/product_model.dart';
import 'product_api.dart';
import 'product_storage.dart';

class ProductRepository {
  final ProductApi api = ProductApi();
  final ProductStorage storage = ProductStorage();
  final Uuid _uuid = Uuid(); // Create Uuid instance

  /// Create product with image upload
  Future<void> createProduct({
    required String name,
    required String description,
    required int stock,
    required double price,
    required String rarity,
    required Uint8List imageBytes,
    required String fileExt,
    required String userId,
  }) async {
    // Generate a unique product ID
    final String productId = _uuid.v4();
    
    // upload image (you could include productId in the filename)
    final imageUrl = await storage.uploadProductImage(
      imageBytes, 
      fileExt,
    );

    final product = ProductModel(
      id: productId, // Pass the generated UUID
      name: name,
      description: description,
      price: price,
      stock: stock,
      userId: userId,
      imageUrl: imageUrl,
      rarity: rarity,
    );

    await api.insertProduct(product);
  }

  /// Get products by userId
  Future<List<ProductModel>> getProductsByUserId(String userId) async {
    return await api.getProductsByUserId(userId);
  }

  /// Get all products
  Future<List<ProductModel>> getAllProducts() async {
    return await api.getAllProducts();
  }

  /// Get single product by ID
  Future<ProductModel?> getProductById(String productId) async {
    return await api.getProductById(productId);
  }

  /// Update product
  Future<void> updateProduct(ProductModel product) async {
    return await api.updateProduct(product);
  }

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    return await api.deleteProduct(productId);
  }
}