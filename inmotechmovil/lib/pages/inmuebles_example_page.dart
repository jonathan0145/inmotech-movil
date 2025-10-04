import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/inmueble_service.dart';
import 'detalle_inmueble_page.dart'; // ✅ AGREGAR ESTE IMPORT

class InmueblesExamplePage extends StatefulWidget {
  const InmueblesExamplePage({super.key});

  @override
  State<InmueblesExamplePage> createState() => _InmueblesExamplePageState();
}

class _InmueblesExamplePageState extends State<InmueblesExamplePage> {
  final InmuebleService _inmuebleService = InmuebleService();
  List<Map<String, dynamic>> _inmuebles = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInmuebles();
  }

  Future<void> _loadInmuebles() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // ✅ DESPUÉS - Usar el método correcto según tu servicio:
      final response = await _inmuebleService.getAll(); // O el método que tengas
      
      setState(() {
        _inmuebles = List<Map<String, dynamic>>.from(response);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar inmuebles: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C56A7),
      appBar: AppBar(
        title: const Text('Inmuebles Example'),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
              ),
            )
          : _error != null
              ? _buildErrorState()
              : _buildInmueblesList(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadInmuebles,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF72A3D1),
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildInmueblesList() {
    if (_inmuebles.isEmpty) {
      return const Center(
        child: Text(
          'No hay inmuebles disponibles',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _inmuebles.length,
      itemBuilder: (context, index) {
        final inmuebleData = _inmuebles[index];
        return _buildInmuebleCard(inmuebleData, index);
      },
    );
  }

  // ✅ MÉTODO ÚNICO _buildInmuebleCard (SIN DUPLICADOS)
  Widget _buildInmuebleCard(Map<String, dynamic> inmuebleData, int index) {
    final valor = inmuebleData['Valor']?.toString() ?? '0';
    final area = inmuebleData['Area']?.toString() ?? 'N/D';
    final descripcion = inmuebleData['Descripcion_General'] ?? 'Sin descripción';
    
    final division = inmuebleData['division'];
    final habitaciones = division?['Habitaciones']?.toString() ?? 'N/D';
    final banos = division?['Baños']?.toString() ?? 'N/D';
    
    final imagenesInmueble = inmuebleData['ImagenesInmueble'];
    final imagenUrl = imagenesInmueble?['URL'] ?? '';

    // ✅ EXTRAER ID CORRECTAMENTE
    final inmuebleId = inmuebleData['Inmueble_id'] ?? 
                      inmuebleData['id'] ?? 
                      inmuebleData['ID'];

    return Card(
      elevation: 4,
      color: const Color(0xFF15365F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(inmuebleData), // ✅ CONTEXT DISPONIBLE AQUÍ
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imagenUrl.isNotEmpty
                    ? Image.network(
                        imagenUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
            
            // Información
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      descripcion,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    Row(
                      children: [
                        Icon(Icons.bed, size: 12, color: Colors.grey[300]),
                        const SizedBox(width: 2),
                        Text(
                          habitaciones,
                          style: TextStyle(fontSize: 10, color: Colors.grey[300]),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.bathroom, size: 12, color: Colors.grey[300]),
                        const SizedBox(width: 2),
                        Text(
                          banos,
                          style: TextStyle(fontSize: 10, color: Colors.grey[300]),
                        ),
                      ],
                    ),
                    
                    Text(
                      '\$${_formatNumber(valor)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF72A3D1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[700],
      child: const Center(
        child: Icon(
          Icons.home,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  // ✅ MÉTODO DENTRO DE LA CLASE (CONTEXT DISPONIBLE)
  void _navigateToDetail(Map<String, dynamic> inmuebleData) {
    final inmuebleId = inmuebleData['Inmueble_id'] ?? 
                      inmuebleData['id'] ?? 
                      inmuebleData['ID'];
    
    if (inmuebleId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalleInmueblePage(inmuebleId: inmuebleId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: ID del inmueble no encontrado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ MÉTODO HELPER PARA FORMATEAR NÚMEROS
  String _formatNumber(String number) {
    try {
      final num = int.parse(number);
      return num.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      );
    } catch (e) {
      return number;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}