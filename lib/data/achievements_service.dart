import 'package:card_crawler/provider/gameplay/type/achievement.dart';
import 'package:card_crawler/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AchievementsService {
  static String _key(String? username) =>
      username == null ? 'achievements_guest' : 'achievements_$username';

  static Future<void> addUnlockedAchievement(Achievement achievement,String? username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(username);
    final Set<String> unlockedAchievementIds =
        (prefs.getStringList(key) ?? []).toSet();
    unlockedAchievementIds.add(achievement.id.toString());
    await prefs.setStringList(key, unlockedAchievementIds.toList());

    if (username != null) {
      final idsToSend = unlockedAchievementIds.map(int.parse).toList();
      await ApiService.updateAchievements(username, idsToSend);
    }
  }

  static Future<void> syncAchievementsFromServer(String username) async {
    final response = await ApiService.getAchievements(username);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final unlockedIds = (data['unlocked_ids'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_key(username), unlockedIds);

    } else {
      throw Exception('Failed to fetch achievements from server');
    }
  }

  static Future<(List<Achievement>, List<Achievement>)>
  getAchievements(String? username) async {
    final prefs = await SharedPreferences.getInstance();

    final List<int> unlockedAchievementIds =
        (prefs.getStringList(_key(username)) ?? []).map(int.parse).toList();

    final List<Achievement> unlockedAchievements = List.empty(growable: true);
    final List<Achievement> lockedAchievements = List.empty(growable: true);

    for (final achievement in Achievement.values) {
      if (unlockedAchievementIds.contains(achievement.id)) {
        unlockedAchievements.add(achievement);
      } else {
        lockedAchievements.add(achievement);
      }
    }

    unlockedAchievements.sort((a, b) => a.id.compareTo(b.id));
    lockedAchievements.sort((a, b) => a.id.compareTo(b.id));

    return (unlockedAchievements, lockedAchievements);
  }
}
