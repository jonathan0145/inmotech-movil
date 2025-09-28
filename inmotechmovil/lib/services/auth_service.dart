import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService.instance;

  // Login de usuario
  Future<Map<String, dynamic>> login(String usuario, String password) async {
    try {
      print('🔐 Intentando login con usuario: $usuario');
      
      // Datos para tu API específica
      final loginData = {
        'Username': usuario,  // Tu API usa Username con mayúscula
        'password': password,
      };
      
      print('📤 Enviando datos a /login: $loginData');
      
      final response = await _apiService.post('/login', data: loginData);
      
      print('📡 Status: ${response.statusCode}');
      print('📄 Response completa: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data != null && data is Map<String, dynamic>) {
          // Tu API devuelve token directamente
          final token = data['token']?.toString();
          final user = data['user'];
          
          if (token != null && token.isNotEmpty) {
            await _apiService.saveToken(token);
            print('💾 Token guardado: ${token.substring(0, 10)}...');
          }
          
          return {
            'success': true,
            'message': 'Login exitoso',
            'data': {
              'token': token,
              'user': user,
            },
          };
        }
      }
      
      return {
        'success': false,
        'message': 'Credenciales incorrectas',
      };
      
    } catch (e) {
      print('❌ Error login: $e');
      return {
        'success': false,
        'message': 'Error de conexión',
      };
    }
  }

  // Registro de usuario
  Future<Map<String, dynamic>> register(String usuario, String email, String password) async {
    try {
      print('📝 Intentando registro: usuario=$usuario, email=$email');
      
      final registerData = {
        'Username': usuario,  // Tu API usa Username con mayúscula
        'email': email,
        'password': password,
      };
      
      print('📤 Enviando datos a /register: $registerData');
      
      final response = await _apiService.post('/register', data: registerData);
      
      print('📡 Status registro: ${response.statusCode}');
      print('📄 Response registro: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        
        if (data != null && data is Map<String, dynamic>) {
          final token = data['token']?.toString();
          final user = data['user'];
          
          if (token != null && token.isNotEmpty) {
            await _apiService.saveToken(token);
            print('💾 Token de registro guardado');
          }
          
          return {
            'success': true,
            'message': 'Usuario registrado exitosamente',
            'data': {
              'token': token,
              'user': user,
            },
          };
        }
      }
      
      return {
        'success': false,
        'message': 'Error al registrar usuario',
      };
      
    } on DioException catch (e) {
      print('❌ Error registro:');
      print('   Status: ${e.response?.statusCode}');
      print('   Data: ${e.response?.data}');
      
      if (e.response?.statusCode == 400) {
        final errorMsg = e.response?.data?['error']?.toString() ?? 
                        e.response?.data?['message']?.toString() ??
                        'Datos de registro inválidos';
        return {
          'success': false,
          'message': errorMsg,
        };
      }
      
      return {
        'success': false,
        'message': 'Error de conexión en registro',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado en registro: $e',
      };
    }
  }

  // Verificaciones con las rutas correctas de tu API
  Future<Map<String, dynamic>> checkUsernameAvailability(String username) async {
    try {
      // Ruta que coincide con tu API
      final response = await _apiService.get('/check-usuario', 
        queryParameters: {'usuario': username}
      );

      print('📡 Check usuario response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return {
            'available': data['disponible'] == true,
            'message': data['mensaje']?.toString() ?? 
                      data['message']?.toString() ?? '',
          };
        }
      }
      
      return {
        'available': false,
        'message': 'Error al verificar usuario',
      };
    } catch (e) {
      print('❌ Error check usuario: $e');
      return {
        'available': true, // En caso de error, permitir continuar
        'message': 'No se pudo verificar disponibilidad',
      };
    }
  }

  Future<Map<String, dynamic>> checkEmailAvailability(String email) async {
    try {
      // Ruta que coincide con tu API
      final response = await _apiService.get('/check-correo', 
        queryParameters: {'correo': email}
      );

      print('📡 Check email response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return {
            'available': data['disponible'] == true,
            'message': data['mensaje']?.toString() ?? 
                      data['message']?.toString() ?? '',
          };
        }
      }
      
      return {
        'available': false,
        'message': 'Error al verificar email',
      };
    } catch (e) {
      print('❌ Error check email: $e');
      return {
        'available': true, // En caso de error, permitir continuar
        'message': 'No se pudo verificar disponibilidad',
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await _apiService.clearToken();
      return {
        'success': true,
        'message': 'Sesión cerrada correctamente',
      };
    } catch (e) {
      await _apiService.clearToken();
      return {
        'success': true,
        'message': 'Sesión cerrada correctamente',
      };
    }
  }

  Future<bool> isAuthenticated() async {
    return await _apiService.isAuthenticated();
  }
}