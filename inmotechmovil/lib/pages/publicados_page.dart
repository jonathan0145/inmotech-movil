import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/inmueble_service.dart';
import '../models/inmueble.dart';
import '../pages/detalle_inmueble_page.dart'; // ✅ IMPORTAR LA PÁGINA DE DETALLE

class PublicadosPage extends StatefulWidget {
  const PublicadosPage({Key? key}) : super(key: key);

  @override
  State<PublicadosPage> createState() => _PublicadosPageState();
}

class _PublicadosPageState extends State<PublicadosPage> {
  final InmuebleService _inmuebleService = InmuebleService();
  List<Map<String, dynamic>> _publicados = [];
  bool _isLoading = false;
  int? _userId;
  String _username = 'Usuario';

  @override
  void initState() {
    super.initState();
    _obtenerUsuarioActual();
  }

  // Obtener usuario actual del login
  Future<void> _obtenerUsuarioActual() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      print('=== DEBUG USUARIO ACTUAL ===');
      
      final authToken = prefs.getString('auth_token');
      print('Token existe: ${authToken != null}');
      
      if (authToken != null) {
        try {
          final userData = _decodificarJWT(authToken);
          _userId = userData['id'];
          _username = userData['username'] ?? 'Usuario';
          
          print('Usuario del JWT:');
          print('   ID: $_userId');
          print('   Username: $_username');
          
          if (_userId == null) {
            throw Exception('userId es null en el JWT');
          }
          
        } catch (e) {
          print('Error decodificando JWT: $e');
          _userId = 999; // ID de prueba
          _username = 'Usuario Test';
        }
      } else {
        _userId = 999; // ID de prueba si no hay token
        _username = 'Usuario Test';
      }
      
      print('=== VERIFICANDO INMUEBLES ===');
      print('Buscando inmuebles para userId: $_userId');
      
      if (_userId != null) {
        await _loadPublicados();
      }
      
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  // Decodificar JWT
  Map<String, dynamic> _decodificarJWT(String token) {
    try {
      final partes = token.split('.');
      
      if (partes.length != 3) {
        throw Exception('Token JWT inválido');
      }
      
      String payload = partes[1];
      
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      
      final decodificado = utf8.decode(base64Url.decode(payload));
      return json.decode(decodificado);
    } catch (e) {
      throw Exception('No se pudo decodificar el token JWT: $e');
    }
  }

  // Cargar inmuebles del usuario actual
  Future<void> _loadPublicados() async {
    if (_userId == null) {
      print('No hay userId para cargar inmuebles');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      print('=== CARGANDO INMUEBLES DEL USUARIO ===');
      print('UserId actual: $_userId');
      
      final publicados = await _inmuebleService.getInmueblesByUserId(_userId!);
      
      print('Inmuebles del usuario $_userId: ${publicados.length}');
      
      setState(() {
        _publicados = publicados;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando inmuebles: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mis Publicaciones'),
            if (_username.isNotEmpty)
              Text(
                _username,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
        actions: [
          if (_publicados.isNotEmpty)
            Chip(
              label: Text('${_publicados.length}'),
              backgroundColor: const Color(0xFF72A3D1),
              labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateInmueble,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
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
            )
          : _publicados.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes publicaciones aún',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Publica tu primer inmueble para empezar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _showCreateInmueble,
                        icon: const Icon(Icons.add),
                        label: const Text('Publicar Inmueble'),
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
                  onRefresh: _loadPublicados,
                  color: const Color(0xFF72A3D1),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _publicados.length,
                    itemBuilder: (context, index) {
                      final inmueble = _publicados[index];
                      return _buildPublicadoCard(inmueble);
                    },
                  ),
                ),
    );
  }

  Widget _buildPublicadoCard(Map<String, dynamic> inmuebleData) {
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
      child: InkWell( // ✅ HACER TODA LA CARD CLICABLE
        onTap: () => _navigateToDetail(inmuebleData), // ✅ NAVEGAR AL DETALLE
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
                  Text(
                    direccionTexto,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                  
                  // Estado y menú de opciones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      
                      // Menú de opciones (evitar que se active el onTap de la card)
                      GestureDetector(
                        onTap: () {}, // Evitar propagación del tap
                        child: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility, color: Color(0xFF1C56A7)),
                                  SizedBox(width: 8),
                                  Text('Ver Detalles'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text('Editar'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Eliminar', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'view') {
                              _navigateToDetail(inmuebleData);
                            } else if (value == 'edit') {
                              _editInmueble(inmuebleData);
                            } else if (value == 'delete') {
                              _deleteInmueble(inmuebleData);
                            }
                          },
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

  // ✅ ACTUALIZAR EL MÉTODO PARA NAVEGAR AL DETALLE
  void _navigateToDetail(Map<String, dynamic> inmuebleData) {
    try {
      print('🏠 Navegando al detalle del inmueble: ${inmuebleData['Inmueble_id']}');
      
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
              isOwner: true, // En publicados, SÍ es el dueño
            ),
          ),
        );
      } else {
        throw Exception('ID del inmueble no encontrado');
      }
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

  // ✅ MANTENER EL MÉTODO _viewInmueble TAMBIÉN (para el menú)
  void _viewInmueble(Map<String, dynamic> inmuebleData) {
    _navigateToDetail(inmuebleData);
  }

  void _showCreateInmueble() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de crear inmueble próximamente'),
        backgroundColor: Color(0xFF1C56A7),
      ),
    );
  }

  void _editInmueble(Map<String, dynamic> inmueble) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de editar próximamente'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _deleteInmueble(Map<String, dynamic> inmueble) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Publicación'),
        content: const Text('¿Estás seguro de que deseas eliminar esta publicación?'),
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
                  content: Text('Función de eliminar próximamente'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}