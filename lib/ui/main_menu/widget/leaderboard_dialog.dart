import 'package:card_crawler/provider/main_menu/model/leaderboard_entry.dart';
import 'package:card_crawler/ui/extension/ui_scale.dart';
import 'package:card_crawler/ui/main_menu/widget/leaderboard_entry_card.dart';
import 'package:flutter/material.dart';

import 'empty_entries_card.dart';

class LeaderboardDialog extends StatelessWidget {
  const LeaderboardDialog({super.key, required this.leaderboardEntries});

  final List<LeaderboardEntry> leaderboardEntries;

  @override
  Widget build(BuildContext context) {
    final double uiScale = context.uiScale();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      width: 576.0 * uiScale + 48.0,
      clipBehavior: Clip.antiAlias,
      child:
          leaderboardEntries.isNotEmpty
              ? ListView.builder(
                padding: EdgeInsets.all(24.0),
                itemCount: leaderboardEntries.length,
                itemBuilder:
                    (context, index) => SizedBox(
                      width: double.infinity,
                      child: LeaderboardEntryCard(
                        rank: index + 1,
                        leaderboardEntry: leaderboardEntries[index],
                      ),
                    ),
              )
              : Padding(
                padding: EdgeInsets.all(24),
                child: EmptyEntriesCard(message: 'Leaderboard is empty'),
              ),
    );
  }
}
