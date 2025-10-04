import 'package:flutter/material.dart';
import '../models/inmueble.dart';
import '../widgets/detalle_inmueble_widget.dart';

class DetalleInmueblePage extends StatelessWidget {
  final Inmueble inmueble;
  final bool isOwner;

  const DetalleInmueblePage({
    Key? key,
    required this.inmueble,
    this.isOwner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Detalle del Inmueble'),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _shareInmueble(context),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: DetalleInmuebleWidget(
        inmueble: inmueble,
        showEditButton: isOwner,
        onEdit: () => _editInmueble(context),
        onDelete: () => _deleteInmueble(context),
      ),
    );
  }

  void _shareInmueble(BuildContext context) {
    // Implementar compartir inmueble
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de compartir próximamente'),
        backgroundColor: Color(0xFF1C56A7),
      ),
    );
  }

  void _editInmueble(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de editar próximamente'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _deleteInmueble(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inmueble eliminado'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.pop(context);
  }
}