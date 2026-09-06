import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../models/cart_item.dart';

// StatefulWidget: quantity controls and running total change based on user interaction
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _increment(String productId) {
    BananaShopApp.of(context).incrementQuantity(productId);
    setState(() {}); // Rebuild to reflect updated quantity and total
  }

  void _decrement(String productId) {
    BananaShopApp.of(context).decrementQuantity(productId);
    setState(() {}); // Rebuild to reflect updated quantity and total
  }

  @override
  Widget build(BuildContext context) {
    final app = BananaShopApp.of(context);
    final cartItems = app.cartItems;
    final total = app.cartTotal;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 My Cart'),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyState(context, theme)
          : Column(
              children: [
                // ── Cart item list ───────────────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, cartItems[index], theme);
                    },
                  ),
                ),

                // ── Bottom bar: total + checkout button ──────────────────────
                _buildBottomBar(context, total, theme),
              ],
            ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🐒', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          Text('Your cart is empty!', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Looks like the monkey ate everything.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }

  // ── Single cart item row ───────────────────────────────────────────────────
  Widget _buildCartItem(
      BuildContext context, CartItem item, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Emoji thumbnail
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: item.product.bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  item.product.emoji,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name + subtotal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Subtotal — uses colorScheme.tertiary (no isDark check)
                  Text(
                    '₱${item.subtotal.toStringAsFixed(0)}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),

            // Stateful quantity controls (+ and -)
            Row(
              children: [
                _QuantityButton(
                  icon: Icons.remove,
                  onTap: () => _decrement(item.product.id),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${item.quantity}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                _QuantityButton(
                  icon: Icons.add,
                  onTap: () => _increment(item.product.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Total + Checkout button ────────────────────────────────────────────────
  Widget _buildBottomBar(
      BuildContext context, double total, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Running total — updates live with quantity changes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: theme.textTheme.titleMedium),
              Text(
                '₱${total.toStringAsFixed(0)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Proceed to Checkout — only enabled when cart has items
          ElevatedButton.icon(
            onPressed: () => context.push('/checkout'),
            icon: const Icon(Icons.payment_rounded),
            label: const Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }
}

// ── Quantity button (reusable) ─────────────────────────────────────────────
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}