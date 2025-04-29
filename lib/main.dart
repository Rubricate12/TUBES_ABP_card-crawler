import 'package:card_crawler/card_crawler_app.dart';
import 'package:card_crawler/provider/gameplay/gameplay_provider.dart';
import 'package:card_crawler/provider/main_menu/main_menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainMenuProvider()),
        ChangeNotifierProvider(create: (context) => GameplayProvider()),
      ],
      child: CardCrawlerApp(),
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'ui/register/register_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Auth Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const RegScreen(),
//     );
//   }
// }
