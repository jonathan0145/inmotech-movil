// import 'package:flutter/material.dart';

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

//   final Color customBarColor = const Color(0xFF6B8796);
//   final Color inputFieldColor = Color(0xFFB0C4CE);

//   Map<String, dynamic> get perfil => {
//     "nombre": widget.name,
//     "email": "gina.david@email.com",
//     "telefono": "+57 300 123 4567",
//     "avatar": widget.avatar,
//   };

//   final List<Map<String, dynamic>> inmuebles = [
//     {
//       "titulo": "Apartamento en Medellín",
//       "direccion": "Cra 45 # 10-23, Medellín",
//       "precio": "\$1.200.000 COP",
//       "descripcion": "Hermoso apartamento de 2 habitaciones, 2 baños, parqueadero y balcón.",
//       "imagenes": [
//         "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
//         "https://images.unsplash.com/photo-1460518451285-97b6aa326961",
//       ],
//       "area": 80,
//       "terreno": 0,
//       "habitaciones": 2,
//       "banos": 2,
//     },
//     {
//       "titulo": "Casa en Envigado",
//       "direccion": "Calle 12 Sur # 34-56, Envigado",
//       "precio": "\$2.500.000 COP",
//       "descripcion": "Casa amplia con jardín y garaje doble.",
//       "imagenes": [
//         "https://images.unsplash.com/photo-1460518451285-97b6aa326961",
//         "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd",
//       ],
//       "area": 200,
//       "terreno": 300,
//       "habitaciones": 4,
//       "banos": 3,
//     },
//     {
//       "titulo": "Estudio en Laureles",
//       "direccion": "Av. Nutibara # 70-80, Laureles",
//       "precio": "\$900.000 COP",
//       "descripcion": "Estudio moderno, excelente ubicación.",
//       "imagenes": [
//         "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd",
//         "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
//       ],
//       "area": 40,
//       "terreno": 0,
//       "habitaciones": 1,
//       "banos": 1,
//     },
//   ];

