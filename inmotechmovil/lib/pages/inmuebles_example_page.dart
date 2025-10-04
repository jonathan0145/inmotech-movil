import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/inmueble_service.dart';
import '../models/inmueble.dart';

class InmueblesExamplePage extends StatefulWidget {
  const InmueblesExamplePage({Key? key}) : super(key: key);

  @override
  State<InmueblesExamplePage> createState() => _InmueblesExamplePageState();
}

class _InmueblesExamplePageState extends State<InmueblesExamplePage> {
  final InmuebleService _inmuebleService = InmuebleService();
  List<Map<String, dynamic>> _inmuebles = [];
  bool _isLoading = false;
  String? _error;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeAndLoadData();
  }

  Future<void> _initializeAndLoadData() async {
    await _getCurrentUserId();
    await _loadInmuebles();
  }

  Future<void> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getInt('user_id') ?? 
                     prefs.getInt('Platform_user_id') ?? 
                     prefs.getInt('userId');
    } catch (e) {
      print('Error obteniendo user ID: $e');
    }
  }

  Future<void> _loadInmuebles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // ✅ USAR EL MÉTODO CORRECTO - probemos con getInmueblesByUserId
      List<Map<String, dynamic>> response;
      
      if (_currentUserId != null) {
        // Si tenemos userId, obtener inmuebles del usuario
        response = await _inmuebleService.getInmueblesByUserId(_currentUserId!);
      } else {
        // Si no hay userId, crear una lista vacía o usar datos de ejemplo
        response = [];
        setState(() {
          _error = 'No se pudo obtener el ID de usuario';
          _isLoading = false;
        });
        return;
      }
      
      setState(() {
        _inmuebles = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      
      // ✅ DATOS DE EJEMPLO si falla la API
      setState(() {
        _inmuebles = _getDatosEjemplo();
        _isLoading = false;
        _error = null; // No mostrar error, usar datos de ejemplo
      });
    }
  }

  // ✅ DATOS DE EJEMPLO PARA TESTING
  List<Map<String, dynamic>> _getDatosEjemplo() {
    return [
      {
        'Inmueble_id': 1,
        'Descripcion_General': 'Casa moderna en zona residencial',
        'Area': 120,
        'Valor': 250000000,
        'Estado': 'Activo',
        'Direccion': {
          'Direccion': 'Calle 123 #45-67, Barrio Ejemplo'
        },
        'division': {
          'Habitaciones': 3,
          'Baños': 2,
          'Parqueaderos': 1
        },
        'ImagenesInmueble': {
          'URL': 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=400'
        }
      },
      {
        'Inmueble_id': 2,
        'Descripcion_General': 'Apartamento céntrico con vista',
        'Area': 85,
        'Valor': 180000000,
        'Estado': 'Activo',
        'Direccion': {
          'Direccion': 'Carrera 10 #20-30, Centro'
        },
        'division': {
          'Habitaciones': 2,
          'Baños': 2,
          'Parqueaderos': 1
        },
        'ImagenesInmueble': {
          'URL': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400'
        }
      },
      {
        'Inmueble_id': 3,
        'Descripcion_General': 'Local comercial en zona comercial',
        'Area': 200,
        'Valor': 400000000,
        'Estado': 'Activo',
        'Direccion': {
          'Direccion': 'Avenida Principal #100-200'
        },
        'division': {
          'Habitaciones': 0,
          'Baños': 2,
          'Parqueaderos': 3
        },
        'ImagenesInmueble': {
          'URL': 'https://images.unsplash.com/photo-1560448075-bb485b067938?w=400'
        }
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Explorar Inmuebles'),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadInmuebles,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
            ),
            SizedBox(height: 16),
            Text('Cargando inmuebles...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.orange[300]),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.orange[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadInmuebles,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C56A7),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_inmuebles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No se encontraron inmuebles',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _inmuebles = _getDatosEjemplo();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF72A3D1),
                foregroundColor: Colors.white,
              ),
              child: const Text('Ver Datos de Ejemplo'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInmuebles,
      color: const Color(0xFF72A3D1),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _inmuebles.length,
        itemBuilder: (context, index) {
          final inmuebleData = _inmuebles[index];
          return _buildInmuebleCard(inmuebleData);
        },
      );
    }
  }

  Widget _buildInmuebleCard(Map<String, dynamic> inmuebleData) {
    final valor = inmuebleData['Valor']?.toString() ?? '0';
    final area = inmuebleData['Area']?.toString() ?? 'N/D';
    final descripcion = inmuebleData['Descripcion_General'] ?? 'Sin descripción';
    final direccion = inmuebleData['Direccion']?['Direccion'] ?? 'Sin dirección';
    
    final division = inmuebleData['division'];
    final habitaciones = division?['Habitaciones']?.toString() ?? 'N/D';
    final banos = division?['Baños']?.toString() ?? 'N/D';
    
    final imagenesInmueble = inmuebleData['ImagenesInmueble'];
    final imagenUrl = imagenesInmueble?['URL'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showInmuebleDetail(inmuebleData),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ IMAGEN DEL INMUEBLE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imagenUrl.isNotEmpty
                  ? Image.network(
                      imagenUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    )
                  : _buildImagePlaceholder(),
            ),
            
            // ✅ INFORMACIÓN DEL INMUEBLE
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    descripcion,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15365F),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          direccion,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // ✅ CHIPS DE INFORMACIÓN
                  Row(
                    children: [
                      _buildInfoChip(Icons.square_foot, '$area m²'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.bed, habitaciones),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.bathroom, banos),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // ✅ PRECIO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          inmuebleData['Estado'] ?? 'Activo',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '\$${_formatPrice(valor)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C56A7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('Sin imagen disponible', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF72A3D1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF1C56A7)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1C56A7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(String price) {
    try {
      final num = double.parse(price);
      if (num >= 1000000) {
        return '${(num / 1000000).toStringAsFixed(1)}M';
      } else if (num >= 1000) {
        return '${(num / 1000).toStringAsFixed(0)}K';
      }
      return num.toStringAsFixed(0);
    } catch (e) {
      return price;
    }
  }

  void _showInmuebleDetail(Map<String, dynamic> inmuebleData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          inmuebleData['Descripcion_General'] ?? 'Detalle del Inmueble',
          style: const TextStyle(fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Área:', '${inmuebleData['Area']} m²'),
              _buildDetailRow('Habitaciones:', '${inmuebleData['division']?['Habitaciones'] ?? 'N/D'}'),
              _buildDetailRow('Baños:', '${inmuebleData['division']?['Baños'] ?? 'N/D'}'),
              _buildDetailRow('Parqueaderos:', '${inmuebleData['division']?['Parqueaderos'] ?? 'N/D'}'),
              _buildDetailRow('Precio:', '\$${_formatPrice(inmuebleData['Valor']?.toString() ?? '0')}'),
              _buildDetailRow('Estado:', '${inmuebleData['Estado'] ?? 'N/D'}'),
              const SizedBox(height: 8),
              const Text(
                'Ubicación:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(inmuebleData['Direccion']?['Direccion'] ?? 'Sin dirección'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad de contacto próximamente'),
                  backgroundColor: Color(0xFF1C56A7),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C56A7),
              foregroundColor: Colors.white,
            ),
            child: const Text('Contactar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}