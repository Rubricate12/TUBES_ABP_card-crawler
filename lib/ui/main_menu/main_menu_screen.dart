import 'package:card_crawler/card_crawler_app.dart';
import 'package:card_crawler/provider/main_menu/main_menu_provider.dart';
import 'package:card_crawler/ui/extension/ui_scale.dart';
import 'package:card_crawler/ui/main_menu/widget/achievements_dialog.dart';
import 'package:card_crawler/ui/type/game_route.dart';
import 'package:card_crawler/ui/widget/dialog_scrim.dart';
import 'package:card_crawler/ui/widget/menu_container.dart';
import 'package:card_crawler/ui/widget/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_crawler/provider/auth/auth_provider.dart';

import '../theme/color.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with RouteAware {
  bool isAchievementsDialogVisible = false;

  void _refreshStates() {
    final username = context.read<AuthProvider>().username;
    context.read<MainMenuProvider>().loadAchievements(username);
    context.read<MainMenuProvider>().loadGameData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _refreshStates();
  }

  @override
  void didPush() {
    _refreshStates();
  }

  @override
  Widget build(BuildContext context) {
    final double uiScale = context.uiScale();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<MainMenuProvider>(
        builder:
            (context, provider, child) => Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/backgrounds/main.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: MenuContainer(
                    children: [
                      MenuItem(
                        title: 'NEW GAME',
                        onPressed: () {
                          Navigator.pushNamed(context, GameRoute.gameplay.path);
                        },
                      ),
                      MenuItem(
                        title: 'CONTINUE',
                        onPressed:
                            provider.savedGameData == null
                                ? null
                                : () {
                                  Navigator.pushNamed(
                                    context,
                                    GameRoute.gameplay.path,
                                    arguments: provider.savedGameData,
                                  );
                                },
                      ),
                      MenuItem(title: 'LEADERBOARD', onPressed: null),
                      MenuItem(
                        title: 'ACHIEVEMENTS',
                        onPressed: () {
                          final username =
                              context.read<AuthProvider>().username;
                          context.read<MainMenuProvider>().loadAchievements(
                            username,
                          );
                          setState(() {
                            isAchievementsDialogVisible = true;
                          });
                        },
                      ),
                      MenuItem(
                        title: 'SWITCH ACCOUNT',
                        onPressed: () {
                          context.read<AuthProvider>().logout();
                          Navigator.pushReplacementNamed(
                            context,
                            GameRoute.welcome.path,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (isAchievementsDialogVisible)
                  DialogScrim(
                    onDismiss: () {
                      setState(() {
                        isAchievementsDialogVisible = false;
                      });
                    },
                    margin: EdgeInsets.all(64.0 * uiScale),
                    child: AchievementsDialog(
                      unlockedAchievements: provider.unlockedAchievements,
                      lockedAchievements: provider.lockedAchievements,
                    ),
                  ),
              ],
            ),
      ),
    );
  }
}
