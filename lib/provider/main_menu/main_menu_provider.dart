import 'package:card_crawler/provider/gameplay/type/achievement.dart';
import 'package:flutter/material.dart';

import '../../data/achievements_service.dart';
import '../../data/game_save_service.dart';
import '../gameplay/model/game_data.dart';
import 'model/leaderboard_entry.dart';

class MainMenuProvider extends ChangeNotifier {
  GameData? _savedGameData;

  GameData? get savedGameData => _savedGameData;

  final List<LeaderboardEntry> _leaderboardEntries = List.empty(growable: true);

  List<LeaderboardEntry> get leaderboardEntries => _leaderboardEntries;

  final List<Achievement> _unlockedAchievements = List.empty(growable: true);

  List<Achievement> get unlockedAchievements => _unlockedAchievements;

  final List<Achievement> _lockedAchievements = List.empty(growable: true);

  List<Achievement> get lockedAchievements => _lockedAchievements;

  Future<void> loadGameData() async {
    _savedGameData = await GameSaveService.load();
    notifyListeners();
  }

  Future<void> loadLeaderboard() async {
    _leaderboardEntries.clear();
    _leaderboardEntries.addAll(
      [
        LeaderboardEntry(username: 'Vito', score: 1000),
        LeaderboardEntry(username: 'Riyan', score: 800),
        LeaderboardEntry(username: 'Hansel', score: 600),
      ]
    );
    notifyListeners();
  }

  Future<void> loadAchievements(String? username) async {
    _unlockedAchievements.clear();
    _lockedAchievements.clear();

    if (username != null) {
      await AchievementsService.syncAchievements(username);
    }

    final (unlockedAchievements, lockedAchievements) =
        await AchievementsService.getAchievements(username);

    _unlockedAchievements.clear();
    _unlockedAchievements.addAll(unlockedAchievements);
    _lockedAchievements.clear();
    _lockedAchievements.addAll(lockedAchievements);

    notifyListeners();
  }
}
