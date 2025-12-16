import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../product/domain/product_model.dart';
import '../../data/datasources/transaction_remote_datasource.dart';
import '../../domain/entities/transaction.dart';

class OrderDetailPage extends StatefulWidget {
  final ProductModel product;
  final int quantity;

  const OrderDetailPage({super.key, required this.product, this.quantity = 1});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String _selectedCardType = 'BCA';
  final TextEditingController _addressController = TextEditingController(
    text: 'Jl. Bandung No.12, Kec. Sukalio, Indonesia',
  );
  late int _quantity;
  String? _orderId;
  bool _isCreatingOrder = false;

  final List<Map<String, dynamic>> _allCardTypes = [
    {'name': 'BRI', 'icon': Icons.account_balance},
    {'name': 'Mandiri', 'icon': Icons.account_balance},
    {'name': 'BNI', 'icon': Icons.account_balance},
    {'name': 'BSI', 'icon': Icons.account_balance},
    {'name': 'BCA', 'icon': Icons.account_balance},
    {'name': 'CIMB Niaga', 'icon': Icons.account_balance},
    {'name': 'Permata', 'icon': Icons.account_balance},
    {'name': 'Danamon', 'icon': Icons.account_balance},
    {'name': 'OCBC NISP', 'icon': Icons.account_balance},
    {'name': 'Panin', 'icon': Icons.account_balance},
    {'name': 'BTN', 'icon': Icons.account_balance},
    {'name': 'Mega', 'icon': Icons.account_balance},
    {'name': 'Bukopin', 'icon': Icons.account_balance},
    {'name': 'Visa', 'icon': Icons.credit_card},
    {'name': 'Mastercard', 'icon': Icons.credit_card},
    {'name': 'American Express', 'icon': Icons.credit_card},
  ];

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
    _generateOrderId();
  }

  void _generateOrderId() {
    // Generate order ID with timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _orderId =
          '#${timestamp.toString().substring(timestamp.toString().length - 6)}';
    });
  }

  String _formatPrice(double price) {
    final value = price.toInt();
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $formatted';
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                // Warning Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA726),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  'Confirmation',
                  style: TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // Message
                const Text(
                  'Are you sure you want to order\nthis PhotoCard?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5E7EB),
                          foregroundColor: const Color(0xFF6B7280),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _createOrder();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF304369),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createOrder() async {
    setState(() {
      _isCreatingOrder = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final dataSource = TransactionRemoteDataSourceImpl(
        supabaseClient: supabase,
      );

      // Create transaction
      final transaction = await dataSource.createTransaction(
        userId: userId,
        productId: widget.product.id!,
        totalPrice: widget.product.price * _quantity,
        quantity: _quantity,
        type: TransactionType.buy,
      );

      setState(() {
        _isCreatingOrder = false;
        // Update order ID with actual transaction ID
        _orderId = '#${transaction.id.substring(0, 8)}';
      });

      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isCreatingOrder = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create order: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  'Order Created!',
                  style: TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // Message
                const Text(
                  'The product you\'ve selected has\nbeen successfully ordered!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                // Okay Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/order');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF304369),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(
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

  void _showCardTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _CardTypeBottomSheet(
          allCardTypes: _allCardTypes,
          selectedCardType: _selectedCardType,
          onCardTypeSelected: (String cardType) {
            setState(() {
              _selectedCardType = cardType;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.product.price * _quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID
                    Text(
                      'Order ${_orderId ?? "#0000"}',
                      style: const TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Address
                    const Text(
                      'Address',
                      style: TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Card Type
                    const Text(
                      'Card Type',
                      style: TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _showCardTypeBottomSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCardType,
                              style: const TextStyle(
                                color: Color(0xFF304369),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF6B7280),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Order Details
                    const Text(
                      'Order Details',
                      style: TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Product Item
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: widget.product.imageUrl.startsWith('http')
                                ? Image.network(
                                    widget.product.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    widget.product.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(width: 12),
                          // Product Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: const TextStyle(
                                    color: Color(0xFF304369),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatPrice(widget.product.price),
                                  style: const TextStyle(
                                    color: Color(0xFF7B95CF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Quantity Controls
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FAFE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: _quantity > 1
                                      ? () {
                                          setState(() {
                                            _quantity--;
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.remove),
                                  color: const Color(0xFF7B95CF),
                                  iconSize: 20,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      color: Color(0xFF304369),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _quantity < widget.product.stock
                                      ? () {
                                          setState(() {
                                            _quantity++;
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.add),
                                  color: const Color(0xFF7B95CF),
                                  iconSize: 20,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pesanan',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _formatPrice(totalPrice),
                            style: const TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5E7EB),
                        foregroundColor: const Color(0xFF6B7280),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isCreatingOrder
                          ? null
                          : _showConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B95CF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        disabledBackgroundColor: const Color(0xFFB0BCD1),
                      ),
                      child: _isCreatingOrder
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Buy Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
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
                'PhotoKart',
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

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}

// Separate StatefulWidget for the bottom sheet to handle search
class _CardTypeBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> allCardTypes;
  final String selectedCardType;
  final Function(String) onCardTypeSelected;

  const _CardTypeBottomSheet({
    required this.allCardTypes,
    required this.selectedCardType,
    required this.onCardTypeSelected,
  });

  @override
  State<_CardTypeBottomSheet> createState() => _CardTypeBottomSheetState();
}

class _CardTypeBottomSheetState extends State<_CardTypeBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCardTypes = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredCardTypes = widget.allCardTypes;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCardTypes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCardTypes = widget.allCardTypes;
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredCardTypes = widget.allCardTypes
            .where((card) =>
                card['name'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Choose your card type',
              style: TextStyle(
                color: Color(0xFF304369),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCardTypes,
              decoration: InputDecoration(
                hintText: 'Search bank name...',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF7B95CF),
                ),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF9CA3AF)),
                        onPressed: () {
                          _searchController.clear();
                          _filterCardTypes('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF7FAFE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Scrollable list of banks
          Flexible(
            child: _filteredCardTypes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No bank found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _filteredCardTypes.length,
                    itemBuilder: (context, index) {
                      final cardType = _filteredCardTypes[index];
                      final isSelected = cardType['name'] == widget.selectedCardType;
                      
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? const Color(0xFF7B95CF).withOpacity(0.1)
                                : const Color(0xFFF7FAFE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            cardType['icon'],
                            color: isSelected 
                                ? const Color(0xFF7B95CF)
                                : const Color(0xFF9CA3AF),
                            size: 24,
                          ),
                        ),
                        title: Text(
                          cardType['name'],
                          style: TextStyle(
                            color: isSelected 
                                ? const Color(0xFF304369)
                                : const Color(0xFF6B7280),
                            fontSize: 16,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.w500,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF7B95CF),
                                size: 24,
                              )
                            : null,
                        onTap: () {
                          widget.onCardTypeSelected(cardType['name']);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
