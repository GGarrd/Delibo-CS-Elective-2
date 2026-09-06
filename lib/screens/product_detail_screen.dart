import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../models/product.dart';

// StatefulWidget: the Add to Cart button state changes after user interaction
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _added = false;

  void _addToCart() {
    BananaShopApp.of(context).addToCart(widget.product);
    // Button state changes to "Added!" — clear justification for StatefulWidget
    setState(() => _added = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _added = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product image header ─────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 240,
              color: product.bgColor,
              child: Center(
                child: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Category badge ─────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.bgColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Product name ───────────────────────────────────────────
                  Text(
                    product.name,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 8),

                  // ── Price — uses colorScheme.tertiary from AppTheme ────────
                  Text(
                    '₱${product.price.toStringAsFixed(0)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Divider ────────────────────────────────────────────────
                  const Divider(),
                  const SizedBox(height: 12),

                  // ── Description ────────────────────────────────────────────
                  Text(
                    'About this product',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 32),

                  // ── Add to Cart button ─────────────────────────────────────
                  ElevatedButton.icon(
                    onPressed: _added ? null : _addToCart,
                    icon: Icon(_added ? Icons.check_rounded : Icons.shopping_cart_rounded),
                    label: Text(_added ? 'Added to Cart!' : 'Add to Cart'),
                  ),
                  const SizedBox(height: 12),

                  // ── View Cart button ───────────────────────────────────────
                  OutlinedButton.icon(
                    onPressed: () => context.push('/cart'),
                    icon: const Icon(Icons.shopping_bag_rounded),
                    label: const Text('View Cart'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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