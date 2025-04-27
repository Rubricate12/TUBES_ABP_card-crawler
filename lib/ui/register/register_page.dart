import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'dart:convert';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<RegScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLogin = true; // Toggle between login/register

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Username and password are required!');
      return;
    }

    try {
      final response = isLogin
          ? await ApiService.login(username, password)
          : await ApiService.registerUser(username, password);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        _showMessage('Success: ${data['message'] ?? 'Logged in/Registered successfully!'}');
      } else {
        final data = json.decode(response.body);
        _showMessage('Error: ${data['message'] ?? 'Something went wrong!'}');
      }
    } catch (e) {
      _showMessage('Failed to connect to server.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              child: Text(isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? 'Create new account' : 'Already have an account? Login'),
            )
          ],
        ),
      ),
    );
  }
}