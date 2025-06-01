import 'dart:convert';
import 'package:card_crawler/provider/main_menu/model/leaderboard_entry.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.168.0.99:8000/api';

  static Future<void> updateAchievements(
    String username,
    List<int> achievementIds,
  ) async {
    for (var id in achievementIds) {
      final response = await http.post(
        Uri.parse('$baseUrl/achievements/update'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username, 'achievement_id': id}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to sync achievements');
      }
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

  static Future<http.Response> register(
    String username,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': username, 'pass': password}),
    );

    return response;
  }

  static Future<http.Response> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      body: {'username': username, 'pass': password},
    );
    return response;
  }

  static Future<void> addLeaderboardEntry(LeaderboardEntry entry) async {
    final url = Uri.parse('$baseUrl/leaderboard/sync');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': entry.username, 'score': entry.score}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add leaderboard entry');
    }
  }

  static Future<http.Response> getLeaderboardEntries() async {
    final response = await http.get(
      Uri.parse('$baseUrl/leaderboard'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }
}
