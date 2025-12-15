import 'dart:async';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../product/domain/product_model.dart';

class HomeRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ProductModel>> fetchTopProducts({int limit = 5}) async {
    try {
        final response = await _supabase
          .from('product')
          .select()
          .order('sales', ascending: false)
          .limit(limit);

      final data = response as List<dynamic>? ?? [];
      return data
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      // TODO: Handle error properly
      print('Error fetching top products: $e');
      return [];
    }
  }

  Future<List<ProductModel>> fetchFeedProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;
      
        final response = await _supabase
          .from('product')
          .select()
          .order('createdAt', ascending: false)
          .range(start, end);

      final data = response as List<dynamic>? ?? [];
      final products = data
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();

      // Shuffle for random appearance
      products.shuffle(Random());

      return products;
    } catch (e) {
      // TODO: Handle error properly
      print('Error fetching feed products: $e');
      return [];
    }
  }

  Future<List<ProductModel>> searchProducts({
    required String query,
    int limit = 20,
  }) async {
    if (query.trim().isEmpty) return [];

    try {
      final keyword = '%${query.trim()}%';
      final response = await _supabase
          .from('product')
          .select()
          .or('name.ilike.$keyword,description.ilike.$keyword')
          .order('createdAt', ascending: false)
          .limit(limit);

      final data = response as List<dynamic>? ?? [];
      return data
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      // TODO: Handle error properly
      print('Error searching products: $e');
      return [];
    }
  }
}