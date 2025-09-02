import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';

class UserService {
  Future<List<User>> loadStaticUsers() async {
    final jsonStr = await rootBundle.loadString('lib/users.json');
    final List data = json.decode(jsonStr);
    return data.map((u) => User.fromJson(u)).toList();
  }
}
