import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart'; // se hai questa classe

class PaymentService {
  static const String backendUrl = 'http://192.168.1.177:5000';

  // Ora riceve la lista di CartItem, così hai sia product che quantity
  static Future<bool> processPayment({
    required String email,
    required List<CartItem> cartItems, // <- attenzione qui
  }) async {
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();

    // Converte i prodotti in JSON con quantità reale
    final productList = cartItems.map((item) => {
      'name': item.product.title,
      'price': item.product.price,
      'units': item.quantity,
    }).toList();

    try {
      await Future.delayed(const Duration(seconds: 3)); // simulazione pagamento

      final url = Uri.parse('$backendUrl/sendMail');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'orderId': orderId,
          'products': productList,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Email inviata');
        return true;
      } else {
        _logMailError(response);
        return false;
      }
    } catch (e) {
      _logMailError(e);
      return false;
    }
  }

  static void _logMailError(Object error) {
    debugPrint('Errore invio email: '
        '${error is http.Response ? error.body : error.toString()}');
  }
}
