// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const InmotechApp());
// // }

// // class InmotechApp extends StatelessWidget {
// //   const InmotechApp({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'INMOTECH',
// //       theme: ThemeData.dark(),
// //       home: const MainPage(),
// //       debugShowCheckedModeBanner: false,
// //     );
// //   }
// // }

// // enum DrawerSection { perfil, inmuebles, comunicacion }

// // class MainPage extends StatefulWidget {
// //   const MainPage({Key? key}) : super(key: key);

// //   @override
// //   State<MainPage> createState() => _MainPageState();
// // }

// // class _MainPageState extends State<MainPage> {
// //   DrawerSection selectedSection = DrawerSection.inmuebles;

// //   Widget _getBody() {
// //     switch (selectedSection) {
// //       case DrawerSection.perfil:
// //         return const PerfilPage();
// //       case DrawerSection.inmuebles:
// //         return const InmueblesPage();
// //       case DrawerSection.comunicacion:
// //         return const ComunicacionPage();
// //     }
// //   }

// //   void _onSectionSelected(DrawerSection section) {
// //     setState(() {
// //       selectedSection = section;
// //       Navigator.pop(context); // Cierra el Drawer
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: Builder(
// //           builder: (context) => IconButton(
// //             icon: const Icon(Icons.menu),
// //             onPressed: () => Scaffold.of(context).openDrawer(),
// //           ),
// //         ),
// //         title: const Align(
// //           alignment: Alignment.centerRight,
// //           child: Text('INMOTECH'),
// //         ),
// //         backgroundColor: Colors.blueGrey,
// //       ),
// //       drawer: AppDrawer(
// //         selectedSection: selectedSection,
// //         onSectionSelected: _onSectionSelected,
// //       ),
// //       body: _getBody(),
// //     );
// //   }
// // }

// // class AppDrawer extends StatelessWidget {
// //   final DrawerSection selectedSection;
// //   final Function(DrawerSection) onSectionSelected;

// //   const AppDrawer({
// //     Key? key,
// //     required this.selectedSection,
// //     required this.onSectionSelected,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final hoverColor = Theme.of(context).hoverColor;
// //     return Drawer(
// //       child: ListView(
// //         padding: EdgeInsets.zero,
// //         children: [
// //           UserAccountsDrawerHeader(
// //             accountName: const Text('Nombre de Usuario'),
// //             accountEmail: const Text('usuario@email.com'),
// //             currentAccountPicture: CircleAvatar(
// //               backgroundImage: AssetImage('assets/profile.jpg'),
// //             ),
// //             decoration: const BoxDecoration(
// //               color: Colors.blueGrey,
// //             ),
// //           ),
// //           ListTile(
// //             leading: const Icon(Icons.person),
// //             title: const Text('Ver Perfil'),
// //             selected: selectedSection == DrawerSection.perfil,
// //             selectedTileColor: hoverColor,
// //             onTap: () => onSectionSelected(DrawerSection.perfil),
// //           ),
// //           const Divider(),
// //           ListTile(
// //             leading: const Icon(Icons.home),
// //             title: const Text('Inmuebles'),
// //             selected: selectedSection == DrawerSection.inmuebles,
// //             selectedTileColor: hoverColor,
// //             onTap: () => onSectionSelected(DrawerSection.inmuebles),
// //           ),
// //           ListTile(
// //             leading: const Icon(Icons.message),
// //             title: const Text('Comunicación'),
// //             selected: selectedSection == DrawerSection.comunicacion,
// //             selectedTileColor: hoverColor,
// //             onTap: () => onSectionSelected(DrawerSection.comunicacion),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // Páginas de ejemplo
// // class PerfilPage extends StatelessWidget {
// //   const PerfilPage({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text(
// //         'Perfil',
// //         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
// //       ),
// //     );
// //   }
// // }

// // class InmueblesPage extends StatelessWidget {
// //   const InmueblesPage({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Center(
// //       child: Text(
// //         'Inmuebles',
// //         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
// //       ),
// //     );
// //   }
// // }

// // class ComunicacionPage extends StatelessWidget {
// //   const ComunicacionPage({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final chats = [
// //       {
// //         "name": "Gina David",
// //         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
// //         "time": "10:30am",
// //         "avatar": "assets/avatar1.png",
// //       },
// //       {
// //         "name": "Julienne Mark",
// //         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
// //         "time": "Yesterday, 11:05am",
// //         "avatar": "assets/avatar2.png",
// //       },
// //       {
// //         "name": "John Stewart",
// //         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
// //         "time": "September 9, 2014",
// //         "avatar": "assets/avatar3.png",
// //       },
// //       {
// //         "name": "Buddy Holly",
// //         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
// //         "time": "September 7, 2014",
// //         "avatar": "assets/avatar4.png",
// //       },
// //       {
// //         "name": "Martha Kimbley",
// //         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
// //         "time": "July 11, 2014",
// //         "avatar": "assets/avatar5.png",
// //       },
// //       {
// //         "name": "Tina Minelli",
// //         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
// //         "time": "June 30, 2014",
// //         "avatar": "assets/avatar6.png",
// //       },
// //       {
// //         "name": "jonathan rendon",
// //         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
// //         "time": "June 30, 2014",
// //         "avatar": "assets/avatar6.png",
// //       },
// //     ];

// //     return ListView.separated(
// //       itemCount: chats.length,
// //       separatorBuilder: (context, index) => const Divider(),
// //       itemBuilder: (context, index) {
// //         final chat = chats[index];
// //         return ListTile(
// //           leading: CircleAvatar(
// //             backgroundImage: AssetImage(chat["avatar"]!),
// //             radius: 28,
// //           ),
// //           title: Text(
// //             chat["name"]!,
// //             style: const TextStyle(fontWeight: FontWeight.bold),
// //           ),
// //           subtitle: Text(
// //             chat["message"]!,
// //             maxLines: 2,
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //           trailing: Text(
// //             chat["time"]!,
// //             style: const TextStyle(fontSize: 12, color: Colors.grey),
// //           ),
// //           onTap: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => ChatPage(
// //                   name: chat["name"]!,
// //                   avatar: chat["avatar"]!,
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// // }

// // class ChatPage extends StatefulWidget {
// //   final String name;
// //   final String avatar;

// //   const ChatPage({Key? key, required this.name, required this.avatar}) : super(key: key);

// //   @override
// //   State<ChatPage> createState() => _ChatPageState();
// // }

// // class _ChatPageState extends State<ChatPage> {
// //   final List<Map<String, dynamic>> messages = [
// //     {
// //       "fromMe": false,
// //       "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit",
// //       "time": "Yesterday, 11:05am"
// //     },
// //     {
// //       "fromMe": true,
// //       "text": "lorem ipsum!!"
// //     },
// //     {
// //       "fromMe": false,
// //       "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit"
// //     },
// //     {
// //       "fromMe": true,
// //       "text": "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
// //     },
// //     {
// //       "fromMe": false,
// //       "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit"
// //     },
// //     {
// //       "fromMe": true,
// //       "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."
// //     },
// //   ];

// //   final TextEditingController _controller = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: BackButton(),
// //         title: Text(widget.name, style: const TextStyle(color: Colors.black)),
// //         actions: [
// //           Padding(
// //             padding: const EdgeInsets.only(right: 16.0),
// //             child: CircleAvatar(
// //               backgroundImage: AssetImage(widget.avatar),
// //             ),
// //           ),
// //         ],
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black,
// //         elevation: 1,
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
// //               itemCount: messages.length,
// //               itemBuilder: (context, index) {
// //                 final msg = messages[index];
// //                 final isMe = msg["fromMe"] as bool;
// //                 final showTime = msg.containsKey("time");
// //                 return Column(
// //                   crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //                   children: [
// //                     if (showTime)
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(vertical: 8),
// //                         child: Center(
// //                           child: Text(
// //                             msg["time"],
// //                             style: const TextStyle(color: Colors.grey, fontSize: 13),
// //                           ),
// //                         ),
// //                       ),
// //                     Row(
// //                       mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
// //                       crossAxisAlignment: CrossAxisAlignment.end,
// //                       children: [
// //                         if (!isMe)
// //                           Padding(
// //                             padding: const EdgeInsets.only(right: 8.0),
// //                             child: CircleAvatar(
// //                               backgroundImage: AssetImage(widget.avatar),
// //                               radius: 20,
// //                             ),
// //                           ),
// //                         Flexible(
// //                           child: Container(
// //                             margin: const EdgeInsets.symmetric(vertical: 4),
// //                             padding: const EdgeInsets.all(12),
// //                             decoration: BoxDecoration(
// //                               color: isMe ? Colors.blue[400] : Colors.grey[200],
// //                               borderRadius: BorderRadius.only(
// //                                 topLeft: const Radius.circular(16),
// //                                 topRight: const Radius.circular(16),
// //                                 bottomLeft: Radius.circular(isMe ? 16 : 0),
// //                                 bottomRight: Radius.circular(isMe ? 0 : 16),
// //                               ),
// //                             ),
// //                             child: Text(
// //                               msg["text"],
// //                               style: TextStyle(
// //                                 color: isMe ? Colors.white : Colors.black87,
// //                                 fontSize: 15,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         if (isMe)
// //                           const SizedBox(width: 40), // Espacio para simetría
// //                       ],
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //           Container(
// //             color: Colors.grey[100],
// //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
// //             child: Row(
// //               children: [
// //                 IconButton(
// //                   icon: const Icon(Icons.camera_alt, color: Colors.grey),
// //                   onPressed: () {},
// //                 ),
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _controller,
// //                     decoration: const InputDecoration(
// //                       hintText: "Type message here...",
// //                       border: InputBorder.none,
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: const Icon(Icons.send, color: Colors.blue),
// //                   onPressed: () {
// //                     if (_controller.text.trim().isNotEmpty) {
// //                       setState(() {
// //                         messages.add({
// //                           "fromMe": true,
// //                           "text": _controller.text.trim(),
// //                         });
// //                         _controller.clear();
// //                       });
// //                     }
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

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
//     final chats = [
//       {
//         "name": "Gina David",
//         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
//         "time": "10:30am",
//         "avatar": "assets/avatar1.png",
//       },
//       {
//         "name": "Julienne Mark",
//         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
//         "time": "Yesterday, 11:05am",
//         "avatar": "assets/avatar2.png",
//       },
//       {
//         "name": "John Stewart",
//         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
//         "time": "September 9, 2014",
//         "avatar": "assets/avatar3.png",
//       },
//       {
//         "name": "Buddy Holly",
//         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
//         "time": "September 7, 2014",
//         "avatar": "assets/avatar4.png",
//       },
//       {
//         "name": "Martha Kimbley",
//         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
//         "time": "July 11, 2014",
//         "avatar": "assets/avatar5.png",
//       },
//       {
//         "name": "Tina Minelli",
//         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
//         "time": "June 30, 2014",
//         "avatar": "assets/avatar6.png",
//       },
//       {
//         "name": "jonathan rendon",
//         "message": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...",
//         "time": "June 30, 2014",
//         "avatar": "assets/avatar6.png",
//       },
//     ];

//     return ListView.separated(
//       itemCount: chats.length,
//       separatorBuilder: (context, index) => const Divider(),
//       itemBuilder: (context, index) {
//         final chat = chats[index];
//         return ListTile(
//           leading: CircleAvatar(
//             backgroundImage: AssetImage(chat["avatar"]!),
//             radius: 28,
//           ),
//           title: Text(
//             chat["name"]!,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(
//             chat["message"]!,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           trailing: Text(
//             chat["time"]!,
//             style: const TextStyle(fontSize: 12, color: Colors.grey),
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatPage(
//                   name: chat["name"]!,
//                   avatar: chat["avatar"]!,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class ChatPage extends StatefulWidget {
//   final String name;
//   final String avatar;

//   const ChatPage({Key? key, required this.name, required this.avatar}) : super(key: key);

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final List<Map<String, dynamic>> messages = [
//     {
//       "fromMe": false,
//       "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit",
//       "time": "Yesterday, 11:05am"
//     },
//     {
//       "fromMe": true,
//       "text": "lorem ipsum!!"
//     },
//     {
//       "fromMe": false,
//       "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit"
//     },
//     {
//       "fromMe": true,
//       "text": "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
//     },
//     {
//       "fromMe": false,
//       "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit"
//     },
//     {
//       "fromMe": true,
//       "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."
//     },
//   ];

//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final darkBg = Theme.of(context).scaffoldBackgroundColor;

//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(color: Colors.white),
//         title: Text(widget.name, style: const TextStyle(color: Colors.white)),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: CircleAvatar(
//               backgroundImage: AssetImage(widget.avatar),
//             ),
//           ),
//         ],
//         backgroundColor: darkBg,
//         foregroundColor: Colors.white,
//         elevation: 1,
//       ),
//       backgroundColor: darkBg,
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[index];
//                 final isMe = msg["fromMe"] as bool;
//                 final showTime = msg.containsKey("time");
//                 return Column(
//                   crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                   children: [
//                     if (showTime)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: Center(
//                           child: Text(
//                             msg["time"],
//                             style: const TextStyle(color: Colors.grey, fontSize: 13),
//                           ),
//                         ),
//                       ),
//                     Row(
//                       mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         if (!isMe)
//                           Padding(
//                             padding: const EdgeInsets.only(right: 8.0),
//                             child: CircleAvatar(
//                               backgroundImage: AssetImage(widget.avatar),
//                               radius: 20,
//                             ),
//                           ),
//                         Flexible(
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: isMe ? Colors.blue[400] : Colors.grey[200],
//                               borderRadius: BorderRadius.only(
//                                 topLeft: const Radius.circular(16),
//                                 topRight: const Radius.circular(16),
//                                 bottomLeft: Radius.circular(isMe ? 16 : 0),
//                                 bottomRight: Radius.circular(isMe ? 0 : 16),
//                               ),
//                             ),
//                             child: Text(
//                               msg["text"],
//                               style: TextStyle(
//                                 color: isMe ? Colors.white : Colors.black87,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ),
//                         ),
//                         if (isMe)
//                           const SizedBox(width: 40), // Espacio para simetría
//                       ],
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           Container(
//             color: darkBg,
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.camera_alt, color: Colors.white54),
//                   onPressed: () {},
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       hintText: "Type message here...",
//                       hintStyle: TextStyle(color: Colors.white54),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.blue),
//                   onPressed: () {
//                     if (_controller.text.trim().isNotEmpty) {
//                       setState(() {
//                         messages.add({
//                           "fromMe": true,
//                           "text": _controller.text.trim(),
//                         });
//                         _controller.clear();
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  name: chat["name"]!,
                  avatar: chat["avatar"]!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChatPage extends StatefulWidget {
  final String name;
  final String avatar;

  const ChatPage({Key? key, required this.name, required this.avatar}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> messages = [
    {
      "fromMe": false,
      "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit",
      "time": "Yesterday, 11:05am"
    },
    {
      "fromMe": true,
      "text": "lorem ipsum!!"
    },
    {
      "fromMe": false,
      "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit"
    },
    {
      "fromMe": true,
      "text": "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
    },
    {
      "fromMe": false,
      "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit"
    },
    {
      "fromMe": true,
      "text": "lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."
    },
  ];

  final TextEditingController _controller = TextEditingController();

  // Color personalizado para appbar y barra inferior
  final Color customBarColor = const Color(0xFF6B8796); // Color de la imagen proporcionada
  final Color inputFieldColor = Color(0xFFB0C4CE); // Un azul claro para el campo de texto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Text(widget.name, style: const TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(widget.avatar),
            ),
          ),
        ],
        backgroundColor: customBarColor,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg["fromMe"] as bool;
                final showTime = msg.containsKey("time");
                return Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (showTime)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Text(
                            msg["time"],
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isMe)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(widget.avatar),
                              radius: 20,
                            ),
                          ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[400] : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 0),
                                bottomRight: Radius.circular(isMe ? 0 : 16),
                              ),
                            ),
                            child: Text(
                              msg["text"],
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        if (isMe)
                          const SizedBox(width: 40), // Espacio para simetría
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            color: customBarColor,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white70),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: inputFieldColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        hintText: "Type message here...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      setState(() {
                        messages.add({
                          "fromMe": true,
                          "text": _controller.text.trim(),
                        });
                        _controller.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}