//   void _showInmuebleDetailModal(Map<String, dynamic> inmueble) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF18181B), // Fondo oscuro
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) {
//         final imagenes = List<String>.from(inmueble["imagenes"] ?? []);
//         return Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 5,
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[700],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 if (imagenes.isNotEmpty)
//                   SizedBox(
//                     height: 200,
//                     child: PageView.builder(
//                       itemCount: imagenes.length,
//                       itemBuilder: (context, index) {
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.network(
//                             imagenes[index],
//                             height: 200,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 const SizedBox(height: 16),
//                 Text(
//                   inmueble["titulo"] ?? "",
//                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(inmueble["direccion"] ?? "", style: const TextStyle(fontSize: 16, color: Colors.white70)),
//                 const SizedBox(height: 8),
//                 Text(inmueble["precio"] ?? "", style: const TextStyle(fontSize: 16, color: Colors.greenAccent)),
//                 const SizedBox(height: 12),
//                 Text(inmueble["descripcion"] ?? "", style: const TextStyle(fontSize: 15, color: Colors.white70)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showProfileModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) {
//         final theme = Theme.of(context);
//         return Container(
//           decoration: const BoxDecoration(
//             color: Color(0xFF18181B), // Fondo oscuro
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: DefaultTabController(
//             length: 2,
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.65,
//               child: Column(
//                 children: [
//                   const SizedBox(height: 12),
//                   Container(
//                     width: 40,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[700],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   const TabBar(
//                     labelColor: Colors.white,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Colors.white,
//                     tabs: [
//                       Tab(text: "Perfil"),
//                       Tab(text: "Inmueble"),
//                     ],
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       children: [
//                         // Perfil
//                         Padding(
//                           padding: const EdgeInsets.all(24.0),
//                           child: Column(
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage: AssetImage(perfil["avatar"]),
//                                 radius: 40,
//                                 backgroundColor: theme.primaryColorDark,
//                               ),
//                               const SizedBox(height: 16),
//                               Text(
//                                 perfil["nombre"],
//                                 style: const TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 perfil["email"],
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[400],
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 perfil["telefono"],
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[400],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Lista de inmuebles
//                         ListView.separated(
//                           padding: const EdgeInsets.all(16),
//                           itemCount: inmuebles.length,
//                           separatorBuilder: (_, __) => Divider(color: Colors.grey[700]),
//                           itemBuilder: (context, index) {
//                             final inmueble = inmuebles[index];
//                             return ListTile(
//                               tileColor: Colors.transparent,
//                               leading: inmueble["imagenes"] != null && inmueble["imagenes"].isNotEmpty
//                                   ? ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: Image.network(
//                                         inmueble["imagenes"][0],
//                                         width: 50,
//                                         height: 50,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     )
//                                   : const Icon(Icons.home, size: 40, color: Colors.white),
//                               title: Text(
//                                 inmueble["titulo"],
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 inmueble["direccion"],
//                                 style: TextStyle(color: Colors.grey[400]),
//                               ),
//                               trailing: Text(
//                                 inmueble["precio"],
//                                 style: const TextStyle(
//                                   color: Colors.greenAccent,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               onTap: () {
//                                 Navigator.pop(context); // Cierra el modal de la lista
//                                 _showInmuebleDetailModal(inmueble); // Abre el detalle en un nuevo modal
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(color: Colors.white),
//         title: Text(widget.name, style: const TextStyle(color: Colors.white)),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: GestureDetector(
//               onTap: _showProfileModal,
//               child: CircleAvatar(
//                 backgroundImage: AssetImage(widget.avatar),
//               ),
//             ),
//           ),
//         ],
//         backgroundColor: customBarColor,
//         foregroundColor: Colors.white,
//         elevation: 1,
//       ),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
//                           const SizedBox(width: 40),
//                       ],
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           Container(
//             color: customBarColor,
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.camera_alt, color: Colors.white70),
//                   onPressed: () {},
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: inputFieldColor,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: TextField(
//                       controller: _controller,
//                       style: const TextStyle(color: Colors.black87),
//                       decoration: const InputDecoration(
//                         hintText: "Type message here...",
//                         hintStyle: TextStyle(color: Colors.black54),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.white),
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
import '../widgets/ChatMessageBubble.dart';
import '../widgets/ChatInputBar.dart';
import '../widgets/ProfileModal.dart';
import '../widgets/InmuebleDetailModal.dart';

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

  final Color customBarColor = const Color(0xFF6B8796);

  Map<String, dynamic> get perfil => {
    "nombre": widget.name,
    "email": "gina.david@email.com",
    "telefono": "+57 300 123 4567",
    "avatar": widget.avatar,
  };

  final List<Map<String, dynamic>> inmuebles = [
    {
      "titulo": "Apartamento en Medellín",
      "direccion": "Cra 45 # 10-23, Medellín",
      "precio": "\$1.200.000 COP",
      "descripcion": "Hermoso apartamento de 2 habitaciones, 2 baños, parqueadero y balcón.",
      "imagenes": [
        "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
        "https://images.unsplash.com/photo-1460518451285-97b6aa326961",
      ],
      "area": 80,
      "terreno": 0,
      "habitaciones": 2,
      "banos": 2,
    },
    {
      "titulo": "Casa en Envigado",
      "direccion": "Calle 12 Sur # 34-56, Envigado",
      "precio": "\$2.500.000 COP",
      "descripcion": "Casa amplia con jardín y garaje doble.",
      "imagenes": [
        "https://images.unsplash.com/photo-1460518451285-97b6aa326961",
        "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd",
      ],
      "area": 200,
      "terreno": 300,
      "habitaciones": 4,
      "banos": 3,
    },
    {
      "titulo": "Estudio en Laureles",
      "direccion": "Av. Nutibara # 70-80, Laureles",
      "precio": "\$900.000 COP",
      "descripcion": "Estudio moderno, excelente ubicación.",
      "imagenes": [
        "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd",
        "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
      ],
      "area": 40,
      "terreno": 0,
      "habitaciones": 1,
      "banos": 1,
    },
  ];

  void _showInmuebleDetailModal(Map<String, dynamic> inmueble) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF18181B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => InmuebleDetailModal(inmueble: inmueble),
    );
  }

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ProfileModal(
        perfil: perfil,
        inmuebles: inmuebles,
        onInmuebleTap: _showInmuebleDetailModal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Text(widget.name, style: const TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: _showProfileModal,
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.avatar),
              ),
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
                return ChatMessageBubble(
                  text: msg["text"],
                  fromMe: msg["fromMe"] as bool,
                  time: msg["time"],
                  avatar: widget.avatar,
                );
              },
            ),
          ),
          ChatInputBar(
            controller: _controller,
            onCameraTap: () {
              // Acción al tocar la cámara
            },
            onSendTap: () {
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
    );
  }
}