import 'cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String status;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
    this.status = 'Pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'products': products.map((cp) => {
        'id': cp.product.id,
        'title': cp.product.name,
        'quantity': cp.quantity,
        'price': cp.product.price,
      }).toList(),
    };
  }
}
