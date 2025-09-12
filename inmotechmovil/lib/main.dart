import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const InmotechApp());
}

class InmotechApp extends StatelessWidget {
  const InmotechApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INMOTECH',
      theme: ThemeData.dark(),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}