import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_pagination/dto/users.dart';

class AuthService {
  static const String apiUrl = 'http://localhost:8000/login';
  String? _token;

  Future<UserDTO> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final user = UserDTO.fromJson(jsonDecode(response.body));
      _token = user.token;
      return user;
    } else {
      throw Exception('Failed to login');
    }
  }

  String? get token => _token;
}