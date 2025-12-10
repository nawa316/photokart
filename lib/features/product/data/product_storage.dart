import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductStorage {
  final SupabaseClient client = Supabase.instance.client;

  /// Upload product image and return public URL
  Future<String> uploadProductImage(Uint8List bytes, String fileExt) async {
    final String fileName =
        'product_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

    final String path = 'products/$fileName';

    await client.storage
        .from('product-images')
        .uploadBinary(path, bytes);

    final publicUrl =
        client.storage.from('product-images').getPublicUrl(path);

    return publicUrl;
  }
}
