import 'package:dio/dio.dart';
import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService.instance;

  // Crear usuario
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.post('/platformuser', data: userData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await _apiService.get('/platformuser');
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.data is Map && response.data['data'] is List) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener usuario por ID
  Future<Map<String, dynamic>> getUserById(int id) async {
    try {
      final response = await _apiService.get('/platformuser/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Actualizar usuario
  Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.put('/platformuser/$id', data: userData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Eliminar usuario
  Future<void> deleteUser(int id) async {
    try {
      await _apiService.delete('/platformuser/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Buscar usuarios
  Future<List<Map<String, dynamic>>> searchUsers({
    String? name,
    String? email,
    String? role,
    String? status,
  }) async {
    Map<String, dynamic> filters = {};
    
    if (name != null && name.isNotEmpty) filters['name'] = name;
    if (email != null && email.isNotEmpty) filters['email'] = email;
    if (role != null && role.isNotEmpty) filters['role'] = role;
    if (status != null && status.isNotEmpty) filters['status'] = status;

    try {
      final response = await _apiService.get('/platformuser', queryParameters: filters);
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.data is Map && response.data['data'] is List) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de conexión agotado. Verifica tu conexión a internet.';
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 401) {
          return 'No autorizado. Inicia sesión nuevamente.';
        } else if (error.response?.statusCode == 404) {
          return 'Usuario no encontrado.';
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