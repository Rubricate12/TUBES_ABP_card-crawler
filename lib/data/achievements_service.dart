import 'package:card_crawler/provider/gameplay/type/achievement.dart';
import 'package:card_crawler/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AchievementsService {
  static const String _guestAchievementsKey = 'achievements_guest';

  static String _userAchievementsKey(String username) {
    return 'achievements_user_$username';
  }

  static String _getActiveKey(String? username) {
    return username == null ? _guestAchievementsKey : _userAchievementsKey(username);
  }

  static Future<bool> tryUnlockAchievement(
      Achievement achievement, String? username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getActiveKey(username); // Gets guest key or user-specific key

    final storedIds = prefs.getStringList(key) ?? [];
    final unlockedIds = storedIds.map(int.parse).toSet();

    if (!unlockedIds.contains(achievement.id)) {
      unlockedIds.add(achievement.id);
      await prefs.setStringList(
          key, unlockedIds.map((id) => id.toString()).toList());

      // Only sync with server if a user is logged in
      if (username != null) {
        try {
          await ApiService.unlockAchievementOnServer(username, achievement.id);
          print('Achievement ${achievement.id} successfully synced for $username.');
        } catch (e) {
          print('Error syncing achievement ${achievement.id} for $username: $e');
          // Optional: Implement a retry mechanism or flag for later sync.
          // For now, the achievement is unlocked locally for the user.
        }
      } else {
        print('Achievement ${achievement.id} unlocked locally for guest.');
      }
      return true; // Achievement was newly unlocked
    }
    return false; // Achievement was already unlocked
  }

  // static Future<void> addUnlockedAchievement(Achievement achievement,String? username) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = _key(username);
  //   final Set<String> unlockedAchievementIds =
  //       (prefs.getStringList(key) ?? []).toSet();
  //   unlockedAchievementIds.add(achievement.id.toString());
  //   await prefs.setStringList(key, unlockedAchievementIds.toList());
  //
  //   if (username != null) {
  //     final idsToSend = unlockedAchievementIds.map(int.parse).toList();
  //     await ApiService.updateAchievements(username, idsToSend);
  //   }
  // }

  // static Future<void> syncAchievementsFromServer(String username) async {
  //   final response = await ApiService.getAchievements(username);
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final unlockedIds = (data['unlocked_ids'] as List<dynamic>)
  //         .map((e) => e.toString())
  //         .toList();
  //
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setStringList(_key(username), unlockedIds);
  //
  //   } else {
  //     throw Exception('Failed to fetch achievements from server');
  //   }
  // }

  static Future<void> syncAchievementsFromServer(String username) async {
    if (username.isEmpty) {
      print("Cannot sync from server: username is empty.");
      return;
    }
    try {
      final response = await ApiService.getAchievements(username);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> serverUnlockedIds = [];
        if (data['unlocked_ids'] != null && data['unlocked_ids'] is List) {
          serverUnlockedIds = (data['unlocked_ids'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(_userAchievementsKey(username), serverUnlockedIds);
        print('Achievements synced from server for $username: $serverUnlockedIds');
      } else {
        // final responseBody = jsonDecode(response.body);
        // print('Failed to fetch achievements from server: ${responseBody['error'] ?? response.reasonPhrase}');
        print('Failed to fetch achievements from server for $username. Status: ${response.statusCode}');
        // Optionally, clear local achievements if server is source of truth and fails,
        // or leave them as is. For now, we just log.
      }
    } catch (e) {
      print('Error in syncAchievementsFromServer for $username: $e');
    }
  }

  static Future<void> syncGuestAchievementsToUserAccount(String loggedInUsername) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Get guest achievements
    final guestIdsStringList = prefs.getStringList(_guestAchievementsKey) ?? [];
    if (guestIdsStringList.isEmpty) {
      print('No guest achievements to sync for $loggedInUsername.');
      return; // Nothing to do
    }
    final guestAchievementIds = guestIdsStringList.map(int.parse).toSet();
    print('Found guest achievements: $guestAchievementIds to sync for $loggedInUsername');

    // 2. Get current user's achievements (which should be up-to-date if syncAchievementsFromServer was called)
    final userKey = _userAchievementsKey(loggedInUsername);
    final currentUserIdsStringList = prefs.getStringList(userKey) ?? [];
    final currentUserAchievementIds = currentUserIdsStringList.map(int.parse).toSet();

    // 3. Determine which guest achievements are new for the user
    Set<int> achievementsToSyncToServer = {};
    Set<int> allUserAchievements = Set.from(currentUserAchievementIds);

    for (int guestId in guestAchievementIds) {
      if (!currentUserAchievementIds.contains(guestId)) {
        achievementsToSyncToServer.add(guestId);
      }
      allUserAchievements.add(guestId); // Add to the merged set for local storage
    }

    // 4. Sync new achievements to the server
    if (achievementsToSyncToServer.isNotEmpty) {
      print('Syncing these new achievements to server for $loggedInUsername: $achievementsToSyncToServer');
      for (int achievementIdToSync in achievementsToSyncToServer) {
        try {
          await ApiService.unlockAchievementOnServer(loggedInUsername, achievementIdToSync);
          print('Successfully synced guest achievement $achievementIdToSync to $loggedInUsername on server.');
        } catch (e) {
          print('Failed to sync guest achievement $achievementIdToSync to server for $loggedInUsername: $e');
          // Decide on error handling:
          // - Maybe skip and try later?
          // - Maybe keep it in guest store? (complex)
          // For now, we'll assume it will be part of allUserAchievements locally
          // and might be retried if the overall sync logic is re-run.
        }
      }
    } else {
      print('No new guest achievements to sync to server for $loggedInUsername. User might already have them.');
    }

    // 5. Update the user's local SharedPreferences with the fully merged list
    await prefs.setStringList(userKey, allUserAchievements.map((id) => id.toString()).toList());
    print('Updated local achievements for $loggedInUsername: $allUserAchievements');

    // 6. Clear guest achievements from SharedPreferences
    await prefs.remove(_guestAchievementsKey);
    // await prefs.setStringList(_guestAchievementsKey, []); // Alternative to remove
    print('Cleared guest achievements from local storage.');
  }

  static Future<(List<Achievement>, List<Achievement>)>
  getAchievements(String? username) async {
    final prefs = await SharedPreferences.getInstance();

    // Use the corrected key retrieval method
    final String storageKeyToUse = _getActiveKey(username);

    final List<int> unlockedAchievementIds =
        (prefs.getStringList(storageKeyToUse) ?? []).map(int.parse).toList();

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
