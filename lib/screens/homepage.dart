import 'package:flutter/material.dart';
import '../components/app_header.dart';
import '../components/bottom_nav_bar.dart';
import '../screens/hanni_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // tetap 2 supaya icon tengah (PhotoKart) yang aktif di homepage
  final int _currentIndex = 2;

  void _onNavTap(BuildContext context, int index) {
    // kalau tekan icon yang sudah aktif, tidak melakukan apa apa
    if (index == _currentIndex) return;

    // sementara: kalau tekan icon bag (index 0) buka halaman HanniProduct
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HanniProduct(),
        ),
      );
      return;
    }

    // nanti kalau sudah ada halaman lain bisa ditambah di sini
    // contoh:
    // if (index == 1) { ... ke halaman Cart ... }
    // if (index == 3) { ... ke halaman Chat ... }
    // if (index == 4) { ... ke halaman Profile ... }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'PhotoKart',
              showSearch: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Here are your Top Sales!',
                        style: TextStyle(
                          color: Color(0xFF304369),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FeaturedCard(),
                    SizedBox(height: 32),
                    TopSalesHeader(),
                    SizedBox(height: 16),
                    TopSalesList(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 320,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBFB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x7F7B95CF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x337B95CF),
                blurRadius: 30,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  'assets/images/hanni.png',
                  height: 236,
                  width: 320,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 45,
                child: Row(
                  children: [
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Hanni Bengong',
                        style: TextStyle(
                          color: Color(0xFF304369),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(
                      '4.9 | 120 Reviews',
                      style: TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopSalesHeader extends StatelessWidget {
  const TopSalesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          'Top Sales',
          style: TextStyle(
            color: Color(0xFF304369),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Text(
          'View All',
          style: TextStyle(
            color: Color(0xFF7B95CF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class TopSalesList extends StatelessWidget {
  const TopSalesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'rank': 2, 'name': 'Suzi', 'img': 'assets/images/suzi.png'},
      {'rank': 3, 'name': 'Karina Dagu', 'img': 'assets/images/karina.png'},
      {'rank': 4, 'name': 'Ahul Indokor', 'img': 'assets/images/ahul.png'},
      {'rank': 5, 'name': 'Jungkook', 'img': 'assets/images/jk.png'},
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0x7F7B95CF)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            item['img'] as String,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5A623),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${item['rank']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['name'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
