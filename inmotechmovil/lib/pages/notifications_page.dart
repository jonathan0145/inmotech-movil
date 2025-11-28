import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notificaciones = [
    {
      'icon': 'chat',
      'texto': 'Tienes un nuevo mensaje de un agente.'
    },
    {
      'icon': 'home',
      'texto': 'Una propiedad que sigues ha cambiado de precio.'
    },
    {
      'icon': 'person',
      'texto': 'Tu perfil ha sido verificado.'
    },
  ];

  IconData _getIcon(String name) {
    switch (name) {
      case 'chat':
        return Icons.chat;
      case 'home':
        return Icons.home;
      case 'person':
        return Icons.person;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15365F),
      appBar: AppBar(
        backgroundColor: Color(0xFF15365F),
        elevation: 0,
        title: Text('Notificaciones', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: notificaciones.length,
          itemBuilder: (context, index) {
            final notif = notificaciones[index];
            return Card(
              color: Color(0xFF72A3D1).withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: EdgeInsets.only(bottom: 20),
              child: ListTile(
                leading: Icon(_getIcon(notif['icon']!), color: Color(0xFF72A3D1), size: 32),
                title: Text(notif['texto']!, style: TextStyle(color: Colors.white)),
              ),
            );
          },
        ),
      ),
    );
  }
}
