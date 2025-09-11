// import 'package:flutter/material.dart';

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
//       home: const HomePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(Icons.menu),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//         title: const Align(
//           alignment: Alignment.centerRight,
//           child: Text('INMOTECH'),
//         ),
//         backgroundColor: Colors.blueGrey,
//       ),
//       drawer: const AppDrawer(),
//       body: const Center(
//         child: Text(
//           'Pantalla principal',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: const Text('Nombre de Usuario'),
//             accountEmail: const Text('usuario@email.com'),
//             currentAccountPicture: CircleAvatar(
//               backgroundImage: AssetImage('assets/profile.jpg'), // Cambia por tu imagen
//             ),
//             decoration: const BoxDecoration(
//               color: Colors.blueGrey,
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Ver Perfil'),
//             onTap: () {
//               // Navega a la pantalla de perfil
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.home),
//             title: const Text('Inmuebles'),
//             onTap: () {
//               // Navega a la sección de inmuebles
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.message),
//             title: const Text('Comunicación'),
//             onTap: () {
//               // Navega a la sección de comunicación
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

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
      Navigator.pop(context); // Cierra el Drawer
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

// Páginas de ejemplo
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

class InmueblesPage extends StatelessWidget {
  const InmueblesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Inmuebles',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ComunicacionPage extends StatelessWidget {
  const ComunicacionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Comunicación',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}