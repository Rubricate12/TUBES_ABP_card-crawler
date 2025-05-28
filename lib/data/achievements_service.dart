import 'package:card_crawler/provider/gameplay/type/achievement.dart';
import 'package:card_crawler/data/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AchievementsService {
  static const String _key = 'achievements';

  static Future<void> unlockAchievement(
      Achievement achievement, String? username) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedIds = (prefs.getStringList(_key) ?? []).map(int.parse).toSet();

    if (!unlockedIds.contains(achievement.id)) {
      unlockedIds.add(achievement.id);
      await prefs.setStringList(_key, unlockedIds.map((id) => id.toString()).toList());
      if (username != null) {
        syncAchievements(username);
      }
    }
  }

  static Future<void> syncAchievements(String username) async {
    try {
      final response = await ApiService.getAchievements(username);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> remoteUnlockedIds = [];

        if (data['unlocked_ids'] != null && data['unlocked_ids'] is List) {
          remoteUnlockedIds = (data['unlocked_ids'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
        }

        final prefs = await SharedPreferences.getInstance();
        final unlockedIds = (prefs.getStringList(_key) ?? []).map(int.parse).toSet();
        unlockedIds.addAll(remoteUnlockedIds.map((id) => int.parse(id)));
        await prefs.setStringList(_key, unlockedIds.map((id) => id.toString()).toList());
      }
    } catch (e) {
      print('Error syncing achievements: $e');
    }
  }

  static Future<(List<Achievement>, List<Achievement>)>
  getAchievements(String? username) async {
    if (username != null) {
      await syncAchievements(username);
    }

    final prefs = await SharedPreferences.getInstance();
    final List<int> unlockedAchievementIds =
        (prefs.getStringList(_key) ?? []).map(int.parse).toList();
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
