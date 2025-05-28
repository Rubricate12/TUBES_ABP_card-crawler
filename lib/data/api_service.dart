import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // adjust if needed

  // This function sends the WHOLE LIST of achievements.
  static Future<void> updateAchievements(String username, List<int> achievementIds) async {
    final response = await http.post(
      Uri.parse('$baseUrl/achievements/update'), // Adjust route as needed
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'achievements': achievementIds,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to sync achievements');
    }
  }

  static Future<http.Response> getAchievements(String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/achievements'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );

    return response;
  }

  static Future<http.Response> register(String username, String password) async {
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
        'pass': password,
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