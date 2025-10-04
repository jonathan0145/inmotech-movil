import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/inmueble_service.dart';
import '../models/inmueble.dart';
import 'detalle_inmueble_page.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({Key? key}) : super(key: key);

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final InmuebleService _inmuebleService = InmuebleService();
  List<Map<String, dynamic>> _favoritos = [];
  bool _isLoading = false;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeAndLoadFavoritos();
  }

  Future<void> _initializeAndLoadFavoritos() async {
    await _getCurrentUserId();
    if (_currentUserId != null) {
      await _loadFavoritos();
    }
  }

  // ✅ MÉTODO CORREGIDO: Solo usar SharedPreferences
  Future<void> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Intentar diferentes claves donde puede estar el user ID
      _currentUserId = prefs.getInt('user_id') ?? 
                     prefs.getInt('Platform_user_id') ?? 
                     prefs.getInt('userId');
      
      print('🔍 Current User ID obtenido: $_currentUserId');
      
      // Si no se encuentra, intentar obtener de los datos del usuario
      if (_currentUserId == null) {
        final userDataString = prefs.getString('user_data');
        if (userDataString != null) {
          try {
            final userDataJson = userDataString; // Si está como JSON string
            // Aquí podrías parsear el JSON si es necesario
            print('📋 User data encontrado: $userDataJson');
          } catch (e) {
            print('❌ Error parseando user data: $e');
          }
        }
      }
      
      if (_currentUserId == null) {
        print('❌ No se pudo obtener el user ID');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se pudo identificar al usuario. Inicia sesión nuevamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Error obteniendo user ID: $e');
    }
  }

  Future<void> _loadFavoritos() async {
    if (_currentUserId == null) {
      print('❌ No se pudo obtener el user ID');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Usuario no identificado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      print('❤️ Cargando favoritos para usuario: $_currentUserId');
      
      // ✅ USAR EL MÉTODO CORRECTO getFavoritosByUserId
      final favoritos = await _inmuebleService.getFavoritosByUserId(_currentUserId!);
      
      print('❤️ Favoritos cargados: ${favoritos.length}');
      
      setState(() {
        _favoritos = favoritos;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error cargando favoritos: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cargando favoritos: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
        actions: [
          if (_favoritos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                label: Text('${_favoritos.length}'),
                backgroundColor: const Color(0xFF72A3D1),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      body: _currentUserId == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Error de autenticación',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No se pudo identificar al usuario',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Regresar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C56A7),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
                      ),
                      SizedBox(height: 16),
                      Text('Cargando favoritos...'),
                    ],
                  ),
                )
              : _favoritos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border, 
                            size: 64, 
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tienes favoritos aún',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Explora inmuebles y marca tus favoritos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.explore),
                            label: const Text('Explorar Inmuebles'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1C56A7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadFavoritos,
                      color: const Color(0xFF72A3D1),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _favoritos.length,
                        itemBuilder: (context, index) {
                          final inmuebleData = _favoritos[index];
                          return _buildFavoritoCard(inmuebleData);
                        },
                      ),
                    ),
    );
  }

  Widget _buildFavoritoCard(Map<String, dynamic> inmuebleData) {
    final valor = inmuebleData['Valor']?.toString() ?? '0';
    final area = inmuebleData['Area']?.toString() ?? 'N/D';
    final descripcion = inmuebleData['Descripcion_General'] ?? 'Sin descripción';
    
    final division = inmuebleData['division'];
    final habitaciones = division?['Habitaciones']?.toString() ?? 'N/D';
    final banos = division?['Baños']?.toString() ?? 'N/D';
    
    final imagenesInmueble = inmuebleData['ImagenesInmueble'];
    final imagenUrl = imagenesInmueble?['URL'] ?? '';
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToDetail(inmuebleData),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
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
                  
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () => _toggleFavorito(inmuebleData),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
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
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.square_foot, size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 2),
                            Text(
                              '$area m²',
                              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.bed, size: 12, color: Colors.grey[600]),
                                const SizedBox(width: 2),
                                Text(
                                  habitaciones,
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.bathroom, size: 12, color: Colors.grey[600]),
                                const SizedBox(width: 2),
                                Text(
                                  banos,
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    Text(
                      '\$${_formatNumber(valor)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C56A7),
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
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.home, size: 32, color: Colors.grey),
      ),
    );
  }

  void _navigateToDetail(Map<String, dynamic> inmuebleData) {
    try {
      print('❤️ Navegando al detalle desde favoritos: ${inmuebleData['Inmueble_id']}');
      
      final inmueble = Inmueble.fromJson(inmuebleData);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalleInmueblePage(
            inmueble: inmueble,
            isOwner: false,
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

  Future<void> _toggleFavorito(Map<String, dynamic> inmuebleData) async {
    if (_currentUserId == null) return;
    
    try {
      final inmuebleId = inmuebleData['Inmueble_id'];
      print('❤️ Removiendo de favoritos: inmuebleId=$inmuebleId');
      
      final esFavorito = await _inmuebleService.toggleFavorito(_currentUserId!, inmuebleId);
      
      if (!esFavorito) {
        setState(() {
          _favoritos.removeWhere((item) => item['Inmueble_id'] == inmuebleId);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removido de favoritos'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Error al cambiar favorito: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
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