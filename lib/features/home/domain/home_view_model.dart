import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../product/domain/product_model.dart';
import '../data/home_repository.dart';

class HomeViewState {
  final ProductModel? featuredProduct;
  final List<ProductModel> topProducts;
  final List<ProductModel> feedProducts;
  final bool loadingTop;
  final bool loadingFeed;
  final bool hasMore;
  final bool error;
  final bool isSearching;

  HomeViewState({
    this.featuredProduct,
    this.topProducts = const [],
    this.feedProducts = const [],
    this.loadingTop = false,
    this.loadingFeed = false,
    this.hasMore = true,
    this.error = false,
    this.isSearching = false,
  });

  HomeViewState copyWith({
    ProductModel? featuredProduct,
    List<ProductModel>? topProducts,
    List<ProductModel>? feedProducts,
    bool? loadingTop,
    bool? loadingFeed,
    bool? hasMore,
    bool? error,
    bool? isSearching,
  }) {
    return HomeViewState(
      featuredProduct: featuredProduct ?? this.featuredProduct,
      topProducts: topProducts ?? this.topProducts,
      feedProducts: feedProducts ?? this.feedProducts,
      loadingTop: loadingTop ?? this.loadingTop,
      loadingFeed: loadingFeed ?? this.loadingFeed,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class HomeViewModel {
  final ValueNotifier<HomeViewState> _state =
      ValueNotifier(HomeViewState());
  final HomeRepository _repository = HomeRepository();
  
  int _page = 0;
  final int _limit = 10;
  Timer? _searchDebounce;

  ValueListenable<HomeViewState> get state => _state;
  bool get loadingFeed => _state.value.loadingFeed;
  bool get hasMore => _state.value.hasMore;

  Future<void> init() async {
    _state.value = _state.value.copyWith(isSearching: false);
    await _loadTopProducts();
    await _loadInitialFeed();
  }

  Future<void> searchProducts(String query, {bool debounce = false}) async {
    if (debounce) {
      _searchDebounce?.cancel();
      _searchDebounce = Timer(const Duration(milliseconds: 350), () {
        _executeSearch(query);
      });
      return;
    }

    _searchDebounce?.cancel();
    await _executeSearch(query);
  }

  Future<void> _executeSearch(String query) async {
    final keyword = query.trim();

    if (keyword.isEmpty) {
      _page = 0;
      _state.value = _state.value.copyWith(isSearching: false);
      await _loadFeedProducts(reset: true);
      return;
    }

    _state.value = _state.value.copyWith(
      loadingFeed: true,
      error: false,
      hasMore: false,
      isSearching: true,
    );

    try {
      final results = await _repository.searchProducts(query: keyword);
      _state.value = _state.value.copyWith(
        feedProducts: results,
        loadingFeed: false,
        hasMore: false,
      );
    } catch (e) {
      _state.value = _state.value.copyWith(
        loadingFeed: false,
        error: true,
      );
    }
  }

  Future<void> _loadTopProducts() async {
    _state.value = _state.value.copyWith(loadingTop: true);
    
    try {
      final products = await _repository.fetchTopProducts(limit: 5);
      
      _state.value = _state.value.copyWith(
        featuredProduct: products.isNotEmpty ? products.first : null,
        topProducts: products.isNotEmpty ? products.sublist(1) : [],
        loadingTop: false,
      );
    } catch (e) {
      _state.value = _state.value.copyWith(
        loadingTop: false,
        error: true,
      );
    }
  }

  Future<void> _loadInitialFeed() async {
    await _loadFeedProducts(reset: true);
  }

  Future<void> loadMoreProducts() async {
    if (_state.value.loadingFeed || !_state.value.hasMore) return;
    await _loadFeedProducts();
  }

  Future<void> _loadFeedProducts({bool reset = false}) async {
    if (_state.value.loadingFeed) return;
    
    _state.value = _state.value.copyWith(loadingFeed: true);
    
    try {
      final page = reset ? 0 : _page;
      // Debug log to help diagnose empty feed issues
      print('Fetching feed page: $page, limit: $_limit (reset: $reset)');
      final products = await _repository.fetchFeedProducts(
        page: page,
        limit: _limit,
      );
      print('Fetched ${products.length} products for page $page');
      
        final List<ProductModel> currentFeed =
          reset ? <ProductModel>[] : _state.value.feedProducts;
      final newFeed = [...currentFeed, ...products];
      
      _state.value = _state.value.copyWith(
        feedProducts: newFeed,
        loadingFeed: false,
        hasMore: products.length >= _limit,
      );
      
      if (products.isNotEmpty) {
        _page = page + 1;
      }
    } catch (e) {
      _state.value = _state.value.copyWith(
        loadingFeed: false,
        error: true,
      );
    }
  }
}