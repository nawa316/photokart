import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/bottom_navbar.dart';
import '../../../order/data/datasources/transaction_remote_datasource.dart';
import '../../../order/data/repositories/transaction_repository_impl.dart';
import '../../../order/domain/entities/transaction.dart';
import '../../../order/domain/usecases/get_user_transactions.dart';

enum RevenuePeriod { daily, weekly, monthly }

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  RevenuePeriod _period = RevenuePeriod.monthly;
  TransactionType _activeType = TransactionType.sell;
  bool _loading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Transaction> _sellTx = [];
  List<Transaction> _buyTx = [];

  int _currentIndex = 4; // adjust if you have a dedicated tab for revenue

  late final GetUserTransactions _getTx;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    final ds = TransactionRemoteDataSourceImpl(supabaseClient: supabase);
    final repo = TransactionRepositoryImpl(remoteDataSource: ds);
    _getTx = GetUserTransactions(repo);
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        _loading = false;
        _error = 'User not logged in';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final sellResult = await _getTx(userId: userId, type: TransactionType.sell);
      final buyResult = await _getTx(userId: userId, type: TransactionType.buy);

      sellResult.fold((l) => _error = l.message, (r) => _sellTx = r);
      buyResult.fold((l) => _error = l.message, (r) => _buyTx = r);
    } catch (e) {
      _error = e.toString();
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  DateTime get _periodStart {
    final now = DateTime.now();
    switch (_period) {
      case RevenuePeriod.daily:
        return DateTime(now.year, now.month, now.day);
      case RevenuePeriod.weekly:
        return now.subtract(const Duration(days: 7));
      case RevenuePeriod.monthly:
        return now.subtract(const Duration(days: 30));
    }
  }

  List<Transaction> _filterPeriod(List<Transaction> list) {
    final start = _periodStart;
    return list.where((t) => t.created.isAfter(start)).toList();
  }

  List<Transaction> _applySearch(List<Transaction> list) {
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((t) {
      final name = t.productName?.toLowerCase() ?? '';
      return name.contains(q) || t.id.toLowerCase().contains(q);
    }).toList();
  }

  List<Transaction> get _activeListRaw => _activeType == TransactionType.sell ? _sellTx : _buyTx;

  List<Transaction> get _activeFiltered {
    final periodFiltered = _filterPeriod(_activeListRaw);
    return _applySearch(periodFiltered);
  }

  double get _totalAmount => _activeFiltered.fold(0, (sum, tx) => sum + tx.totalPrice);

  int get _totalTransactions => _activeFiltered.length;

  double get _averageOrder {
    final count = _totalTransactions;
    if (count == 0) return 0;
    return _totalAmount / count;
  }

  List<Transaction> get _recentTransactions {
    final combined = [..._applySearch(_filterPeriod(_sellTx)), ..._applySearch(_filterPeriod(_buyTx))];
    combined.sort((a, b) => b.created.compareTo(a.created));
    return combined.take(5).toList();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    // TODO: navigate to other tabs if needed
  }

  String _formatCurrency(double value) {
    final intVal = value.round();
    final str = intVal.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final reversedIndex = str.length - i - 1;
      buf.write(str[i]);
      if (reversedIndex % 3 == 0 && i != str.length - 1) {
        buf.write('.');
      }
    }
    return 'Rp ${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? _buildError()
            : _buildContent();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(child: body),
      bottomNavigationBar: PhotoKartBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 8),
          Text(_error ?? 'Unknown error'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _load,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final chartData = _activeFiltered;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeader(
            title: 'PhotoKart',
            showSearch: true,
            searchController: _searchController,
            searchHint: 'Search transactions',
            onSearchChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: 12),
          // Back button above Daily/Weekly/Monthly
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: GestureDetector(
              onTap: () => context.go('/profile'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF7B95CF),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Back',
                    style: TextStyle(
                      color: Color(0xFF7B95CF),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PeriodSelector(
            period: _period,
            onChanged: (p) => setState(() => _period = p),
          ),
          const SizedBox(height: 12),
          _TypeToggle(
            active: _activeType,
            sellTotal: _formatCurrency(_filterPeriod(_sellTx).fold(0, (sum, tx) => sum + tx.totalPrice)),
            buyTotal: _formatCurrency(_filterPeriod(_buyTx).fold(0, (sum, tx) => sum + tx.totalPrice)),
            onChanged: (type) => setState(() => _activeType = type),
          ),
          const SizedBox(height: 12),
          _RevenueChart(transactions: chartData, start: _periodStart),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total Transactions',
                    value: _totalTransactions.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Average Order',
                    value: _formatCurrency(_averageOrder),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final list = [..._applySearch(_filterPeriod(_sellTx)), ..._applySearch(_filterPeriod(_buyTx))];
                    list.sort((a, b) => b.created.compareTo(a.created));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _AllTransactionsPage(
                          transactions: list,
                          formatCurrency: _formatCurrency,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF7B95CF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ..._recentTransactions.map((tx) => _TransactionTile(
                title: tx.productName ?? 'Order',
                subtitle: _formatDate(tx.created),
                amount: _formatCurrency(tx.totalPrice),
              )),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7B95CF),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF304369),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  const _TransactionTile({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF7B95CF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Color(0xFF304369),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  final List<Transaction> transactions;
  final DateTime start;

  const _RevenueChart({
    required this.transactions,
    required this.start,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 200,
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
        child: Stack(
          children: [
            CustomPaint(
              painter: _LineChartPainter(transactions: transactions, start: start),
              child: Container(),
            ),
            if (transactions.isEmpty)
              const Center(
                child: Text(
                  'No transactions in this range',
                  style: TextStyle(color: Color(0xFF7B95CF)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<Transaction> transactions;
  final DateTime start;

  _LineChartPainter({required this.transactions, required this.start});

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = const Color(0xFF304369)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0x1A304369)
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = const Color(0xFF304369)
      ..style = PaintingStyle.fill;

    // grid
    const gridCount = 4;
    for (int i = 0; i <= gridCount; i++) {
      final dy = size.height - 24 - (i / gridCount) * (size.height - 40);
      canvas.drawLine(Offset(36, dy), Offset(size.width, dy), axisPaint);
    }

    // axes
    canvas.drawLine(Offset(36, size.height - 24), Offset(size.width, size.height - 24), axisPaint);
    canvas.drawLine(Offset(36, 8), Offset(36, size.height - 24), axisPaint);

    if (transactions.isEmpty) return;

    final end = DateTime.now();
    final span = end.difference(start).inSeconds.toDouble();
    if (span <= 0) return;

    final maxValue = transactions.fold<double>(0, (max, tx) => tx.totalPrice > max ? tx.totalPrice : max);
    final safeMax = maxValue == 0 ? 1 : maxValue;

    final points = transactions.map((tx) {
      final t = tx.created.difference(start).inSeconds.toDouble();
      final x = 36 + (t / span) * (size.width - 44);
      final y = size.height - 24 - ((tx.totalPrice / safeMax) * (size.height - 48));
      return Offset(x, y);
    }).toList()
      ..sort((a, b) => a.dx.compareTo(b.dx));

    // area fill
    final area = Path()
      ..moveTo(points.first.dx, size.height - 24)
      ..lineTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      area.lineTo(points[i].dx, points[i].dy);
    }
    area.lineTo(points.last.dx, size.height - 24);
    area.close();
    canvas.drawPath(area, fillPaint);

    // line
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // dots
    for (final p in points) {
      canvas.drawCircle(p, 3, dotPaint);
    }

    // y labels
    final textStyle = const TextStyle(color: Color(0xFF7B95CF), fontSize: 11);
    final labelPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= gridCount; i++) {
      final value = safeMax * (i / gridCount);
      labelPainter.text = TextSpan(text: _shortCurrency(value), style: textStyle);
      labelPainter.layout();
      final dy = size.height - 24 - (i / gridCount) * (size.height - 40) - labelPainter.height / 2;
      labelPainter.paint(canvas, Offset(0, dy));
    }

    // x labels (start, mid, end)
    final xLabels = [start, start.add(Duration(seconds: (span / 2).round())), DateTime.now()];
    for (int i = 0; i < xLabels.length; i++) {
      final t = xLabels[i].difference(start).inSeconds.toDouble();
      final x = 36 + (t / span) * (size.width - 44);
      final label = _formatDateShort(xLabels[i]);
      labelPainter.text = TextSpan(text: label, style: textStyle);
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(x - labelPainter.width / 2, size.height - 20));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  String _shortCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _formatDateShort(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _PeriodSelector extends StatelessWidget {
  final RevenuePeriod period;
  final ValueChanged<RevenuePeriod> onChanged;

  const _PeriodSelector({required this.period, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _chip('Daily', RevenuePeriod.daily),
          const SizedBox(width: 8),
          _chip('Weekly', RevenuePeriod.weekly),
          const SizedBox(width: 8),
          _chip('Monthly', RevenuePeriod.monthly),
        ],
      ),
    );
  }

  Widget _chip(String label, RevenuePeriod value) {
    final selected = period == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF304369) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A7B95CF),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF304369),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final TransactionType active;
  final String sellTotal;
  final String buyTotal;
  final ValueChanged<TransactionType> onChanged;

  const _TypeToggle({
    required this.active,
    required this.sellTotal,
    required this.buyTotal,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _pill(
              label: 'Total Penjualan',
              value: sellTotal,
              selected: active == TransactionType.sell,
              onTap: () => onChanged(TransactionType.sell),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _pill(
              label: 'Total Pembelian',
              value: buyTotal,
              selected: active == TransactionType.buy,
              onTap: () => onChanged(TransactionType.buy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill({required String label, required String value, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF304369) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF304369),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF304369),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllTransactionsPage extends StatelessWidget {
  final List<Transaction> transactions;
  final String Function(double) formatCurrency;

  const _AllTransactionsPage({
    required this.transactions,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF304369)),
        title: const Text(
          'All Transactions',
          style: TextStyle(color: Color(0xFF304369)),
        ),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          final typeLabel = tx.type == TransactionType.sell ? 'Sale' : 'Purchase';
          return _TransactionTile(
            title: tx.productName ?? 'Order',
            subtitle: '${typeLabel} • ${_formatDateStatic(tx.created)}',
            amount: formatCurrency(tx.totalPrice),
          );
        },
      ),
    );
  }

  static String _formatDateStatic(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }
}