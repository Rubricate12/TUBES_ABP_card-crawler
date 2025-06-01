import 'package:card_crawler/card_crawler_app.dart';
import 'package:card_crawler/provider/gameplay/gameplay_provider.dart';
import 'package:card_crawler/provider/main_menu/main_menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:card_crawler/provider/auth/auth_provider.dart';

import 'platform/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  configureApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainMenuProvider()),
        ChangeNotifierProvider(create: (context) => GameplayProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: CardCrawlerApp(),
    ),
  );
}
