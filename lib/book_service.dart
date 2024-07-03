import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_pagination/dto/book.dart';


class BookService {
  static const String apiUrl = 'http://localhost:8000/book';

  Future<List<BookDTO>> getBooks(String token, int page, {String query = ''}) async {
    print('Token being sent: $token');
    final response = await http.get(
      Uri.parse('$apiUrl?page=$page&query=$query'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': token,
      },
    );

    print('Request headers: ${response.request?.headers}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BookDTO.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid token. Token received: $token');
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> addBook(String token, BookDTO book, File? image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers.addAll({
          'Content-Type': 'application/json; charset=UTF-8',
          'Token': token,
        })
        ..fields['name'] = book.name!
        ..fields['price'] = book.price.toString()
        ..fields['desc'] = book.desc!
        ..fields['status'] = book.status!;

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }

      var response = await request.send();

      print('Request headers: ${request.headers}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');

      if (response.statusCode != 201) {
        if (response.statusCode == 401) {
          throw Exception('Unauthorized: Invalid token.');
        } else {
          throw Exception('Failed to add book');
        }
      }
    } catch (e) {
      rethrow; // Rethrow the exception for handling in UI
    }
  }

  Future<void> updateBook(String token, BookDTO book, File? image) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$apiUrl/${book.id}'))
        ..headers.addAll({
          'Content-Type': 'application/json; charset=UTF-8',
          'Token': token,
        })
        ..fields['name'] = book.name!
        ..fields['price'] = book.price.toString()
        ..fields['desc'] = book.desc!
        ..fields['status'] = book.status!;

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }

      var response = await request.send();

      print('Request headers: ${request.headers}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          throw Exception('Unauthorized: Invalid token.');
        } else {
          throw Exception('Failed to update book');
        }
      }
    } catch (e) {
      rethrow; // Rethrow the exception for handling in UI
    }
  }

  Future<void> deleteBook(String token, int bookId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$bookId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': token,
      },
    );

    print('Request headers: ${response.request?.headers}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token.');
      } else {
        throw Exception('Failed to delete book');
      }
    }
  }
}
