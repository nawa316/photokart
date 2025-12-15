import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/product_model.dart';

class ProductApi {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> insertProduct(ProductModel product) async {
    await supabase.from('product').insert(product.toMap());
  }

  /// Fetch products by userId
  Future<List<ProductModel>> getProductsByUserId(String userId) async {
    final response = await supabase
        .from('product')
        .select()
        .eq('userId', userId)
        .order('createdAt', ascending: false);

    return (response as List)
        .map((item) => ProductModel.fromMap(item))
        .toList();
  }

  /// Fetch all products
  Future<List<ProductModel>> getAllProducts() async {
    final response = await supabase
        .from('product')
        .select()
        .order('createdAt', ascending: false);

    return (response as List)
        .map((item) => ProductModel.fromMap(item))
        .toList();
  }

  /// Fetch single product by ID
  Future<ProductModel?> getProductById(String productId) async {
    final response = await supabase
        .from('product')
        .select()
        .eq('id', productId)
        .maybeSingle();

    if (response == null) return null;
    return ProductModel.fromMap(response);
  }

  /// Update product
  Future<void> updateProduct(ProductModel product) async {
    await supabase
        .from('product')
        .update({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'stock': product.stock,
          'rarity': product.rarity,
          'updatedAt': DateTime.now().toIso8601String(),
        })
        .eq('id', product.id!);
  }

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    await supabase
        .from('product')
        .delete()
        .eq('id', productId);
  }
}
