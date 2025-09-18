import 'package:flutter/material.dart';
import '../models/inmueble.dart';
import 'chat_page.dart'; // Asegúrate de tener este archivo creado

class DetalleInmueblePage extends StatelessWidget {
  final Inmueble inmueble;

  const DetalleInmueblePage({Key? key, required this.inmueble}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Inmueble'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: inmueble.imagenes.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      inmueble.imagenes[index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              inmueble.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text('Área: ${inmueble.area} m²'),
            Text('Terreno: ${inmueble.terreno} m²'),
            Text('Habitaciones: ${inmueble.habitaciones}'),
            Text('Baños: ${inmueble.banos}'),
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          name: 'Propietario', // Cambia por el nombre real si lo tienes
                          avatar: 'https://randomuser.me/api/portraits/men/1.jpg', // Cambia por el avatar real si lo tienes
                        ),
                      ),
                    );
                  },
                ),
                // Puedes agregar más iconos aquí si lo deseas
              ],
            ),
          ],
        ),
      ),
    );
  }
}