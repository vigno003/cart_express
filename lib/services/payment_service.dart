import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

// Questo servizio gestisce la simulazione del pagamento e l'invio dell'email di conferma
class PaymentService {
  // === CONFIGURAZIONE MAILJS ===
  static const String mailJsServiceId = 'service_69khn1k';
  static const String mailJsTemplateId = 'template_ptv23p8';
  static const String mailJsPublicKey = 'EdcJyAPPZrDujw8kW';

  // Simula un pagamento, attende 10 secondi e invia una richiesta al backend per inviare l'email
  static Future<bool> processPayment({
    required String email,
    required List<Product> products,
  }) async {
    // Genera un order_id random
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    // Prepara la lista ordini per il template email
    final orders = products.map((p) => {
      'name': p.title,
      'price': p.price,
      'units': 1, // Quantità fissa a 1
    }).toList();
    // Costi fittizi (puoi modificarli)
    final cost = {
      'shipping': 0,
      'tax': 0,
    };

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    try {
      // Invia la richiesta HTTP per inviare l'email di conferma ordine
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': mailJsServiceId,
          'template_id': mailJsTemplateId,
          'user_id': mailJsPublicKey,
          'template_params': {
            'email': email,
            'order_id': orderId,
            'orders': orders,
            'cost': cost,
          },
        }),
      );
      if (response.statusCode == 200) {
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
    // Stampa l'errore in console
    debugPrint('Errore invio email: '
        '${error is http.Response ? error.body : error.toString()}');
  }
}
