import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Perfil',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}