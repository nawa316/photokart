import 'dart:async';
import 'package:flutter/foundation.dart';
import 'product_model.dart';
import '../data/top_rating_repository.dart';

class TopRatingViewState {
  final List<ProductModel> products;
  final bool loading;
  final bool hasMore;
  final bool error;

  TopRatingViewState({
    this.products = const [],
    this.loading = false,
    this.hasMore = true,
    this.error = false,
  });

  TopRatingViewState copyWith({
    List<ProductModel>? products,
    bool? loading,
    bool? hasMore,
    bool? error,
  }) {
    return TopRatingViewState(
      products: products ?? this.products,
      loading: loading ?? this.loading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

class TopRatingViewModel {
  final ValueNotifier<TopRatingViewState> _state = ValueNotifier(
    TopRatingViewState(),
  );
  final TopRatingRepository _repository = TopRatingRepository();

  int _page = 0;
  final int _limit = 20;

  ValueListenable<TopRatingViewState> get state => _state;
  bool get loading => _state.value.loading;
  bool get hasMore => _state.value.hasMore;

  Future<void> init() async {
    await _loadProducts(reset: true);
  }

  Future<void> loadMoreProducts() async {
    if (_state.value.loading || !_state.value.hasMore) return;
    await _loadProducts();
  }

  Future<void> _loadProducts({bool reset = false}) async {
    if (_state.value.loading) return;

    _state.value = _state.value.copyWith(loading: true);

    try {
      final page = reset ? 0 : _page;
      final products = await _repository.fetchTopRatingProducts(
        page: page,
        limit: _limit,
      );

      final List<ProductModel> currentProducts = reset
          ? <ProductModel>[]
          : _state.value.products;
      final newProducts = [...currentProducts, ...products];

      _state.value = _state.value.copyWith(
        products: newProducts,
        loading: false,
        hasMore: products.length >= _limit,
        error: false,
      );

      if (products.isNotEmpty) {
        _page = page + 1;
      }
    } catch (e) {
      print('Error loading top rating products: $e');
      _state.value = _state.value.copyWith(loading: false, error: true);
    }
  }

  void dispose() {
    _state.dispose();
  }
}
