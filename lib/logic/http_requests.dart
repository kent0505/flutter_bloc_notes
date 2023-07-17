import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class ApiClient {
  Future<String> loginResponse(String login, String password) async {
    final body = {'username': login, 'password': password};
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5050/login'),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var token = responseBody['token'];
      return token;
    }
    return '';
  }

  Future logoutResponse(String token) async {
    await http.post(
      Uri.parse('http://127.0.0.1:5050/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future getData(String token) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5050/get'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['notes'];
      var data = result.map((json) => Note.fromJson(json)).toList();
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future addData(String title, String desc, String token) async {
    try {
      final body = {'title': title, 'desc': desc};
      await http.post(
        Uri.parse('http://127.0.0.1:5050/add'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future putData(int id, String title, String desc, String token) async {
    try {
      final body = {'id': id, 'title': title, 'desc': desc};
      await http.put(
        Uri.parse('http://127.0.0.1:5050/edit'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future deleteData(int id, String token) async {
    try {
      final body = {'id': id};
      await http.delete(
        Uri.parse('http://127.0.0.1:5050/delete'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
