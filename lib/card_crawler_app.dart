import 'package:card_crawler/provider/gameplay/model/game_data.dart';
import 'package:card_crawler/ui/main_menu/main_menu_screen.dart';
import 'package:card_crawler/ui/type/game_route.dart';
import 'package:card_crawler/ui/gameplay/gameplay_screen.dart';
import 'package:card_crawler/ui/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class CardCrawlerApp extends StatelessWidget {
  const CardCrawlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Crawler',
      theme: ThemeData(
        fontFamily: 'ConcertOne',
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black.withValues(alpha: 0.4),
          selectionHandleColor: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          floatingLabelStyle: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: GameRoute.welcome.path,
      routes: {
        GameRoute.welcome.path: (context) => WelcomeScreen(),
        GameRoute.mainMenu.path: (context) => const MainMenuScreen(),
        GameRoute.gameplay.path:
            (context) => GameplayScreen(
              gameData: ModalRoute.of(context)?.settings.arguments as GameData?,
            ),
      },
      navigatorObservers: [routeObserver],
    );
  }
}
