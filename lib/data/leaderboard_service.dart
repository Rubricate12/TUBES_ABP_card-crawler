import 'dart:convert';

import 'package:card_crawler/data/api_service.dart';
import 'package:card_crawler/provider/main_menu/model/leaderboard_entry.dart';

class LeaderboardService {
  static Future<void> sendLeaderboardEntry(LeaderboardEntry entry) async {
    ApiService.syncLeaderboard(entry.username, entry.score);
    print('Send leaderboard running');
  }

  static Future<List<LeaderboardEntry>> getLeaderboardEntry() async {
    final response = await ApiService.getLeaderboard();
    final data = jsonDecode(response.body);
    return (data as List<dynamic>)
        .map(
          (x) => LeaderboardEntry(username: x['username'], score: x['score']),
        )
        .toList();
  }
}
