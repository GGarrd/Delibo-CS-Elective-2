import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

// ── ProductService ────────────────────────────────────────────────────────────
// All Supabase queries for products are centralised here.
// Uses .range() for pagination and .gte()/.lte() for price filtering.
class ProductService {
  static final _client = Supabase.instance.client;

  static const int pageSize = 6; // 6 products per page (requirement: 6-8 max)

  // Fetch a single page of products with optional price range filter.
  // [page]     — 0-indexed page number
  // [minPrice] — lower bound (inclusive)
  // [maxPrice] — upper bound (inclusive)
  static Future<List<Product>> fetchProducts({
    required int    page,
    required double minPrice,
    required double maxPrice,
  }) async {
    final from = page * pageSize;
    final to   = from + pageSize - 1;

    // Supabase query:
    //   SELECT * FROM products
    //   WHERE price >= minPrice AND price <= maxPrice
    //   ORDER BY price ASC
    //   LIMIT pageSize OFFSET from
    final response = await _client
        .from('products')
        .select()
        .gte('price', minPrice)       // price ≥ minPrice
        .lte('price', maxPrice)       // price ≤ maxPrice
        .order('price', ascending: true)
        .range(from, to);             // pagination via Supabase range query

    return (response as List)
        .map((row) => Product.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  // Count total matching products for the current price filter.
  // Used to know the total number of pages.
  static Future<int> countProducts({
    required double minPrice,
    required double maxPrice,
  }) async {
    final response = await _client
        .from('products')
        .select('id')
        .gte('price', minPrice)
        .lte('price', maxPrice);

    return (response as List).length;
  }
}