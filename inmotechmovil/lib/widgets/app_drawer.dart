import 'package:flutter/material.dart';
import '../pages/main_page.dart';

class AppDrawer extends StatelessWidget {
  final DrawerSection selectedSection;
  final Function(DrawerSection) onSectionSelected;

  const AppDrawer({
    Key? key,
    required this.selectedSection,
    required this.onSectionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hoverColor = Theme.of(context).hoverColor;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Nombre de Usuario'),
            accountEmail: const Text('usuario@email.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Ver Perfil'),
            selected: selectedSection == DrawerSection.perfil,
            selectedTileColor: hoverColor,
            onTap: () => onSectionSelected(DrawerSection.perfil),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inmuebles'),
            selected: selectedSection == DrawerSection.inmuebles,
            selectedTileColor: hoverColor,
            onTap: () => onSectionSelected(DrawerSection.inmuebles),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Comunicación'),
            selected: selectedSection == DrawerSection.comunicacion,
            selectedTileColor: hoverColor,
            onTap: () => onSectionSelected(DrawerSection.comunicacion),
          ),
        ],
      ),
    );
  }
}