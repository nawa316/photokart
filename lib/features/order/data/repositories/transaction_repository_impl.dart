import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getUserTransactions({
    required String userId,
    TransactionType? type,
  }) async {
    try {
      final transactions = await remoteDataSource.getUserTransactions(
        userId: userId,
        type: type,
      );
      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(
      String transactionId) async {
    try {
      final transaction =
          await remoteDataSource.getTransactionById(transactionId);
      return Right(transaction);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> createTransaction({
    required String userId,
    required String productId,
    required double totalPrice,
    required int quantity,
    required TransactionType type,
  }) async {
    try {
      final transaction = await remoteDataSource.createTransaction(
        userId: userId,
        productId: productId,
        totalPrice: totalPrice,
        quantity: quantity,
        type: type,
      );
      return Right(transaction);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransactionStatus({
    required String transactionId,
    required TransactionStatus status,
  }) async {
    try {
      final transaction = await remoteDataSource.updateTransactionStatus(
        transactionId: transactionId,
        status: status,
      );
      return Right(transaction);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelTransaction(String transactionId) async {
    try {
      final result = await remoteDataSource.cancelTransaction(transactionId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
