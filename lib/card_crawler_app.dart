import 'package:card_crawler/provider/gameplay/model/game_data.dart';
import 'package:card_crawler/ui/main_menu/main_menu_screen.dart';
import 'package:card_crawler/ui/type/game_route.dart';
import 'package:card_crawler/ui/gameplay/gameplay_screen.dart';
import 'package:card_crawler/ui/welcome_menu/welcome_screen.dart';
import 'package:card_crawler/ui/register/register_screen.dart';
import 'package:flutter/material.dart';

class CardCrawlerApp extends StatelessWidget {
  const CardCrawlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Crawler',
      theme: ThemeData(fontFamily: 'ConcertOne'),
      initialRoute: GameRoute.welcomeMenu.path,
      routes: {
        GameRoute.welcomeMenu.path: (context) => WelcomeScreen(),
        GameRoute.auth.path: (context) => const RegScreen(),
        GameRoute.mainMenu.path: (context) => const MainMenuScreen(),
        GameRoute.gameplay.path:
            (context) => GameplayScreen(
              gameData: ModalRoute.of(context)?.settings.arguments as GameData?,
            ),
      },
    );
  }
}
