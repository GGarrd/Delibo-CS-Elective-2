import 'package:flutter/material.dart';
import '../models/product.dart';

// StatelessWidget: product detail display is static
// TODO: Full implementation (Add to Cart, etc.) due September 8
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Product emoji preview
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: isDark
                    ? product.bgColor.withOpacity(0.3)
                    : product.bgColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 72),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              product.name,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '₱${product.price.toStringAsFixed(0)}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark
                    ? const Color(0xFFFFD600)
                    : const Color(0xFF3E2000),
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '🚧 Full detail page coming soon',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}