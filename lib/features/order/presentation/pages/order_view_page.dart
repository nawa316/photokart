import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../product/domain/product_model.dart';
import '../../domain/entities/transaction.dart';

class OrderViewPage extends StatefulWidget {
  final String transactionId;

  const OrderViewPage({
    super.key,
    required this.transactionId,
  });

  @override
  State<OrderViewPage> createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  Transaction? _transaction;
  ProductModel? _product;
  String? _sellerName;
  String? _sellerPhone;
  String? _sellerAddress;
  String? _buyerName;
  String? _buyerPhone;
  String? _buyerAddress;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    try {
      final supabase = Supabase.instance.client;

      // Load transaction details
      final transactionResponse = await supabase
          .from('transaction')
          .select()
          .eq('id', widget.transactionId)
          .single();

      // Validate required fields
      if (transactionResponse['id'] == null ||
          transactionResponse['userId'] == null ||
          transactionResponse['productId'] == null) {
        throw Exception('Missing required transaction fields');
      }

      // Parse transaction
      final transaction = Transaction(
        id: transactionResponse['id'] as String,
        userId: transactionResponse['userId'] as String,
        productId: transactionResponse['productId'] as String,
        totalPrice: (transactionResponse['totalPrice'] as num?)?.toDouble() ?? 0.0,
        created: transactionResponse['created'] != null
            ? DateTime.parse(transactionResponse['created'])
            : DateTime.now(),
        status: _parseStatus(transactionResponse['status']),
        quantity: transactionResponse['quantity'] ?? 1,
      );

      // Load product details
      final productResponse = await supabase
          .from('product')
          .select()
          .eq('id', transaction.productId)
          .single();

      // Validate required product fields
      if (productResponse['id'] == null ||
          productResponse['name'] == null ||
          productResponse['userId'] == null) {
        throw Exception('Missing required product fields');
      }

      final product = ProductModel(
        id: productResponse['id'] as String,
        name: productResponse['name'] as String,
        description: productResponse['description'] ?? '',
        price: (productResponse['price'] as num?)?.toDouble() ?? 0.0,
        stock: (productResponse['stock'] as int?) ?? 0,
        imageUrl: productResponse['imageUrl'] ?? '',
        userId: productResponse['userId'] as String,
        rarity: productResponse['rarity'] ?? 'Common',
        createdAt: productResponse['createdAt'] != null
            ? DateTime.parse(productResponse['createdAt'])
            : DateTime.now(),
      );

      // Load seller info
      final sellerResponse = await supabase
          .from('users')
          .select('username, phone, bio')
          .eq('id', product.userId)
          .single();

      // Load buyer info
      final buyerResponse = await supabase
          .from('users')
          .select('username, phone, bio')
          .eq('id', transaction.userId)
          .single();

      setState(() {
        _transaction = transaction;
        _product = product;
        _sellerName = sellerResponse['username'] ?? 'Unknown Seller';
        _sellerPhone = sellerResponse['phone'] ?? 'No phone';
        _sellerAddress = sellerResponse['bio'] ?? 'No address provided';
        _buyerName = buyerResponse['username'] ?? 'Unknown Buyer';
        _buyerPhone = buyerResponse['phone'] ?? 'No phone';
        _buyerAddress = buyerResponse['bio'] ?? 'No address provided';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  TransactionStatus _parseStatus(String? status) {
    switch (status) {
      case 'awaiting':
        return TransactionStatus.awaiting;
      case 'processed':
        return TransactionStatus.processed;
      case 'on_shipped':
        return TransactionStatus.on_shipped;
      case 'completed':
        return TransactionStatus.completed;
      case 'cancelled':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.awaiting;
    }
  }

  String _formatPrice(double price) {
    final value = price.toInt();
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $formatted';
  }

  String _generateOrderNumber() {
    if (_transaction == null) return '';
    return _transaction!.id.substring(0, 8);
  }

  Future<void> _handleChatUser() async {
    if (_transaction == null || _product == null) return;

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null) return;

    final isBuyer = _transaction!.userId == currentUserId;
    // Determine the other user ID (seller or buyer)
    final otherUserId = isBuyer ? _product!.userId : _transaction!.userId;
    final otherUserName = isBuyer ? _sellerName : _buyerName;

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final supabase = Supabase.instance.client;

      // Check if conversation already exists
      final existingConvo = await supabase
          .from('conversation')
          .select('id')
          .or('and(user1Id.eq.$currentUserId,user2Id.eq.$otherUserId),and(user1Id.eq.$otherUserId,user2Id.eq.$currentUserId)')
          .maybeSingle();

      String conversationId;

      if (existingConvo != null) {
        // Conversation exists
        conversationId = existingConvo['id'] as String;
      } else {
        // Create new conversation with generated UUID
        const uuid = Uuid();
        final conversationUuid = uuid.v4();
        
        final newConvo = await supabase
            .from('conversation')
            .insert({
              'id': conversationUuid,
              'user1Id': currentUserId,
              'user2Id': otherUserId,
            })
            .select('id')
            .single();
        
        conversationId = newConvo['id'] as String;
      }

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Navigate to chat detail page
      if (mounted) {
        context.push(
          '/chat/$conversationId',
          extra: {
            'username': otherUserName ?? 'User',
            'platformKey': 'order_chat',
          },
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open chat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateOrderStatus(TransactionStatus newStatus) async {
    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      final supabase = Supabase.instance.client;
      
      // Convert status to string for database
      String statusString;
      switch (newStatus) {
        case TransactionStatus.awaiting:
          statusString = 'awaiting';
          break;
        case TransactionStatus.processed:
          statusString = 'processed';
          break;
        case TransactionStatus.on_shipped:
          statusString = 'on_shipped';
          break;
        case TransactionStatus.completed:
          statusString = 'completed';
          break;
        case TransactionStatus.cancelled:
          statusString = 'cancelled';
          break;
        default:
          statusString = 'awaiting';
      }

      // Update transaction status in database
      await supabase
          .from('transaction')
          .update({'status': statusString})
          .eq('id', widget.transactionId)
          .select()
          .single();

      // Update local state
      setState(() {
        _transaction = _transaction!.copyWith(status: newStatus);
        _isUpdatingStatus = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to ${_transaction!.statusDisplay}'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isUpdatingStatus = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showStatusUpdateDialog() {
    final currentStatus = _transaction!.status;
    
    // Determine available next statuses based on current status
    List<TransactionStatus> availableStatuses = [];
    
    switch (currentStatus) {
      case TransactionStatus.awaiting:
        availableStatuses = [TransactionStatus.processed, TransactionStatus.cancelled];
        break;
      case TransactionStatus.processed:
        availableStatuses = [TransactionStatus.on_shipped, TransactionStatus.cancelled];
        break;
      case TransactionStatus.on_shipped:
        availableStatuses = [TransactionStatus.completed];
        break;
      case TransactionStatus.completed:
      case TransactionStatus.cancelled:
        // No status change available
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This order cannot be updated'),
            backgroundColor: Color(0xFF7B95CF),
          ),
        );
        return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.update,
                  size: 64,
                  color: Color(0xFF7B95CF),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Update Order Status',
                  style: TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current: ${_transaction!.statusDisplay}',
                  style: const TextStyle(
                    color: Color(0xFF7B95CF),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ...availableStatuses.map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _updateOrderStatus(status);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getStatusColor(status),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getStatusIcon(status),
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getStatusDisplayText(status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF7B95CF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF7B95CF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStatusDisplayText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.awaiting:
        return 'Waiting for Checkout';
      case TransactionStatus.processed:
        return 'Processing';
      case TransactionStatus.on_shipped:
        return 'Shipped';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.awaiting:
        return const Color(0xFFFFA726);
      case TransactionStatus.processed:
        return const Color(0xFF42A5F5);
      case TransactionStatus.on_shipped:
        return const Color(0xFF66BB6A);
      case TransactionStatus.completed:
        return const Color(0xFF4CAF50);
      case TransactionStatus.cancelled:
        return const Color(0xFFEF5350);
    }
  }

  IconData _getStatusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.awaiting:
        return Icons.hourglass_empty;
      case TransactionStatus.processed:
        return Icons.autorenew;
      case TransactionStatus.on_shipped:
        return Icons.local_shipping;
      case TransactionStatus.completed:
        return Icons.check_circle;
      case TransactionStatus.cancelled:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Color(0xFF7B95CF),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Failed to load order details',
                                  style: const TextStyle(
                                    color: Color(0xFF304369),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Color(0xFF7B95CF),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () => context.pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7B95CF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Go Back',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF7B95CF),
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Order Details',
                style: TextStyle(
                  color: Color(0xFF304369),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_transaction == null || _product == null) {
      return const Center(child: Text('No data available'));
    }

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isBuyer = _transaction!.userId == currentUserId;
    final isSeller = _product!.userId == currentUserId;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Number and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Number',
                    style: TextStyle(
                      color: Color(0xFF7B95CF),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${_generateOrderNumber()}',
                    style: const TextStyle(
                      color: Color(0xFF304369),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(_transaction!.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(_transaction!.status),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(_transaction!.status),
                      size: 16,
                      color: _getStatusColor(_transaction!.status),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _transaction!.statusDisplay,
                      style: TextStyle(
                        color: _getStatusColor(_transaction!.status),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Time
          Text(
            _transaction!.getTimeAgo(),
            style: const TextStyle(
              color: Color(0xFF7B95CF),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),

          // Buyer/Seller Information
          Text(
            isBuyer ? 'Seller Information' : 'Buyer Information',
            style: const TextStyle(
              color: Color(0xFF304369),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 20,
                      color: Color(0xFF7B95CF),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isBuyer ? (_sellerName ?? '') : (_buyerName ?? ''),
                      style: const TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 20,
                      color: Color(0xFF7B95CF),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isBuyer ? (_sellerPhone ?? '') : (_buyerPhone ?? ''),
                      style: const TextStyle(
                        color: Color(0xFF7B95CF),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 20,
                      color: Color(0xFF7B95CF),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isBuyer ? (_sellerAddress ?? '') : (_buyerAddress ?? ''),
                        style: const TextStyle(
                          color: Color(0xFF7B95CF),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Order Details
          const Text(
            'Order Details',
            style: TextStyle(
              color: Color(0xFF304369),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Product Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildProductImage(_product!.imageUrl),
                ),
                const SizedBox(width: 16),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _product!.name,
                        style: const TextStyle(
                          color: Color(0xFF304369),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatPrice(_product!.price),
                        style: const TextStyle(
                          color: Color(0xFF7B95CF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Quantity
                Text(
                  'x${_transaction!.quantity}',
                  style: const TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Order',
                  style: TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatPrice(_transaction!.totalPrice),
                  style: const TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          if (isSeller && _transaction!.status != TransactionStatus.completed && _transaction!.status != TransactionStatus.cancelled)
            Column(
              children: [
                // Update Status Button (for Seller)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isUpdatingStatus ? null : _showStatusUpdateDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF304369),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isUpdatingStatus
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.update,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Update Status',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          
          // Chat Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleChatUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B95CF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isBuyer ? 'Chat Seller' : 'Chat Buyer',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: imageUrl.startsWith('http')
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                );
              },
            )
          : Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                );
              },
            ),
    );
  }
}
