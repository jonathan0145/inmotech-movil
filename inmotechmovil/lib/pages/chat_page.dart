// import 'package:flutter/material.dart';
// import '../widgets/ChatMessageBubble.dart';
// import '../widgets/ChatInputBar.dart';
// import '../widgets/ProfileModal.dart';
// import '../widgets/InmuebleDetailModal.dart';

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

//   // ✅ USAR MAP SIMPLE - FUNCIONA SIEMPRE
//   Map<String, dynamic> get perfil => {
//     "nombre": widget.name,
//     "email": "gina.david@email.com",
//     "telefono": "+57 300 123 4567",
//     "avatar": widget.avatar,
//     "bio": "Usuario de la plataforma INMOTECH",
//     "direccion": "Medellín, Colombia",
//     "fechaNacimiento": "1990-01-01",
//     "genero": "Femenino",
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
//       backgroundColor: const Color(0xFF18181B),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) => InmuebleDetailModal(inmueble: inmueble),
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
//       builder: (context) => ProfileModal(
//         perfil: perfil, // ✅ PASAR MAP - FUNCIONA CON ProfileModal FLEXIBLE
//         inmuebles: inmuebles,
//         onInmuebleTap: _showInmuebleDetailModal,
//       ),
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
//                 return ChatMessageBubble(
//                   text: msg["text"],
//                   fromMe: msg["fromMe"] as bool,
//                   time: msg["time"],
//                   avatar: widget.avatar,
//                 );
//               },
//             ),
//           ),
//           ChatInputBar(
//             controller: _controller,
//             onCameraTap: () {
//               // Acción al tocar la cámara
//             },
//             onSendTap: () {
//               if (_controller.text.trim().isNotEmpty) {
//                 setState(() {
//                   messages.add({
//                     "fromMe": true,
//                     "text": _controller.text.trim(),
//                   });
//                   _controller.clear();
//                 });
//               }
//             },
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

  // ✅ USAR MAP SIMPLE - FUNCIONA SIEMPRE
  Map<String, dynamic> get perfil => {
    "nombre": widget.name,
    "email": "gina.david@email.com",
    "telefono": "+57 300 123 4567",
    "avatar": widget.avatar,
    "bio": "Usuario de la plataforma INMOTECH",
    "direccion": "Medellín, Colombia",
    "fechaNacimiento": "1990-01-01",
    "genero": "Femenino",
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
        perfil: perfil, // ✅ PASAR MAP - FUNCIONA CON ProfileModal FLEXIBLE
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