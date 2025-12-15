import 'package:flutter/foundation.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_user_transactions.dart';

enum OrderListState {
  initial,
  loading,
  loaded,
  error,
}

class OrderListProvider with ChangeNotifier {
  final GetUserTransactions getUserTransactions;

  OrderListProvider({required this.getUserTransactions});

  OrderListState _state = OrderListState.initial;
  List<Transaction> _transactions = [];
  String? _errorMessage;
  bool _isBuySelected = true;
  String _searchQuery = '';

  OrderListState get state => _state;
  List<Transaction> get transactions => _transactions;
  String? get errorMessage => _errorMessage;
  bool get isBuySelected => _isBuySelected;
  String get searchQuery => _searchQuery;

  List<Transaction> get filteredTransactions {
    if (_searchQuery.isEmpty) return _transactions;
    final query = _searchQuery.toLowerCase();
    return _transactions.where((t) {
      final idMatch = t.id.toLowerCase().contains(query) ||
          t.id.substring(0, 8).toLowerCase().contains(query);
      final nameMatch = (t.productName ?? '').toLowerCase().contains(query);
      final statusMatch = t.statusDisplay.toLowerCase().contains(query);
      return idMatch || nameMatch || statusMatch;
    }).toList();
  }

  Future<void> toggleTransactionType(bool isBuy, String userId) async {
    if (_isBuySelected == isBuy) return; // No change
    _isBuySelected = isBuy;
    // Reload transactions with new type
    await loadTransactions(userId);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadTransactions(String userId) async {
    _state = OrderListState.loading;
    notifyListeners();

    // Load transactions based on selected type
    final type = _isBuySelected ? TransactionType.buy : TransactionType.sell;
    final result = await getUserTransactions(userId: userId, type: type);

    result.fold(
      (failure) {
        _state = OrderListState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (transactions) {
        _state = OrderListState.loaded;
        _transactions = transactions;
        notifyListeners();
      },
    );
  }

  Future<void> refreshTransactions(String userId) async {
    await loadTransactions(userId);
  }
}
