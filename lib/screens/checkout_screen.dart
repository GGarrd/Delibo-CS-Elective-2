import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../models/cart_item.dart';

// StatelessWidget: checkout confirmation is a static summary screen
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = BananaShopApp.of(context);
    final cartItems = app.cartItems;
    final total = app.cartTotal;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        automaticallyImplyLeading: false, // No back button on confirmation
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Confirmation header ──────────────────────────────────────────
            const SizedBox(height: 16),
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              'Thank you for your order!',
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your bananas are on their way 🍌🐒',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // ── Order summary card ───────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Summary',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),

                    // List of cart items
                    ...cartItems.map((item) => _buildOrderRow(item, theme)),

                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: theme.textTheme.titleMedium),
                        Text(
                          '₱${total.toStringAsFixed(0)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.tertiary,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── Continue Shopping button (clears cart) ───────────────────────
            ElevatedButton.icon(
              onPressed: () {
                app.clearCart();
                context.go('/');
              },
              icon: const Icon(Icons.storefront_rounded),
              label: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Single order summary row ───────────────────────────────────────────────
  Widget _buildOrderRow(CartItem item, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(item.product.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${item.quantity} × ₱${item.product.price.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          // Subtotal per item — uses colorScheme.tertiary
          Text(
            '₱${item.subtotal.toStringAsFixed(0)}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}