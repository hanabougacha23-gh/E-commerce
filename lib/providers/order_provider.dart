import 'package:flutter/material.dart';
import '../data/models/order.dart';
import '../data/models/cart_item.dart';
import '../data/services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> fetchOrders() async {
    try {
      _orders = await _orderService.getOrders();
      notifyListeners();
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  void startOrderListener() {
    // Dans l'option A, on utilise souvent des WebSockets ou FCM 
    // pour les mises à jour en temps réel au lieu d'un listener DB direct.
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      await _orderService.createOrder(cartProducts, total);
      // Optionnel: rafraîchir la liste après création
      await fetchOrders();
    } catch (e) {
      rethrow;
    }
  }
}
