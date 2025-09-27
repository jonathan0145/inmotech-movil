import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService.instance;

  // Login con usuario y contraseña
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _apiService.post('/login', data: {
        'Username': username,
        'password': password,
      });

      if (response.data['token'] != null) {
        // Guardar token automáticamente
        await _apiService.saveToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Registro de nuevo usuario
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await _apiService.post('/register', data: {
        'Username': username,
        'email': email,
        'password': password,
      });

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Login con Google
  Future<Map<String, dynamic>> loginWithGoogle(String credential) async {
    try {
      final response = await _apiService.post('/google', data: {
        'credential': credential,
      });

      if (response.data['token'] != null) {
        await _apiService.saveToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener perfil del usuario autenticado
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiService.get('/auth/perfil');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Verificar disponibilidad de usuario
  Future<bool> checkUsuarioDisponible(String usuario) async {
    try {
      final response = await _apiService.get('/check-usuario', queryParameters: {
        'usuario': usuario,
      });
      return response.data['disponible'] ?? false;
    } on DioException catch (e) {
      print('Error verificando usuario: ${_handleError(e)}');
      return false;
    }
  }

  // Verificar disponibilidad de correo
  Future<bool> checkCorreoDisponible(String correo) async {
    try {
      final response = await _apiService.get('/check-correo', queryParameters: {
        'correo': correo,
      });
      return response.data['disponible'] ?? false;
    } on DioException catch (e) {
      print('Error verificando correo: ${_handleError(e)}');
      return false;
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _apiService.clearToken();
  }

  // Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    return await _apiService.isAuthenticated();
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de conexión agotado. Verifica tu conexión a internet.';
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 401) {
          return 'Credenciales incorrectas.';
        } else if (error.response?.statusCode == 404) {
          return 'Servicio no encontrado.';
        } else if (error.response?.statusCode == 500) {
          return 'Error interno del servidor.';
        }
        return error.response?.data['message'] ?? 'Error en la respuesta del servidor.';
      case DioExceptionType.cancel:
        return 'Petición cancelada.';
      case DioExceptionType.unknown:
        return 'Error de conexión. Verifica tu conexión a internet.';
      default:
        return 'Error desconocido.';
    }
  }
}