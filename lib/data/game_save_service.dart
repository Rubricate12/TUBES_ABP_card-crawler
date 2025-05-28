import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../provider/gameplay/model/game_data.dart';
import 'model/savable_game_data.dart';

class GameSaveService {
  static const _key = "game_data";

  static Future<void> save(GameData gameData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(gameData.toSavableGameData().toJson()),
    );
  }

  static Future<GameData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final gameDataJson = prefs.getString(_key);
    if (gameDataJson == null) return null;
    return SavableGameData.fromJson(jsonDecode(gameDataJson)).toGameData();
  }
}
