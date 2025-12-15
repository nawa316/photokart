import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/bottom_navbar.dart';
import '../../domain/home_view_model.dart';
import '../widget/featured_card.dart';
import '../widget/top_sales_header.dart';
import '../widget/top_sales_list.dart';
import '../widget/small_product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = HomeViewModel();
  final SpeechToText _speech = SpeechToText();
  final TextEditingController _searchController = TextEditingController();
  bool _speechAvailable = false;
  bool _isListening = false;
  String? _speechError;

  @override
  void initState() {
    super.initState();
    _viewModel.init();
    _initSpeech();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _speech.stop();
    super.dispose();
  }

  // Scroll handled by NotificationListener

  void _onNavTap(int index) {
    // TODO: Implement navigation logic
    // Currently home is index 2, so we don't navigate if already on home
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' && mounted) {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _isListening = false;
          _speechError = error.errorMsg;
        });
        _showSpeechError(error.errorMsg);
      },
    );

    if (mounted) {
      setState(() => _speechAvailable = available);
    }
  }

  Future<void> _toggleListening() async {
    final micOk = await _ensureMicPermission();
    if (!micOk) {
      _showSpeechError('Izin mikrofon ditolak. Izinkan di Settings.');
      return;
    }

    if (!_speechAvailable) {
      await _initSpeech();
      if (!_speechAvailable) {
        _showSpeechError('Microphone permission belum diberikan atau speech recognizer tidak tersedia.');
        return;
      }
    }

    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
    } else {
      final started = await _speech.listen(
        onResult: _onSpeechResult,
        partialResults: true,
        listenMode: ListenMode.dictation,
        localeId: null,
      );
      if (mounted) setState(() => _isListening = started);
      if (!started) {
        _showSpeechError('Gagal memulai voice input.');
      }
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    final text = result.recognizedWords;
    _searchController.text = text;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: _searchController.text.length),
    );

    if (result.finalResult) {
      _viewModel.searchProducts(text);
      setState(() => _isListening = false);
    }
  }

  void _showSpeechError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> _ensureMicPermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;

    final result = await Permission.microphone.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      // Optionally guide user to settings
      await openAppSettings();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HomeViewState>(
      valueListenable: _viewModel.state,
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7FAFE),
          body: SafeArea(
            child: Column(
              children: [
                AppHeader(
                  title: 'PhotoKart',
                  showSearch: true,
                  searchController: _searchController,
                  isListening: _isListening,
                  onSearchChanged: (value) => _viewModel.searchProducts(value, debounce: true),
                  onSearchSubmitted: (value) => _viewModel.searchProducts(value),
                  onMicTap: _toggleListening,
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      try {
                        final metrics = notification.metrics;
                        if (metrics.extentAfter < 300 && _viewModel.hasMore && !_viewModel.loadingFeed) {
                          _viewModel.loadMoreProducts();
                        }
                      } catch (_) {}
                      return false;
                    },
                    child: CustomScrollView(
                      slivers: [
                        if (!state.isSearching)
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                const SizedBox(height: 24),
                                const Center(
                                  child: Text(
                                    'Here are your Top Sales!',
                                    style: TextStyle(
                                      color: Color(0xFF304369),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Featured & Top Sales Section
                                _buildTopSalesSection(state),
                              ]),
                            ),
                          ),

                        // If feed is empty show a retry CTA, otherwise show sliver grid
                        if (state.feedProducts.isEmpty && !state.loadingFeed)
                          SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Column(
                                  children: [
                                    const Text('No products found'),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () => _viewModel.init(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                        // Random Feed Section as a sliver grid with matching horizontal padding
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => SmallProductCard(product: state.feedProducts[index]),
                              childCount: state.feedProducts.length,
                            ),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.72,
                            ),
                          ),
                        ),

                        if (state.loadingFeed)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),

                        const SliverToBoxAdapter(child: SizedBox(height: 40)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: PhotoKartBottomNavBar(
            currentIndex: 2, // Home is index 2
            onTap: _onNavTap,
          ),
        );
      },
    );
  }

  Widget _buildTopSalesSection(HomeViewState state) {
    if (state.loadingTop) {
      return const SizedBox(
        height: 236,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.featuredProduct == null && state.topProducts.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        if (state.featuredProduct != null) ...[
          FeaturedCard(product: state.featuredProduct!),
          const SizedBox(height: 32),
        ],
        const TopSalesHeader(),
        const SizedBox(height: 16),
        TopSalesList(products: state.topProducts),
        const SizedBox(height: 24),
      ],
    );
  }
  
}