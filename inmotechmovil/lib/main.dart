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
//       home: const MainPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// enum DrawerSection { perfil, inmuebles, comunicacion }

// class MainPage extends StatefulWidget {
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   DrawerSection selectedSection = DrawerSection.inmuebles;

//   Widget _getBody() {
//     switch (selectedSection) {
//       case DrawerSection.perfil:
//         return const PerfilPage();
//       case DrawerSection.inmuebles:
//         return const InmueblesPage();
//       case DrawerSection.comunicacion:
//         return const ComunicacionPage();
//     }
//   }

//   void _onSectionSelected(DrawerSection section) {
//     setState(() {
//       selectedSection = section;
//       Navigator.pop(context); // Cierra el Drawer
//     });
//   }

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
//       drawer: AppDrawer(
//         selectedSection: selectedSection,
//         onSectionSelected: _onSectionSelected,
//       ),
//       body: _getBody(),
//     );
//   }
// }

// class AppDrawer extends StatelessWidget {
//   final DrawerSection selectedSection;
//   final Function(DrawerSection) onSectionSelected;

//   const AppDrawer({
//     Key? key,
//     required this.selectedSection,
//     required this.onSectionSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final hoverColor = Theme.of(context).hoverColor;
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: const Text('Nombre de Usuario'),
//             accountEmail: const Text('usuario@email.com'),
//             currentAccountPicture: CircleAvatar(
//               backgroundImage: AssetImage('assets/profile.jpg'),
//             ),
//             decoration: const BoxDecoration(
//               color: Colors.blueGrey,
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Ver Perfil'),
//             selected: selectedSection == DrawerSection.perfil,
//             selectedTileColor: hoverColor,
//             onTap: () => onSectionSelected(DrawerSection.perfil),
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.home),
//             title: const Text('Inmuebles'),
//             selected: selectedSection == DrawerSection.inmuebles,
//             selectedTileColor: hoverColor,
//             onTap: () => onSectionSelected(DrawerSection.inmuebles),
//           ),
//           ListTile(
//             leading: const Icon(Icons.message),
//             title: const Text('Comunicación'),
//             selected: selectedSection == DrawerSection.comunicacion,
//             selectedTileColor: hoverColor,
//             onTap: () => onSectionSelected(DrawerSection.comunicacion),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Páginas de ejemplo
// class PerfilPage extends StatelessWidget {
//   const PerfilPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Perfil',
//         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// class InmueblesPage extends StatelessWidget {
//   const InmueblesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Inmuebles',
//         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// class ComunicacionPage extends StatelessWidget {
//   const ComunicacionPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Comunicación',
//         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
    final chats = [
      {
        "name": "Gina David",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "10:30am",
        "avatar": "assets/avatar1.png",
      },
      {
        "name": "Julienne Mark",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "Yesterday, 11:05am",
        "avatar": "assets/avatar2.png",
      },
      {
        "name": "John Stewart",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "September 9, 2014",
        "avatar": "assets/avatar3.png",
      },
      {
        "name": "Buddy Holly",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "September 7, 2014",
        "avatar": "assets/avatar4.png",
      },
      {
        "name": "Martha Kimbley",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "July 11, 2014",
        "avatar": "assets/avatar5.png",
      },
      {
        "name": "Tina Minelli",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "June 30, 2014",
        "avatar": "assets/avatar6.png",
      },
      {
        "name": "jonathan rendon",
        "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
        "time": "June 30, 2014",
        "avatar": "assets/avatar6.png",
      },
    ];

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(chat["avatar"]!),
            radius: 28,
          ),
          title: Text(
            chat["name"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            chat["message"]!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            chat["time"]!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          onTap: () {
            // Acción al tocar el chat
          },
        );
      },
    );
  }
}