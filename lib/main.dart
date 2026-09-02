import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'data/products.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'theme/app_theme.dart';

// ── Navigation 2.0: GoRouter ──────────────────────────────────────────────────
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final product = products.firstWhere((p) => p.id == id);
        return ProductDetailScreen(product: product);
      },
    ),
  ],
);

void main() => runApp(const BananaShopApp());

// ── StatefulWidget: manages theme mode for the entire app ─────────────────────
class BananaShopApp extends StatefulWidget {
  const BananaShopApp({super.key});

  // Allows any descendant widget to access and call toggleTheme()
  static _BananaShopAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_BananaShopAppState>()!;

  @override
  State<BananaShopApp> createState() => _BananaShopAppState();
}

class _BananaShopAppState extends State<BananaShopApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Banana Mart',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      // Single ThemeData applied at MaterialApp level — no hardcoded colors in widgets
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
    );
  }
}