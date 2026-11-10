import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../models/product.dart';

// ── ProductDetailScreen ───────────────────────────────────────────────────────
// StatefulWidget: needs `_added` local state to show "Added ✓" feedback.
// The product is received as GoRouter `extra` — no Supabase re-fetch needed.
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Tracks whether the user just pressed "Add to Cart" — shows brief feedback
  bool _added = false;

  void _handleAddToCart() {
    BananaShopApp.of(context).addToCart(widget.product);
    setState(() => _added = true);
    // Reset the button label after 1.5 s
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _added = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme   = Theme.of(context);
    final app     = BananaShopApp.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          // Cart badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded),
                onPressed: () => context.push('/cart'),
                tooltip: 'View cart',
              ),
              if (app.cartCount > 0)
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
                      '${app.cartCount}',
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
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero emoji banner ──────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 260,
              color: product.bgColor,
              child: Center(
                child: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),

            // ── Detail section ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  if (product.category.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.category.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                  // Product name
                  Text(
                    product.name,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 8),

                  // Price — colorScheme.tertiary; no isDark check
                  Text(
                    '₱${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'Fresh from the bunch — a Banana Mart exclusive.',
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                  ),

                  const SizedBox(height: 32),

                  // ── Add to Cart button ──────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _added ? null : _handleAddToCart,
                      icon: Icon(_added ? Icons.check : Icons.add_shopping_cart),
                      label: Text(_added ? 'Added to Cart!' : 'Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _added
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── View Cart link ──────────────────────────────────────
                  Center(
                    child: TextButton.icon(
                      onPressed: () => context.push('/cart'),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                      label: const Text('View Cart'),
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
}