import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  /// Get all transactions for a specific user
  /// [userId] The user ID to fetch transactions for
  /// [type] Optional filter by transaction type (buy/sell)
  Future<Either<Failure, List<Transaction>>> getUserTransactions({
    required String userId,
    TransactionType? type,
  });

  /// Get a single transaction by ID
  Future<Either<Failure, Transaction>> getTransactionById(String transactionId);

  /// Create a new transaction
  Future<Either<Failure, Transaction>> createTransaction({
    required String userId,
    required String productId,
    required double totalPrice,
    required int quantity,
    required TransactionType type,
  });

  /// Update transaction status
  Future<Either<Failure, Transaction>> updateTransactionStatus({
    required String transactionId,
    required TransactionStatus status,
  });

  /// Cancel a transaction
  Future<Either<Failure, bool>> cancelTransaction(String transactionId);
}
