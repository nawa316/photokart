import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/bottom_navbar.dart';
import '../../../../core/widgets/app_header.dart';
import '../../domain/entities/transaction.dart';
import '../providers/order_list_provider.dart';
import '../../domain/usecases/get_user_transactions.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/datasources/transaction_remote_datasource.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  int _currentNavIndex = 1; // Default to Cart index
  late OrderListProvider _orderProvider;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize provider
    final supabase = Supabase.instance.client;
    final dataSource = TransactionRemoteDataSourceImpl(supabaseClient: supabase);
    final repository = TransactionRepositoryImpl(remoteDataSource: dataSource);
    final useCase = GetUserTransactions(repository);
    _orderProvider = OrderListProvider(getUserTransactions: useCase);
    
    // Load transactions for current user
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      _orderProvider.loadTransactions(userId);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _orderProvider,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFE),
        body: Column(
          children: [
            AppHeader(
              title: 'PhotoKart',
              showSearch: true,
              searchController: _searchController,
              searchHint: 'Search orders',
              onSearchChanged: (q) => _orderProvider.setSearchQuery(q),
              onSearchSubmitted: (q) => _orderProvider.setSearchQuery(q),
            ),
            Expanded(
              child: Consumer<OrderListProvider>(
                builder: (context, provider, child) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      final userId = Supabase.instance.client.auth.currentUser?.id;
                      if (userId != null) {
                        await provider.refreshTransactions(userId);
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Management Title
                          const Text(
                            'Order Management',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Buy/Sell Toggle Buttons
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                // Buy Button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      final userId = Supabase.instance.client.auth.currentUser?.id;
                                      if (userId != null) {
                                        provider.toggleTransactionType(true, userId);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: provider.isBuySelected
                                            ? const Color(0xFFCFD5FF)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Buy',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: provider.isBuySelected
                                              ? const Color(0xFF304369)
                                              : const Color(0xFF7B95CF),
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Sell Button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      final userId = Supabase.instance.client.auth.currentUser?.id;
                                      if (userId != null) {
                                        provider.toggleTransactionType(false, userId);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: !provider.isBuySelected
                                            ? const Color(0xFF9BA8D0)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Sell',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: !provider.isBuySelected
                                              ? Colors.white
                                              : const Color(0xFF7B95CF),
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Order List
                          _buildOrderList(provider),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: PhotoKartBottomNavBar(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() {
              _currentNavIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(OrderListProvider provider) {
    if (provider.state == OrderListState.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.state == OrderListState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFF7B95CF),
              ),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage ?? 'An error occurred',
                style: const TextStyle(
                  color: Color(0xFF304369),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final transactions = provider.filteredTransactions;

    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                provider.isBuySelected ? Icons.shopping_bag_outlined : Icons.sell_outlined,
                size: 64,
                color: const Color(0xFFD1D9F5),
              ),
              const SizedBox(height: 16),
              Text(
                provider.isBuySelected
                    ? 'No purchase orders yet'
                    : 'No sales orders yet',
                style: const TextStyle(
                  color: Color(0xFF7B95CF),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: transactions.map((transaction) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOrderCard(transaction),
        );
      }).toList(),
    );
  }

  Widget _buildOrderCard(Transaction transaction) {
    return GestureDetector(
      onTap: () {
        // Navigate to order detail page
        context.push('/order/${transaction.id}');
      },
      child: Container(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Number
                  Text(
                    'Order #${transaction.id.substring(0, 8)}',
                    style: const TextStyle(
                      color: Color(0xFF304369),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status and Time
                  Row(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D9F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.watch_later_outlined,
                              size: 12,
                              color: Color(0xFF7B95CF),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              transaction.statusDisplay,
                              style: const TextStyle(
                                color: Color(0xFF7B95CF),
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Time Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFD1D9F5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 12,
                              color: Color(0xFF7B95CF),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              transaction.getTimeAgo(),
                              style: const TextStyle(
                                color: Color(0xFF7B95CF),
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow Icon
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Color(0xFF7B95CF),
            ),
          ],
        ),
      ),
    );
  }
}
