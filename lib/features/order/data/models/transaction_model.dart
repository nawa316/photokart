import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.productId,
    required super.totalPrice,
    required super.created,
    required super.status,
    super.type,
    super.quantity,
    super.productName,
    super.productImageUrl,
    super.buyerUsername,
    super.sellerUsername,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final userId = json['userId'] as String;
    
    // Transaction type is determined by the query logic in the data source,
    // not by comparing userId values here.
    // The query will filter transactions based on whether the user is buyer or seller.
    final transactionType = TransactionType.buy; // Default, actual filtering done by query

    return TransactionModel(
      id: json['id'] as String,
      userId: userId,
      productId: json['productId'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      created: DateTime.parse(json['created'] as String),
      status: _parseStatus(json['status'] as String),
      type: transactionType,
      quantity: json['quantity'] as int? ?? 1,
      // Joined data from product/user tables
      productName: json['product']?['name'] as String?,
      productImageUrl: json['product']?['imageUrl'] as String?,
      buyerUsername: json['buyer']?['username'] as String?,
      sellerUsername: json['seller']?['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'totalPrice': totalPrice,
      'created': created.toIso8601String(),
      'status': _statusToString(status),
      'quantity': quantity,
    };
  }

  static TransactionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'awaiting':
        return TransactionStatus.awaiting;
      case 'processed':
        return TransactionStatus.processed;
      case 'on_delivery':
        return TransactionStatus.on_delivery;
      case 'completed':
        return TransactionStatus.completed;
      case 'cancelled':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.awaiting;
    }
  }

  static String _statusToString(TransactionStatus status) {
    return status.toString().split('.').last;
  }
}
