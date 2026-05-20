import 'package:flutter/material.dart';
import '../data/models/cart_item.dart';
import '../data/models/product.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};
  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  // En option A, on charge souvent le panier depuis le serveur au login
  Future<void> fetchAndSetCart() async {
    // Logique API pour récupérer le panier du client
    notifyListeners();
  }

  Future<void> addItem(Product product, {int quantity = 1}) async {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existing) => CartItem(
        product: existing.product,
        quantity: existing.quantity + quantity,
      ));
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
    // TODO: Envoyer la mise à jour au serveur Java
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    _items.remove(productId);
    // TODO: Sync avec serveur
    notifyListeners();
  }

  Future<void> removeSingleItem(String productId) async {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(productId, (existing) => CartItem(
        product: existing.product,
        quantity: existing.quantity - 1,
      ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  Future<void> clear() async {
    _items = {};
    notifyListeners();
  }
}
