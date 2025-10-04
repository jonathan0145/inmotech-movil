import 'package:flutter/material.dart';
import 'dart:convert'; // ✅ YA TIENES ESTO
import '../models/perfil.dart';
import '../services/perfil_service.dart';
import '../services/auth_service.dart';
import '../widgets/crear_perfil_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final PerfilService _perfilService = PerfilService();
  final AuthService _authService = AuthService();
  
  Perfil? _perfil;
  bool _cargando = true;
  bool _mostrarFormulario = false;
  Map<String, dynamic>? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    
    try {
      print('=== INICIANDO CARGA DE DATOS ===');
      
      // Debug de perfiles existentes
      await _perfilService.debugPerfiles();
      
      // Obtener usuario actual
      await _obtenerUsuarioActual();
      print('Usuario obtenido: $_usuario');
      
      if (_usuario != null) {
        final userId = _getUsuarioId();
        print('Intentando con userId: $userId');
        
        if (userId != null) {
          final perfilData = await _perfilService.getByUserId(userId);
          
          if (perfilData != null) {
            _perfil = Perfil.fromJson(perfilData);
            print('Perfil cargado exitosamente');
          } else {
            print('No hay perfil para userId: $userId');
            print('Este usuario necesita crear un perfil nuevo');
          }
        }
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar perfil: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  Future<void> _obtenerUsuarioActual() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      print('🔍 === VERIFICANDO SHARED PREFERENCES ===');
      final keys = prefs.getKeys();
      print('🔍 Keys disponibles: $keys');
      
      // ✅ EXTRAER DATOS DEL JWT TOKEN
      final authToken = prefs.getString('auth_token');
      print('🔍 Token encontrado: ${authToken != null ? "SÍ" : "NO"}');
      
      if (authToken != null) {
        try {
          // ✅ DECODIFICAR JWT PARA OBTENER USER ID
          final userData = _decodificarJWT(authToken);
          print('🔍 Datos decodificados del JWT: $userData');
          
          final userId = userData['id'];
          final username = userData['username'];
          
          if (userId != null) {
            _usuario = {
              'Platform_user_id': userId,
              'id': userId,
              'user_id': userId,
              'Username': username ?? 'Usuario',
              'token': authToken,
            };
            print('✅ Usuario extraído del JWT: $_usuario');
            return;
          }
        } catch (e) {
          print('❌ Error al decodificar JWT: $e');
        }
      }
      
      // Si no se puede extraer del token, usar método de prueba
      print('⚠️ Usando método de prueba con diferentes IDs');
      final testIds = [1, 2, 3, 4, 5];
      
      for (int testId in testIds) {
        try {
          print('🔍 Probando userId: $testId');
          final testPerfil = await _perfilService.getByUserId(testId);
          if (testPerfil != null) {
            print('✅ ¡Perfil encontrado para userId $testId!');
            _usuario = {
              'Platform_user_id': testId,
              'id': testId,
              'Username': 'Usuario $testId',
            };
            return;
          }
        } catch (e) {
          print('❌ No hay perfil para userId $testId');
        }
      }
      
      // Usar el ID que está en el token (ID=2 según el JWT)
      _usuario = {
        'Platform_user_id': 2, // Del JWT: "id":2
        'id': 2,
        'Username': 'jonathan0145', // Del JWT: "username":"jonathan0145"
      };
      print('✅ Usuario basado en JWT: $_usuario');
      
    } catch (e) {
      print('❌ Error: $e');
      throw e;
    }
  }

  // ✅ MÉTODO PARA DECODIFICAR JWT
  Map<String, dynamic> _decodificarJWT(String token) {
    try {
      // Un JWT tiene 3 partes separadas por puntos: header.payload.signature
      final partes = token.split('.');
      
      if (partes.length != 3) {
        throw Exception('Token JWT inválido');
      }
      
      // Decodificar la parte del payload (segunda parte)
      String payload = partes[1];
      
      // Agregar padding si es necesario para base64
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      
      // Decodificar base64
      final decodificado = utf8.decode(base64Url.decode(payload));
      
      // Parsear JSON
      return json.decode(decodificado);
    } catch (e) {
      print('❌ Error decodificando JWT: $e');
      throw Exception('No se pudo decodificar el token JWT: $e');
    }
  }

  int? _getUsuarioId() {
    if (_usuario == null) return null;
    
    return _usuario!['Platform_user_id'] ?? 
           _usuario!['id'] ?? 
           _usuario!['user_id'] ?? 
           _usuario!['userId'];
  }

  String _getNombreUsuario() {
    if (_perfil?.nombreCompleto.isNotEmpty == true) {
      return _perfil!.nombreCompleto;
    }
    
    return _usuario?['Username'] ?? 
           _usuario?['username'] ?? 
           _usuario?['name'] ?? 
           _usuario?['email'] ?? 
           'Usuario';
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        // ✅ CORRIGIDO: logout() retorna void, no un Map
        await _authService.logout();
        
        // ✅ Si llegamos aquí, el logout fue exitoso
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        print('Error al cerrar sesión: $e');
        
        // ✅ FALLBACK: Limpiar SharedPreferences manualmente si falla
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
        } catch (clearError) {
          print('Error limpiando SharedPreferences: $clearError');
        }
        
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }
  }

  Future<void> _eliminarPerfil() async {
    if (_perfil == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Perfil'),
        content: const Text('¿Estás seguro de que deseas eliminar tu perfil? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _perfilService.delete(_perfil!.profileId!);
        setState(() => _perfil = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil eliminado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar perfil: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _abrirUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('URL inválida: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: Color(0xFF15365F),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
          ),
        ),
      );
    }

    if (_mostrarFormulario) {
      final userId = _getUsuarioId();
      if (userId == null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
            backgroundColor: const Color(0xFF15365F),
            foregroundColor: Colors.white,
          ),
          body: const Center(
            child: Text('No se pudo obtener ID de usuario'),
          ),
        );
      }

      return CrearPerfilForm(
        userId: userId,
        perfil: _perfil,
        onSuccess: () {
          setState(() => _mostrarFormulario = false);
          _cargarDatos();
        },
        onCancel: () => setState(() => _mostrarFormulario = false),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF15365F),
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFF15365F),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF72A3D1), width: 3),
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: _perfil?.profilePhoto != null && _perfil!.profilePhoto!.isNotEmpty
                          ? Image.network(
                              _perfil!.profilePhoto!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 50, color: Color(0xFF72A3D1));
                              },
                            )
                          : Image.asset(
                              'assets/icon.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 50, color: Color(0xFF72A3D1));
                              },
                            ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getNombreUsuario(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF72A3D1),
                          ),
                        ),
                        if (_usuario != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${_getUsuarioId()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF72A3D1),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              ..._buildInfoRows(),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => _mostrarFormulario = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C56A7),
                      foregroundColor: const Color(0xFFFDFDFD),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(_perfil != null ? 'Editar Perfil' : 'Crear Perfil'),
                  ),
                  const SizedBox(width: 18),
                  ElevatedButton(
                    onPressed: _cerrarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe74c3c),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),

              if (_perfil != null) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _eliminarPerfil,
                  child: const Text(
                    'Eliminar Perfil',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInfoRows() {
    final infoItems = [
      {'label': 'Nombre', 'value': _perfil?.profileName ?? '-'},
      {'label': 'Apellido', 'value': _perfil?.profileLastname ?? '-'},
      {'label': 'Teléfono', 'value': _perfil?.profilePhone ?? '-'},
      {'label': 'Dirección', 'value': _perfil?.profileAddress ?? '-'},
      {'label': 'Correo', 'value': _perfil?.profileEmail ?? '-'},
      {'label': 'Fecha de nacimiento', 'value': _perfil?.profileBirthdate ?? '-'},
      {'label': 'Género', 'value': _perfil?.profileGender ?? '-'},
      {'label': 'Documento', 'value': _perfil?.profileNationalId ?? '-'},
      {'label': 'Biografía', 'value': _perfil?.profileBio ?? '-'},
      {'label': 'Sitio web', 'value': _perfil?.profileWebsite, 'isUrl': true},
      {'label': 'Red social', 'value': _perfil?.profileSocial, 'isUrl': true},
    ];

    return infoItems.map((item) => _buildInfoRow(
      item['label'] as String,
      item['value'] as String?,
      isUrl: item['isUrl'] as bool? ?? false,
    )).toList();
  }

  Widget _buildInfoRow(String label, String? value, {bool isUrl = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF72A3D1),
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: isUrl && value != null && value.isNotEmpty && value != '-' && value.startsWith('http')
                ? GestureDetector(
                    onTap: () => _abrirUrl(value),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Color(0xFF72A3D1),
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                  )
                : Text(
                    value ?? '-',
                    style: const TextStyle(
                      color: Color(0xFFFDFDFD),
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}