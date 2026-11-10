import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';

// ── ProductCard ───────────────────────────────────────────────────────────────
// StatelessWidget: displays a single product in the grid.
// No state lives here — it just renders what it's given and handles a tap.
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Pass the full Product object as `extra` so ProductDetailScreen
        // doesn't have to re-fetch from Supabase just to show details.
        context.push('/product/${product.id}', extra: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Emoji hero area ──────────────────────────────────────────────
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  width: double.infinity,
                  color: product.bgColor,
                  child: Center(
                    child: Text(
                      product.emoji,
                      style: const TextStyle(fontSize: 52),
                    ),
                  ),
                ),
              ),
            ),

            // ── Info section ─────────────────────────────────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Price — uses colorScheme.tertiary (set in AppTheme for
                    // both light and dark; NO isDark check needed here)
                    Text(
                      '₱${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w800,
                      ),
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