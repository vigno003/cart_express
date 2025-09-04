import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

// ViewModel che gestisce la logica di login e logout degli utenti
class LoginViewModel extends ChangeNotifier {
  final UserService _userService = UserService(); // Servizio per caricare utenti
  List<User> _users = [];
  User? _loggedInUser;
  bool _loading = false;
  String? _error;

  List<User> get users => _users;
  User? get loggedInUser => _loggedInUser;
  bool get loading => _loading;
  String? get error => _error;

  // Carica la lista degli utenti dal servizio
  Future<void> loadUsers() async {
    _loading = true;
    notifyListeners(); // Notifica la UI che sta caricando
    _users = await _userService.loadStaticUsers();
    _loading = false;
    notifyListeners(); // Notifica la UI che ha finito
  }

  // Esegue il login controllando username e password
  bool login(String username, String password) {
    User? user;
    try {
      user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
    } catch (e) {
      user = null;
    }
    if (user != null) {
      _loggedInUser = user;
      _error = null;
      notifyListeners();
      return true;
    } else {
      _error = 'Credenziali non valide';
      notifyListeners();
      return false;
    }
  }

  // Esegue il logout
  void logout() {
    _loggedInUser = null;
    notifyListeners();
  }
}
