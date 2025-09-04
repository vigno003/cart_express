import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';

// Questo servizio gestisce il caricamento degli utenti statici da un file locale
class UserService {
  // Carica la lista degli utenti dal file users.json
  Future<List<User>> loadStaticUsers() async {
    final jsonStr = await rootBundle.loadString('lib/users.json');
    final List data = json.decode(jsonStr);
    // Converte ogni elemento JSON in un oggetto User
    return data.map((u) => User.fromJson(u)).toList();
  }
}
