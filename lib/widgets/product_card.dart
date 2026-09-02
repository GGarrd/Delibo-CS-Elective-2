import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';

// StatelessWidget: a single product card's display never changes after being built
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      // Navigation 2.0: navigate to product detail using go_router
      onTap: () => context.push('/product/${product.id}'),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product image (emoji on colored background) ──────────────────
            Container(
              width: double.infinity,
              height: 110,
              color: isDark
                  ? product.bgColor.withOpacity(0.3)
                  : product.bgColor,
              child: Center(
                child: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 56),
                ),
              ),
            ),

            // ── Product info ─────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: product.bgColor.withOpacity(
                                isDark ? 0.25 : 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Price
                        Text(
                          '₱${product.price.toStringAsFixed(0)}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 15,
                            color: isDark
                                ? const Color(0xFFFFD600)
                                : const Color(0xFF3E2000),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}