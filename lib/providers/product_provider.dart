import 'package:flutter/material.dart';
import '../data/models/product.dart';
import '../data/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final Set<String> _favoriteIds = {};

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  List<Product> get favoriteProducts => _allProducts.where((p) => _favoriteIds.contains(p.id)).toList();
  String get selectedCategory => _selectedCategory;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      print('Tentative de récupération des produits...');
      _allProducts = await _productService.getProducts();
      print('${_allProducts.length} produits récupérés du serveur');
      _applyFilters();
    } catch (e) {
      print('Erreur fatale ProductProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    // TODO: Connect to backend API for favorites
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    notifyListeners();
  }
}
