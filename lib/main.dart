import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'models/product.dart';
import 'models/cart_item.dart';
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
        // Product is passed as extra to avoid re-fetching from Supabase
        final product = state.extra as Product;
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

// ── App entry point: initialise Supabase before runApp ────────────────────────
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:    SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const BananaShopApp());
}

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
  int    get cartCount => _cart.fold(0, (sum, i) => sum + i.quantity);
  double get cartTotal => _cart.fold(0.0, (sum, i) => sum + i.subtotal);

  bool isInCart(String productId) =>
      _cart.any((i) => i.product.id == productId);

  void addToCart(Product product) {
    setState(() {
      final idx = _cart.indexWhere((i) => i.product.id == product.id);
      if (idx != -1) {
        _cart[idx].quantity++;
      } else {
        _cart.add(CartItem(product: product));
      }
    });
  }

  void incrementQuantity(String productId) {
    setState(() {
      final idx = _cart.indexWhere((i) => i.product.id == productId);
      if (idx != -1) _cart[idx].quantity++;
    });
  }

  void decrementQuantity(String productId) {
    setState(() {
      final idx = _cart.indexWhere((i) => i.product.id == productId);
      if (idx != -1) {
        if (_cart[idx].quantity > 1) {
          _cart[idx].quantity--;
        } else {
          _cart.removeAt(idx);
        }
      }
    });
  }

  void clearCart() => setState(() => _cart.clear());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Banana Mart',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
    );
  }
}