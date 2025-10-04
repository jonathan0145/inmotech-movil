import 'package:flutter/material.dart';
import '../utils/drawer_sections.dart';  // ← IMPORTAR

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 64,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  'Usuario',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Inmuebles', // ← Solo este item, que incluye ambos tabs
            section: DrawerSection.inmuebles,
          ),
          _buildDrawerItem(
            icon: Icons.chat,
            title: 'Comunicación',
            section: DrawerSection.comunicacion,
          ),
          _buildDrawerItem(
            icon: Icons.person,
            title: 'Perfil',
            section: DrawerSection.perfil,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              // Implementar logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required DrawerSection section,
  }) {
    final isSelected = selectedSection == section;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blueGrey : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blueGrey : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blueGrey.withOpacity(0.1),
      onTap: () => onSectionSelected(section),
    );
  }
}