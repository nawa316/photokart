import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getUserTransactions({
    required String userId,
    TransactionType? type,
  });

  Future<TransactionModel> getTransactionById(String transactionId);

  Future<TransactionModel> createTransaction({
    required String userId,
    required String productId,
    required double totalPrice,
    required int quantity,
    required TransactionType type,
  });

  Future<TransactionModel> updateTransactionStatus({
    required String transactionId,
    required TransactionStatus status,
  });

  Future<bool> cancelTransaction(String transactionId);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final SupabaseClient supabaseClient;

  TransactionRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<TransactionModel>> getUserTransactions({
    required String userId,
    TransactionType? type,
  }) async {
    try {
      List<dynamic> response;

      if (type == TransactionType.buy) {
        // BUY ORDERS: Show what current user BOUGHT from other sellers
        // Logic: transaction.userId = currentUser (user is the BUYER)
        response = await supabaseClient
            .from('transaction')
            .select('''
              *,
              product:productId(
                name,
                imageUrl,
                userId
              ),
              buyer:userId(
                username
              )
            ''')
            .eq('userId', userId)
            .order('created', ascending: false);
      } else if (type == TransactionType.sell) {
        // SELL ORDERS: Show what OTHER USERS BOUGHT from current user
        // Logic: product.userId = currentUser (user is the SELLER/product owner)
        // Use !inner to ensure we only get transactions for products owned by user
        response = await supabaseClient
            .from('transaction')
            .select('''
              *,
              product:productId!inner(
                name,
                imageUrl,
                userId
              ),
              buyer:userId(
                username
              )
            ''')
            .eq('product.userId', userId)
            .order('created', ascending: false);
      } else {
        // Get all transactions (both buy and sell)
        response = await supabaseClient
            .from('transaction')
            .select('''
              *,
              product:productId(
                name,
                imageUrl,
                userId
              ),
              buyer:userId(
                username
              )
            ''')
            .or('userId.eq.$userId,product.userId.eq.$userId')
            .order('created', ascending: false);
      }

      return response
          .map(
            (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get user transactions: $e');
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String transactionId) async {
    try {
      final response = await supabaseClient
          .from('transaction')
          .select('''
            *,
            product:productId(
              name,
              imageUrl,
              userId
            ),
            buyer:userId(
              username
            )
          ''')
          .eq('id', transactionId)
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get transaction: $e');
    }
  }

  @override
  Future<TransactionModel> createTransaction({
    required String userId,
    required String productId,
    required double totalPrice,
    required int quantity,
    required TransactionType type,
  }) async {
    try {
      // Generate valid UUID v4 for transaction id
      const uuid = Uuid();
      final transactionId = uuid.v4();

      final response = await supabaseClient
          .from('transaction')
          .insert({
            'id': transactionId,
            'userId': userId,
            'productId': productId,
            'totalPrice': totalPrice,
            'created': DateTime.now().toIso8601String(),
            'status': 'awaiting',
            'quantity': quantity,
          })
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  @override
  Future<TransactionModel> updateTransactionStatus({
    required String transactionId,
    required TransactionStatus status,
  }) async {
    try {
      final response = await supabaseClient
          .from('transaction')
          .update({'status': status.toString().split('.').last})
          .eq('id', transactionId)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update transaction status: $e');
    }
  }

  @override
  Future<bool> cancelTransaction(String transactionId) async {
    try {
      await supabaseClient
          .from('transaction')
          .update({'status': 'cancelled'})
          .eq('id', transactionId);

      return true;
    } catch (e) {
      throw Exception('Failed to cancel transaction: $e');
    }
  }
}
