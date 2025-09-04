import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'dart:convert';
import '../services/payment_service.dart';
import '../models/user.dart';

// ViewModel che gestisce la logica del carrello per ogni utente
class CartViewModel extends ChangeNotifier {
  final User? user;
  List<CartItem> _cartItems = [];

  CartViewModel({this.user});

  List<CartItem> get cartItems => _cartItems;

  String? get userEmail => user?.email;

  // Carica il carrello salvato nelle SharedPreferences per l'utente
  Future<void> loadCart() async {
    if (user == null) return;
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart_${user!.username}');
    if (cartString != null) {
      final List<dynamic> decoded = jsonDecode(cartString);
      _cartItems = decoded.map((e) => CartItem.fromJson(e)).toList();
      notifyListeners();
    }
  }

  // Salva il carrello nelle SharedPreferences per l'utente
  Future<void> saveCart() async {
    if (user == null) return;
    final prefs = await SharedPreferences.getInstance();
    final cartString = jsonEncode(_cartItems.map((e) => e.toJson()).toList());
    await prefs.setString('cart_${user!.username}', cartString);
  }

  // Aggiunge un prodotto al carrello (o aggiorna la quantità)
  void addToCart(Product product, {int quantity = 1}) {
    final index = _cartItems.indexWhere((item) =>
    item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    saveCart();
    notifyListeners();
  }

  // Rimuove un prodotto dal carrello
  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    saveCart();
    notifyListeners();
  }

  // Pulisce il carrello
  void clearCart() {
    _cartItems.clear();
    saveCart();
    notifyListeners();
  }

  // Elenco dei metodi pubblici della classe
  // processPayment: gestisce il pagamento degli articoli nel carrello
  Future<bool> processPayment(String email) async {
    if (cartItems.isEmpty) return false;

    // Passa l'intero cartItems al PaymentService
    final result = await PaymentService.processPayment(
      email: email,
      cartItems: cartItems, // <- qui
    );

    return result;
  }
}
