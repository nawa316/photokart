import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetUserTransactions {
  final TransactionRepository repository;

  GetUserTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> call({
    required String userId,
    TransactionType? type,
  }) async {
    return await repository.getUserTransactions(
      userId: userId,
      type: type,
    );
  }
}
