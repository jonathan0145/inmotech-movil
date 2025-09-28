// import 'package:flutter/material.dart';
// import 'pages/main_page.dart';

// void main() {
//   runApp(const InmotechApp());
// }

// class InmotechApp extends StatelessWidget {
//   const InmotechApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'INMOTECH',
//       theme: ThemeData.dark(),
//       home: const MainPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'pages/loading_page.dart';
import 'pages/auth/login.dart';
import 'pages/auth/register.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inmotech Movil',
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => const LoadingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/main': (context) => const MainPage(),
      },
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}//*lo