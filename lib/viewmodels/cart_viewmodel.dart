import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'dart:convert';
import '../services/payment_service.dart';

class CartViewModel extends ChangeNotifier {
  final String? username;
  List<Product> _cartItems = [];

  CartViewModel({this.username});

  List<Product> get cartItems => _cartItems;

  Future<void> loadCart() async {
    if (username == null) return;
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart_${username!}');
    if (cartString != null) {
      final List<dynamic> decoded = jsonDecode(cartString);
      _cartItems = decoded.map((e) => Product.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    if (username == null) return;
    final prefs = await SharedPreferences.getInstance();
    final cartString = jsonEncode(_cartItems.map((e) => e.toJson()).toList());
    await prefs.setString('cart_${username!}', cartString);
  }

  void addToCart(Product product) {
    _cartItems.add(product);
    saveCart();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    saveCart();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    saveCart();
    notifyListeners();
  }

  Future<bool> processPayment(String email) async {
    if (_cartItems.isEmpty) return false;
    // Chiama il servizio di pagamento
    final result = await PaymentService.processPayment(
      email: email,
      products: _cartItems,
    );
    return result;
  }
}
