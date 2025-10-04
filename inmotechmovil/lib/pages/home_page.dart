import 'package:flutter/material.dart';
import '../services/inmueble_service.dart';
import '../models/inmueble.dart';
import '../pages/detalle_inmueble_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InmuebleService _inmuebleService = InmuebleService();
  List<Map<String, dynamic>> _inmuebles = []; // ✅ CORREGIR TIPO
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInmuebles();
  }

  Future<void> _loadInmuebles() async {
    setState(() => _isLoading = true);
    
    try {
      print('🏠 Cargando inmuebles...');
      
      // ✅ USAR EL MÉTODO CORRECTO getAll()
      final inmuebles = await _inmuebleService.getAll();
      
      print('✅ Inmuebles cargados: ${inmuebles.length}');
      
      setState(() {
        _inmuebles = inmuebles; // ✅ AHORA SÍ COINCIDEN LOS TIPOS
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error cargando inmuebles: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cargando inmuebles: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF15365F),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'InmoTech',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
          ),
          
          // Encabezado
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inmuebles Disponibles',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15365F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Encuentra tu inmueble ideal',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (_inmuebles.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${_inmuebles.length} inmuebles encontrados',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF72A3D1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Loading o lista de inmuebles
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
                  ),
                ),
              ),
            )
          else
            _buildInmueblesList(),
        ],
      ),
    );
  }

  Widget _buildInmueblesList() {
    if (_inmuebles.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(
                  Icons.home_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No hay inmuebles disponibles',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final inmuebleData = _inmuebles[index];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildInmuebleCard(inmuebleData),
          );
        },
        childCount: _inmuebles.length,
      ),
    );
  }

  Widget _buildInmuebleCard(Map<String, dynamic> inmuebleData) {
    final valor = inmuebleData['Valor']?.toString() ?? '0';
    final area = inmuebleData['Area']?.toString() ?? 'N/D';
    final descripcion = inmuebleData['Descripcion_General'] ?? 'Sin descripción';
    final estado = inmuebleData['Estado'] ?? 'Activo';
    
    final division = inmuebleData['division'];
    final habitaciones = division?['Habitaciones']?.toString() ?? 'N/D';
    final banos = division?['Baños']?.toString() ?? 'N/D';
    
    final imagenesInmueble = inmuebleData['ImagenesInmueble'];
    final imagenUrl = imagenesInmueble?['URL'] ?? '';
    
    final direccion = inmuebleData['Direccion'];
    final direccionTexto = direccion?['Direccion'] ?? 'Dirección no disponible';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToDetail(inmuebleData),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Imagen del inmueble
            if (imagenUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imagenUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.home, size: 48, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y valor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          descripcion,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${_formatNumber(valor)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C56A7),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Dirección
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          direccionTexto,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Detalles del inmueble
                  Row(
                    children: [
                      _buildDetailChip(Icons.square_foot, '$area m²'),
                      const SizedBox(width: 8),
                      _buildDetailChip(Icons.bed, '$habitaciones hab'),
                      const SizedBox(width: 8),
                      _buildDetailChip(Icons.bathroom, '$banos baños'),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Estado
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: estado == 'Activo' ? Colors.green[100] : Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      estado,
                      style: TextStyle(
                        fontSize: 12,
                        color: estado == 'Activo' ? Colors.green[700] : Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF72A3D1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
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

  void _navigateToDetail(Map<String, dynamic> inmuebleData) {
    try {
      print('🏠 Navegando al detalle del inmueble: ${inmuebleData['Inmueble_id']}');
      
      final inmueble = Inmueble.fromJson(inmuebleData);
      
      // Navegación corregida según el tipo de dato
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalleInmueblePage(
            inmuebleId: inmuebleData['Inmueble_id'] ?? 
                        inmuebleData['id'] ?? 
                        inmuebleData['ID'] ?? 
                        inmuebleData['inmueble_id'],
          ),
        ),
      );
    } catch (e) {
      print('❌ Error al navegar al detalle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al abrir detalles: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatNumber(String number) {
    try {
      final num = double.parse(number);
      if (num >= 1000000) {
        return '${(num / 1000000).toStringAsFixed(1)}M';
      } else if (num >= 1000) {
        return '${(num / 1000).toStringAsFixed(0)}K';
      }
      return num.toStringAsFixed(0);
    } catch (e) {
      return number;
    }
  }
}