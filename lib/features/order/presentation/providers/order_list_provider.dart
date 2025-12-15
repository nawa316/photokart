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

  OrderListState get state => _state;
  List<Transaction> get transactions => _transactions;
  String? get errorMessage => _errorMessage;
  bool get isBuySelected => _isBuySelected;

  List<Transaction> get filteredTransactions {
    // Transactions are already filtered by the repository based on type
    return _transactions;
  }

  Future<void> toggleTransactionType(bool isBuy, String userId) async {
    if (_isBuySelected == isBuy) return; // No change
    _isBuySelected = isBuy;
    // Reload transactions with new type
    await loadTransactions(userId);
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
