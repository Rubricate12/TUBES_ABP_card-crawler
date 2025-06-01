import 'package:card_crawler/ui/extension/ui_scale.dart';
import 'package:card_crawler/ui/main_menu/widget/achievement_card.dart';
import 'package:card_crawler/ui/main_menu/widget/empty_entries_card.dart';
import 'package:flutter/material.dart';

import '../../../provider/gameplay/type/achievement.dart';

class AchievementsDialog extends StatelessWidget {
  const AchievementsDialog({
    super.key,
    required this.unlockedAchievements,
    required this.lockedAchievements,
  });

  final List<Achievement> unlockedAchievements;
  final List<Achievement> lockedAchievements;

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
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UNLOCKED', style: TextStyle(fontSize: 24.0 * uiScale)),
            if (unlockedAchievements.isNotEmpty)
              ...List.generate(
                unlockedAchievements.length,
                (index) => SizedBox(
                  width: double.infinity,
                  child: AchievementCard(
                    achievement: unlockedAchievements[index],
                    isUnlocked: true,
                  ),
                ),
              )
            else
              EmptyEntriesCard(message: 'None'),
            Text('LOCKED', style: TextStyle(fontSize: 24.0 * uiScale)),
            if (lockedAchievements.isNotEmpty)
              ...List.generate(
                lockedAchievements.length,
                (index) => SizedBox(
                  width: double.infinity,
                  child: AchievementCard(
                    achievement: lockedAchievements[index],
                    isUnlocked: false,
                  ),
                ),
              )
            else
              EmptyEntriesCard(message: 'None'),
          ],
        ),
      ),
    );
  }
}
