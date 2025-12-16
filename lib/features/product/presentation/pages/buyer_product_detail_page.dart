import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/product_model.dart';

class BuyerProductDetailPage extends StatefulWidget {
  final ProductModel product;
  const BuyerProductDetailPage({super.key, required this.product});

  @override
  State<BuyerProductDetailPage> createState() => _BuyerProductDetailPageState();
}

class _BuyerProductDetailPageState extends State<BuyerProductDetailPage> {
  String? _sellerName;
  String? _sellerEmail;
  bool _isLoadingSeller = true;

  @override
  void initState() {
    super.initState();
    _loadSellerInfo();
  }

  Future<void> _loadSellerInfo() async {
    try {
      final supabase = Supabase.instance.client;
      final sellerResponse = await supabase
          .from('users')
          .select('username, email')
          .eq('id', widget.product.userId)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _sellerName = sellerResponse?['username'] ?? 'Unknown Seller';
          _sellerEmail = sellerResponse?['email'] ?? 'No email';
          _isLoadingSeller = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _sellerName = 'Unknown Seller';
          _sellerEmail = 'No email';
          _isLoadingSeller = false;
        });
      }
    }
  }

  Future<void> _handleChatSeller() async {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to chat with seller'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Don't allow seller to chat with themselves
    if (currentUserId == widget.product.userId) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You cannot chat with yourself'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

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
          .or('and(user1Id.eq.$currentUserId,user2Id.eq.${widget.product.userId}),and(user1Id.eq.${widget.product.userId},user2Id.eq.$currentUserId)')
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
              'user2Id': widget.product.userId,
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
            'username': _sellerName ?? 'Seller',
            'platformKey': 'product_chat',
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

  String _formatPrice(double price) {
    final value = price.toInt();
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'RP $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Product Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          color: Color(0xFF304369),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Product Image
                    Center(
                      child: Container(
                        width: 320,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x337B95CF),
                              blurRadius: 20,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _buildProductImage(widget.product.imageUrl),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Price and Sales/Stock Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatPrice(widget.product.price),
                            style: const TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Sales : ${widget.product.sales} pcs',
                                style: const TextStyle(
                                  color: Color(0xFF304369),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stock : ${widget.product.stock} pcs',
                                style: const TextStyle(
                                  color: Color(0xFF304369),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Seller Information
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7B95CF).withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Seller Avatar
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF7B95CF).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF7B95CF),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Seller Info
                            Expanded(
                              child: _isLoadingSeller
                                  ? const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Loading...',
                                          style: TextStyle(
                                            color: Color(0xFF7B95CF),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Seller',
                                          style: TextStyle(
                                            color: Color(0xFF7B95CF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _sellerName ?? 'Unknown Seller',
                                          style: const TextStyle(
                                            color: Color(0xFF304369),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _sellerEmail ?? 'No email',
                                          style: const TextStyle(
                                            color: Color(0xFF7B95CF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                            ),
                            // Message Button
                            GestureDetector(
                              onTap: _handleChatSeller,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Color(0xFF7B95CF),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description :',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.product.description,
                            style: const TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Rating Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () {
                          context.push(
                            '/product/${widget.product.id}/reviews',
                            extra: {
                              'productId': widget.product.id,
                              'productName': widget.product.name,
                              'currentRating': widget.product.rating,
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0x4D7B95CF),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Rating Score
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.product.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Color(0xFF304369),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Quality Metrics
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.product.reviewCount} Reviews',
                                      style: const TextStyle(
                                        color: Color(0xFF304369),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Tap to view all reviews',
                                      style: TextStyle(
                                        color: Color(0xFF7B95CF),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF7B95CF),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Buy Now Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/order/detail', extra: widget.product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B95CF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.broken_image,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.broken_image,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }
}
