import 'dart:convert';

import 'package:card_crawler/data/achievements_service.dart';
import 'package:card_crawler/ui/extension/ui_scale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth/auth_provider.dart';
import '../../../data/api_service.dart';
import '../../type/game_route.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  bool _isLogin = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Username and password cannot be empty!');
      return;
    }

    try {
      final response = _isLogin
          ? await ApiService.login(username, password)
          : await ApiService.register(username, password);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['user'] == null || data['user']['username'] == null) {
          _showMessage('Error: Invalid response from server - user data missing.');
          return;
        }

        final String authenticatedUsername = data['user']['username'];

        if (authenticatedUsername.isEmpty) {
          _showMessage('Error: Invalid response from server - username is empty.');
          return;
        }

        _showMessage('Success: ${data['message'] ?? '${_isLogin ? 'Logged in' : 'Registered'} successfully!'}');

        if(!mounted) return;

        Provider.of<AuthProvider>(context, listen: false).login(authenticatedUsername);
        AchievementsService.syncAchievements(username);
        if (mounted) {
          Navigator.pushReplacementNamed(context, GameRoute.mainMenu.path);
        }
      } else {
        final data = json.decode(response.body);
        _showMessage('Error: ${data['message'] ?? 'Something went wrong!'}');
      }
    } catch (e) {
      _showMessage('Failed to connect to server: $e');
    }
  }

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isLogin ? 'Login' : 'Register',
              style: TextStyle(fontSize: 48.0 * uiScale),
            ),
            SizedBox(height: 24.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Color(0xFFD1FFFA),
                overlayColor: Colors.black,
              ),
              child: Text(_isLogin ? 'LOGIN' : 'REGISTER'),
            ),
            SizedBox(height: 12.0),
            TextButton(
              onPressed: () {
                _usernameController.clear();
                _passwordController.clear();

                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                overlayColor: Colors.black,
              ),
              child: Text(
                _isLogin
                    ? 'Create new account'
                    : 'Already have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
