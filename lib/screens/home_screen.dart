import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

// ── HomeScreen ────────────────────────────────────────────────────────────────
// StatefulWidget: manages price filter, pagination state, and fetched products.
// Justification: state changes on every slider move, page change, and fetch.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  static const double _minBound = 0;
  static const double _maxBound = 700;

  RangeValues _priceRange = const RangeValues(_minBound, _maxBound);
  int     _currentPage = 0;
  int     _totalPages  = 1;
  bool    _loading     = false;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // ── Supabase query ─────────────────────────────────────────────────────────
  Future<void> _fetchProducts() async {
    setState(() => _loading = true);
    try {
      final results = await ProductService.fetchProducts(
        page:     _currentPage,
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
      );
      final count = await ProductService.countProducts(
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
      );
      setState(() {
        _products   = results;
        _totalPages = (count / ProductService.pageSize).ceil().clamp(1, 999);
        _loading    = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  // Reset to page 0 and re-fetch whenever the slider changes
  void _onPriceChanged(RangeValues values) {
    setState(() {
      _priceRange  = values;
      _currentPage = 0;
    });
    _fetchProducts();
  }

  void _goToPage(int page) {
    setState(() => _currentPage = page);
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final app   = BananaShopApp.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cartCount = app.cartCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🍌 Banana Mart'),
        actions: [
          // Cart icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded),
                onPressed: () => context.push('/cart'),
                tooltip: 'View cart',
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Light/dark mode toggle
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            ),
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: () => app.toggleTheme(),
          ),
          // Sign out
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign out',
            onPressed: () => app.signOut(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Price Range Slider ─────────────────────────────────────────────
          _PriceFilterSlider(
            priceRange: _priceRange,
            min: _minBound,
            max: _maxBound,
            onChanged: _onPriceChanged,
          ),

          // ── Product Grid ───────────────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? _buildEmptyState(theme)
                    : LayoutBuilder(
                        // Responsive: 2 columns on phones, 3 on tablets
                        builder: (context, constraints) {
                          final columns = constraints.maxWidth >= 600 ? 3 : 2;
                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (_, index) =>
                                ProductCard(product: _products[index]),
                          );
                        },
                      ),
          ),

          // ── Pagination Controls ────────────────────────────────────────────
          _PaginationBar(
            currentPage: _currentPage,
            totalPages:  _totalPages,
            onPageChanged: _goToPage,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🐒', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text('No bananas in this price range!',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Try widening the slider.',
              style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// ── Price Filter Slider ───────────────────────────────────────────────────────
// StatelessWidget: slider UI is rebuilt by parent state — no local state needed
class _PriceFilterSlider extends StatelessWidget {
  final RangeValues priceRange;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  const _PriceFilterSlider({
    required this.priceRange,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter by Price',
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
              Text(
                '₱${priceRange.start.toInt()} – ₱${priceRange.end.toInt()}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: theme.colorScheme.primary,
              thumbColor:       theme.colorScheme.primary,
              overlayColor:     theme.colorScheme.primary.withOpacity(0.15),
            ),
            child: RangeSlider(
              values:   priceRange,
              min:      min,
              max:      max,
              divisions: 70,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pagination Bar ────────────────────────────────────────────────────────────
// StatelessWidget: pagination is driven by parent state, not its own
class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border(
          top: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: currentPage > 0
                ? () => onPageChanged(currentPage - 1)
                : null,
            tooltip: 'Previous page',
          ),

          // Page number buttons
          ...List.generate(totalPages, (i) {
            final isSelected = i == currentPage;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () => onPageChanged(i),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: theme.dividerColor.withOpacity(0.5)),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          // Next button
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: currentPage < totalPages - 1
                ? () => onPageChanged(currentPage + 1)
                : null,
            tooltip: 'Next page',
          ),
        ],
      ),
    );
  }
}