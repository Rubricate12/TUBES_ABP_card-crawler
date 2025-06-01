import 'dart:convert';

import 'package:card_crawler/data/api_service.dart';
import 'package:card_crawler/provider/main_menu/model/leaderboard_entry.dart';

class LeaderboardService {
  static Future<void> addLeaderboardEntry(LeaderboardEntry entry) async {
    ApiService.addLeaderboardEntry(entry);
  }

  static Future<List<LeaderboardEntry>> getLeaderboardEntries() async {
    final response = await ApiService.getLeaderboardEntries();
    final data = jsonDecode(response.body);
    return (data as List<dynamic>)
        .map(
          (x) => LeaderboardEntry(username: x['username'], score: x['score']),
        )
        .toList();
  }
}
