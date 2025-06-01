import 'package:card_crawler/ui/extension/ui_scale.dart';
import 'package:card_crawler/ui/theme/color.dart';
import 'package:card_crawler/ui/welcome/widget/auth_dialog.dart';
import 'package:card_crawler/ui/widget/menu_container.dart';
import 'package:card_crawler/ui/widget/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:card_crawler/ui/type/game_route.dart';

import '../widget/dialog_scrim.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isAuthDialogVisible = false;

  @override
  Widget build(BuildContext context) {
    final double uiScale = context.uiScale();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/main.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Card Crawler',
                style: TextStyle(color: Colors.white, fontSize: 48.0 * uiScale),
              ),
              SizedBox(height: 48.0),
              MenuContainer(
                children: [
                  MenuItem(
                    title: 'LOGIN',
                    onPressed: () {
                      setState(() {
                        isAuthDialogVisible = true;
                      });
                    },
                  ),
                  MenuItem(
                    title: 'PLAY AS GUEST',
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        GameRoute.mainMenu.path,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          if (isAuthDialogVisible)
            DialogScrim(
              onDismiss: () {
                setState(() {
                  isAuthDialogVisible = false;
                });
              },
              margin: EdgeInsets.all(64.0 * uiScale),
              child: AuthDialog(),
            ),
        ],
      ),
    );
  }
}
