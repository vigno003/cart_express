import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'dart:convert';
import '../services/payment_service.dart';

class CartViewModel extends ChangeNotifier {
  final String? username;
  List<CartItem> _cartItems = [];

  CartViewModel({this.username});

  List<CartItem> get cartItems => _cartItems;

  Future<void> loadCart() async {
    if (username == null) return;
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart_${username!}');
    if (cartString != null) {
      final List<dynamic> decoded = jsonDecode(cartString);
      _cartItems = decoded.map((e) => CartItem.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    if (username == null) return;
    final prefs = await SharedPreferences.getInstance();
    final cartString = jsonEncode(_cartItems.map((e) => e.toJson()).toList());
    await prefs.setString('cart_${username!}', cartString);
  }

  void addToCart(Product product, {int quantity = 1}) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    saveCart();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
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
      products: _cartItems.map((e) => e.product).toList(),
    );
    return result;
  }
}
