import 'package:consuming_api/views/Home/home.dart';
import 'package:consuming_api/views/Home/market.dart';
import 'package:consuming_api/views/Login/login_view.dart';
import 'package:consuming_api/views/Register/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) => const Home(),
        '/market': (context) => const Market(),
      },
    );
  }
}
