import 'package:card_crawler/provider/main_menu/model/leaderboard_entry.dart';
import 'package:card_crawler/ui/extension/ui_scale.dart';
import 'package:flutter/material.dart';

class LeaderboardEntryCard extends StatelessWidget {
  const LeaderboardEntryCard({
    super.key,
    required this.rank,
    required this.leaderboardEntry,
  });

  final int rank;
  final LeaderboardEntry leaderboardEntry;

  @override
  Widget build(BuildContext context) {
    final uiScale = context.uiScale();

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.all(4.0 * uiScale),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(16.0 * uiScale),
        child: Row(
          children: [
            Text(rank.toString(), style: TextStyle(fontSize: 24.0 * uiScale)),
            SizedBox(width: 16.0 * uiScale),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leaderboardEntry.username,
                  style: TextStyle(fontSize: 14.0 * uiScale),
                ),
                Text(
                  leaderboardEntry.score.toString(),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12.0 * uiScale,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
