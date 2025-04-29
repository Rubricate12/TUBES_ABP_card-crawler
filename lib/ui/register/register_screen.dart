import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'dart:convert';
import 'package:card_crawler/ui/type/game_route.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<RegScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late bool isLogin = true; // Toggle between login/register

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

        await Future.delayed(const Duration(milliseconds:50));

        //pindah ke MainMenu
        if(!mounted) return; //check agar tidak ada masalah context
        if(isLogin == true){
          Navigator.pushReplacementNamed(context, GameRoute.mainMenu.path);
        }else{
          _usernameController.clear();
          _passwordController.clear();
          setState(() {
            isLogin = true;
          });
        }
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    //mengambil argumen dari navigator.pushnamed (karena islogin baru ada setelah build context)
    final args = ModalRoute.of(context)?.settings.arguments;
    //ubah islogin
    isLogin = args is bool ? args : true; // Default to login if null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // This will go back to WelcomeScreen
          },
        ),
        centerTitle: true, // Center the title
        title: Text(
          isLogin ? 'Login' : 'Register',
          style: const TextStyle(
            fontSize: 30, // Make it bigger
            fontWeight: FontWeight.bold,
          ),
        ),
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
                _usernameController.clear();
                _passwordController.clear();
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