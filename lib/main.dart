import 'package:flutter/material.dart';
import 'package:leare_fa/pages/loggedin_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const LoggedInPage(),
      },
    );
  }
}
