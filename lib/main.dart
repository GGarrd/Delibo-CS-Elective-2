import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'data/products.dart';
import 'models/cart_item.dart';
import 'models/product.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
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
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
  ],
);

void main() => runApp(const BananaShopApp());

// ── StatefulWidget: manages theme mode and cart state for the entire app ──────
class BananaShopApp extends StatefulWidget {
  const BananaShopApp({super.key});

  static _BananaShopAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_BananaShopAppState>()!;

  @override
  State<BananaShopApp> createState() => _BananaShopAppState();
}

class _BananaShopAppState extends State<BananaShopApp> {
  // ── Theme state ─────────────────────────────────────────────────────────────
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // ── Cart state ──────────────────────────────────────────────────────────────
  final List<CartItem> _cart = [];

  List<CartItem> get cartItems => List.unmodifiable(_cart);

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotal => _cart.fold(0.0, (sum, item) => sum + item.subtotal);

  bool isInCart(String productId) =>
      _cart.any((item) => item.product.id == productId);

  void addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((i) => i.product.id == product.id);
      if (index != -1) {
        _cart[index].quantity++;
      } else {
        _cart.add(CartItem(product: product));
      }
    });
  }

  void incrementQuantity(String productId) {
    setState(() {
      final index = _cart.indexWhere((i) => i.product.id == productId);
      if (index != -1) _cart[index].quantity++;
    });
  }

  void decrementQuantity(String productId) {
    setState(() {
      final index = _cart.indexWhere((i) => i.product.id == productId);
      if (index != -1) {
        if (_cart[index].quantity > 1) {
          _cart[index].quantity--;
        } else {
          _cart.removeAt(index);
        }
      }
    });
  }

  void clearCart() {
    setState(() => _cart.clear());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Banana Mart',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      // Single ThemeData applied at MaterialApp level
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
    );
  }
}