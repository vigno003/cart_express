import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _service = ProductService();
  List<Product> _products = [];
  List<Product> get products => _products;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final List<Product> _cart = [];
  List<Product> get cart => _cart;
  List<String> _categories = [];
  List<String> get categories => _categories;
  bool _isCategoriesLoading = false;
  bool get isCategoriesLoading => _isCategoriesLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    _products = await _service.fetchProducts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _isCategoriesLoading = true;
    notifyListeners();
    _categories = await _service.fetchCategories();
    _isCategoriesLoading = false;
    notifyListeners();
  }

  List<Product> productsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }
}
