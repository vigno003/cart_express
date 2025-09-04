import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../services/product_service.dart';

// ViewModel che gestisce la logica dei prodotti e delle categorie
class ProductViewModel extends ChangeNotifier {
  final ProductService _service = ProductService(); // Servizio per recuperare dati
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

  // Recupera i prodotti dal servizio e aggiorna la UI
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners(); // Notifica la UI che sta caricando
    _products = await _service.fetchProducts();
    _isLoading = false;
    notifyListeners(); // Notifica la UI che ha finito
  }

  // Recupera le categorie dal servizio e aggiorna la UI
  Future<void> fetchCategories() async {
    _isCategoriesLoading = true;
    notifyListeners();
    _categories = await _service.fetchCategories();
    _isCategoriesLoading = false;
    notifyListeners();
  }

  // Restituisce i prodotti filtrati per categoria
  List<Product> productsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  // Aggiunge un prodotto al carrello
  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  // Rimuove un prodotto dal carrello
  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  // Aggiunge una recensione a un prodotto
  void addReviewToProduct(int productId, Review review) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final product = _products[index];
      final reviews = product.reviews ?? [];
      reviews.add(review);
      _products[index] = Product(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        reviews: reviews,
      );
      notifyListeners();
      // TODO: persistenza locale se necessario
    }
  }
}
