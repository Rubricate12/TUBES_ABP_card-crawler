import 'package:card_crawler/data/local_game_save_service.dart';
import 'package:card_crawler/provider/gameplay/type/achievement.dart';
import 'package:flutter/material.dart';

import '../../data/achievements_service.dart';
import '../gameplay/model/game_data.dart';

class MainMenuProvider extends ChangeNotifier {
  GameData? _localGameData;

  GameData? get localGameData => _localGameData;

  final List<Achievement> _unlockedAchievements = List.empty(growable: true);

  List<Achievement> get unlockedAchievements => _unlockedAchievements;

  final List<Achievement> _lockedAchievements = List.empty(growable: true);

  List<Achievement> get lockedAchievements => _lockedAchievements;

  Future<void> loadGameData() async {
    _localGameData = await LocalGameSaveService.load();
    notifyListeners();
  }

  Future<void> loadAchievements(String? username) async {
    _unlockedAchievements.clear();
    _lockedAchievements.clear();
    notifyListeners();
    if (username != null) {
      await AchievementsService.syncAchievementsFromServer(username);
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
