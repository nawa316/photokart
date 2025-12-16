import 'package:equatable/equatable.dart';

enum TransactionStatus {
  awaiting,
  processed,
  on_delivery,
  completed,
  cancelled,
}

enum TransactionType {
  buy,  // User is the buyer (transaction.userId = currentUser)
  sell, // User is the seller (product.userId = currentUser)
}

class Transaction extends Equatable {
  final String id;
  final String userId; // The BUYER's user ID
  final String productId; // Product being purchased
  final double totalPrice;
  final DateTime created;
  final TransactionStatus status;
  final TransactionType type; // Determined by query logic, not stored in DB
  final int quantity; // Note: This field needs to be added to database

  // Additional fields that might be useful
  final String? productName;
  final String? productImageUrl;
  final String? buyerUsername;
  final String? sellerUsername;

  const Transaction({
    required this.id,
    required this.userId,
    required this.productId,
    required this.totalPrice,
    required this.created,
    required this.status,
    this.type = TransactionType.buy,
    this.quantity = 1,
    this.productName,
    this.productImageUrl,
    this.buyerUsername,
    this.sellerUsername,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        productId,
        totalPrice,
        created,
        status,
        type,
        quantity,
      ];

  String get statusDisplay {
    switch (status) {
      case TransactionStatus.awaiting:
        return 'Waiting for Confirmation';
      case TransactionStatus.processed:
        return 'Processed';
      case TransactionStatus.on_delivery:
        return 'delivery';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(created);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    }
  }

  Transaction copyWith({
    String? id,
    String? userId,
    String? productId,
    double? totalPrice,
    DateTime? created,
    TransactionStatus? status,
    TransactionType? type,
    int? quantity,
    String? productName,
    String? productImageUrl,
    String? buyerUsername,
    String? sellerUsername,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      totalPrice: totalPrice ?? this.totalPrice,
      created: created ?? this.created,
      status: status ?? this.status,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      buyerUsername: buyerUsername ?? this.buyerUsername,
      sellerUsername: sellerUsername ?? this.sellerUsername,
    );
  }
}
