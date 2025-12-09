import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/product_model.dart';

class ProductApi {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> insertProduct(ProductModel product) async {
    await supabase.from('product').insert(product.toMap());
  }
}
