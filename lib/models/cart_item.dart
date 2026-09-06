import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Subtotal for this line item
  double get subtotal => product.price * quantity;
}