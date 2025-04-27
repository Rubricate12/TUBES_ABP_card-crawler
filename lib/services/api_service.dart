import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // adjust if needed

  static Future<http.Response> registerUser(String username, String pass) async {
    //parse api utk register
    final url = Uri.parse('$baseUrl/register');
    //build response utk post method ke database
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'pass': pass,
      }),
    );

    return response;
  }
  static Future<http.Response> login(String username, String password) async {
    //parse api utk login
    final url = Uri.parse('$baseUrl/login');
    //build response utk post method ke database
    final response = await http.post(
      url,
      body: {
        'username': username,
        'pass': password,
      },
    );
    return response;
  }
}