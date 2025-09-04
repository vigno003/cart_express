import 'dart:convert';
import 'package:http/http.dart' as http;

class ZenQuotesService {
  /// Restituisce una citazione random e il suo autore da ZenQuotes.
  /// Se c'è un errore, restituisce una mappa con la chiave 'error'.
  static Future<Map<String, String?>> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty && data[0]['q'] != null && data[0]['a'] != null) {
        if ((data[0]['q'] as String).toLowerCase().contains('too many requests')) {
          return {'error': 'Hai richiesto troppe citazioni. Riprova più tardi.'};
        } else {
          return {
            'quote': data[0]['q'] as String?,
            'author': data[0]['a'] as String?,
          };
        }
      } else {
        return {'error': 'Errore sconosciuto.'};
      }
    } catch (e) {
      return {'error': 'Errore di rete o parsing.'};
    }
  }
}

