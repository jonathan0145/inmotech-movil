import 'package:flutter/material.dart';

class InmuebleDetailModal extends StatelessWidget {
  final Map<String, dynamic> inmueble;

  const InmuebleDetailModal({Key? key, required this.inmueble}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagenes = List<String>.from(inmueble["imagenes"] ?? []);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            if (imagenes.isNotEmpty)
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: imagenes.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imagenes[index],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              inmueble["titulo"] ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(inmueble["direccion"] ?? "", style: const TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 8),
            Text(inmueble["precio"] ?? "", style: const TextStyle(fontSize: 16, color: Colors.greenAccent)),
            const SizedBox(height: 12),
            Text(inmueble["descripcion"] ?? "", style: const TextStyle(fontSize: 15, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}