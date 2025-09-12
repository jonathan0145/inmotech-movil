import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'perfil_page.dart';
import 'inmuebles_page.dart';
import 'comunicacion_page.dart';

enum DrawerSection { perfil, inmuebles, comunicacion }

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DrawerSection selectedSection = DrawerSection.inmuebles;

  Widget _getBody() {
    switch (selectedSection) {
      case DrawerSection.perfil:
        return const PerfilPage();
      case DrawerSection.inmuebles:
        return const InmueblesPage();
      case DrawerSection.comunicacion:
        return const ComunicacionPage();
    }
  }

  void _onSectionSelected(DrawerSection section) {
    setState(() {
      selectedSection = section;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text('INMOTECH'),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: AppDrawer(
        selectedSection: selectedSection,
        onSectionSelected: _onSectionSelected,
      ),
      body: _getBody(),
    );
  }
}