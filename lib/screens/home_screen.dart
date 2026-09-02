import 'package:flutter/material.dart';
import '../data/products.dart';
import '../main.dart';
import '../widgets/product_card.dart';

// StatelessWidget: home screen layout doesn't change based on user interaction
// (theme toggle is managed at the app level, not here)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🍌 Banana Mart'),
        actions: [
          // Light/dark mode toggle — accessible from AppBar as required
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            ),
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: () => BananaShopApp.of(context).toggleTheme(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        // Responsive: LayoutBuilder detects available width
        builder: (context, constraints) {
          // 2 columns on phones, 3+ columns on tablets
          final columns = constraints.maxWidth >= 600 ? 3 : 2;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
      ),
    );
  }
}