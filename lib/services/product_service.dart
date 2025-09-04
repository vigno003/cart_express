import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

// Questo servizio gestisce il recupero dei prodotti e delle categorie dal backend
class ProductService {
  // Recupera la lista dei prodotti dal backend (API fake)
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Converte ogni elemento JSON in un oggetto Product
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Recupera la lista delle categorie disponibili dal backend
  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Restituisce la lista delle categorie come stringhe
      return data.cast<String>();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
