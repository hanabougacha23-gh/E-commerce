import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderService {
  final Dio _api = ApiClient().dio;

  Future<List<OrderItem>> getOrders() async {
    try {
      final response = await _api.get('/orders');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // Parsing logic here...
        return []; // Replace with actual mapping
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createOrder(List<CartItem> items, double total) async {
    try {
      await _api.post('/orders', data: {
        'items': items.map((i) => {
          'product': {'id': i.product.id},
          'quantity': i.quantity,
          'price': i.product.price
        }).toList(),
        'total': total,
        'status': 'PAID'
      });
    } catch (e) {
      print("Erreur création commande: $e");
      rethrow;
    }
  }
}
