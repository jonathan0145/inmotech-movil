import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/inmueble_service.dart';
import '../models/inmueble.dart';
import 'detalle_inmueble_page.dart';

class InmueblesPage extends StatefulWidget {
  const InmueblesPage({Key? key}) : super(key: key);

  @override
  State<InmueblesPage> createState() => _InmueblesPageState();
}

class _InmueblesPageState extends State<InmueblesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final InmuebleService _inmuebleService = InmuebleService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _publicaciones = [];
  List<Map<String, dynamic>> _favoritos = [];
  List<Map<String, dynamic>> _publicacionesFiltradas = [];
  List<Map<String, dynamic>> _favoritosFiltrados = [];

  bool _isLoadingPublicaciones = false;
  bool _isLoadingFavoritos = false;
  String _searchQuery = '';
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeAndLoadData();
    
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ✅ OBTENER USER ID Y CARGAR DATOS
  Future<void> _initializeAndLoadData() async {
    await _getCurrentUserId();
    if (_currentUserId != null) {
      await _loadData();
    }
  }

  Future<void> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getInt('user_id') ?? 
                     prefs.getInt('Platform_user_id') ?? 
                     prefs.getInt('userId');
      
      print('🔍 Current User ID: $_currentUserId');
    } catch (e) {
      print('❌ Error obteniendo user ID: $e');
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterData();
    });
  }

  void _filterData() {
    _publicacionesFiltradas = _publicaciones.where((inmueble) {
      final descripcion = (inmueble['Descripcion_General'] ?? '').toLowerCase();
      final direccion = (inmueble['Direccion']?['Direccion'] ?? '').toLowerCase();
      final area = (inmueble['Area'] ?? '').toString();
      
      return descripcion.contains(_searchQuery) ||
             direccion.contains(_searchQuery) ||
             area.contains(_searchQuery);
    }).toList();

    _favoritosFiltrados = _favoritos.where((inmueble) {
      final descripcion = (inmueble['Descripcion_General'] ?? '').toLowerCase();
      final direccion = (inmueble['Direccion']?['Direccion'] ?? '').toLowerCase();
      final area = (inmueble['Area'] ?? '').toString();
      
      return descripcion.contains(_searchQuery) ||
             direccion.contains(_searchQuery) ||
             area.contains(_searchQuery);
    }).toList();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadPublicaciones(),
      _loadFavoritos(),
    ]);
  }

  Future<void> _loadPublicaciones() async {
    if (_currentUserId == null) return;
    
    setState(() => _isLoadingPublicaciones = true);
    
    try {
      print('🏠 Cargando publicaciones del usuario: $_currentUserId');
      
      // ✅ USAR EL MÉTODO CORRECTO getInmueblesByUserId
      final response = await _inmuebleService.getInmueblesByUserId(_currentUserId!);
      
      setState(() {
        _publicaciones = response;
        _publicacionesFiltradas = response;
        _isLoadingPublicaciones = false;
      });
      
      print('✅ Publicaciones cargadas: ${response.length}');
    } catch (e) {
      setState(() => _isLoadingPublicaciones = false);
      print('❌ Error cargando publicaciones: $e');
      _showError('Error al cargar publicaciones: ${e.toString()}');
    }
  }

  Future<void> _loadFavoritos() async {
    if (_currentUserId == null) return;
    
    setState(() => _isLoadingFavoritos = true);
    
    try {
      print('❤️ Cargando favoritos del usuario: $_currentUserId');
      
      // ✅ USAR EL MÉTODO CORRECTO getFavoritosByUserId
      final response = await _inmuebleService.getFavoritosByUserId(_currentUserId!);
      
      setState(() {
        _favoritos = response;
        _favoritosFiltrados = response;
        _isLoadingFavoritos = false;
      });
      
      print('✅ Favoritos cargados: ${response.length}');
    } catch (e) {
      setState(() => _isLoadingFavoritos = false);
      print('❌ Error cargando favoritos: $e');
      _showError('Error al cargar favoritos: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mis Inmuebles'),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar inmuebles...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.business),
                    text: 'Publicaciones (${_publicacionesFiltradas.length})',
                  ),
                  Tab(
                    icon: const Icon(Icons.favorite),
                    text: 'Favoritos (${_favoritosFiltrados.length})',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _currentUserId == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error de autenticación'),
                  Text('No se pudo identificar al usuario'),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPublicacionesTab(),
                _buildFavoritosTab(),
              ],
            ),
    );
  }

  Widget _buildPublicacionesTab() {
    if (_isLoadingPublicaciones) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
            ),
            SizedBox(height: 16),
            Text('Cargando tus publicaciones...'),
          ],
        ),
      );
    }

    if (_publicacionesFiltradas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.business,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No se encontraron publicaciones con "$_searchQuery"'
                  : 'No tienes publicaciones aún',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Publica tu primer inmueble para empezar',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función de crear inmueble próximamente'),
                      backgroundColor: Color(0xFF1C56A7),
                    ),
                  );
                },
                icon: const Icon(Icons.add_business),
                label: const Text('Publicar Inmueble'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C56A7),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: const Color(0xFF72A3D1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _publicacionesFiltradas.length,
          itemBuilder: (context, index) {
            final inmuebleData = _publicacionesFiltradas[index];
            return _buildInmuebleCard(inmuebleData, isOwner: true);
          },
        ),
      ),
    );
  }

  Widget _buildFavoritosTab() {
    if (_isLoadingFavoritos) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
            ),
            SizedBox(height: 16),
            Text('Cargando tus favoritos...'),
          ],
        ),
      );
    }

    if (_favoritosFiltrados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No se encontraron favoritos con "$_searchQuery"'
                  : 'No tienes favoritos aún',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Explora inmuebles y marca tus favoritos',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: const Color(0xFF72A3D1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _favoritosFiltrados.length,
          itemBuilder: (context, index) {
            final inmuebleData = _favoritosFiltrados[index];
            return _buildInmuebleCard(inmuebleData, isFavorite: true);
          },
        ),
      ),
    );
  }

  // ✅ CREAR WIDGET DE CARD PERSONALIZADO (sin dependencias externas)
  Widget _buildInmuebleCard(Map<String, dynamic> inmuebleData, {bool isOwner = false, bool isFavorite = false}) {
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
        onTap: () {
          // ❌ ANTES (líneas 595-596):
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DetalleInmueblePage(inmuebleId: inmuebleData['id']!),
          //   ),
          // );

          // ✅ DESPUÉS - USAR LA CLAVE CORRECTA:
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
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
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
                  
                  // Botón de favorito o menú de opciones
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: isOwner
                          ? PopupMenuButton(
                              iconSize: 20,
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 16),
                                      SizedBox(width: 8),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, size: 16, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editInmueble(inmuebleData);
                                } else if (value == 'delete') {
                                  _deleteInmueble(inmuebleData);
                                }
                              },
                            )
                          : GestureDetector(
                              onTap: () => _toggleFavorito(inmuebleData),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                                size: 20,
                              ),
                            ),
                    ),
                  ),
                ],
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
    // ✅ USAR EL NUEVO CONSTRUCTOR CON inmuebleId
    final inmuebleId = inmuebleData['Inmueble_id'] ?? 
                      inmuebleData['id'] ?? 
                      inmuebleData['ID'];
                      
    if (inmuebleId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalleInmueblePage(
            inmuebleId: inmuebleId,
            isOwner: _publicaciones.any((p) => p['Inmueble_id'] == inmuebleData['Inmueble_id']),
          ),
        ),
      );
    } else {
      _showError('Error: ID del inmueble no encontrado');
    }
  }

  void _editInmueble(Map<String, dynamic> inmuebleData) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de editar inmueble próximamente'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _deleteInmueble(Map<String, dynamic> inmuebleData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Inmueble'),
        content: const Text('¿Estás seguro de que deseas eliminar este inmueble?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de eliminar inmueble próximamente'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorito(Map<String, dynamic> inmuebleData) async {
    if (_currentUserId == null) return;
    
    try {
      final inmuebleId = inmuebleData['Inmueble_id'];
      await _inmuebleService.toggleFavorito(_currentUserId!, inmuebleId);
      await _loadFavoritos(); // Recargar favoritos
    } catch (e) {
      _showError('Error al cambiar favorito: ${e.toString()}');
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