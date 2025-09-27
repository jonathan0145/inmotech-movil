import 'package:dio/dio.dart';
import 'dart:io';
import 'api_service.dart';

class ProfileService {
  final ApiService _apiService = ApiService.instance;

  // Crear perfil del usuario logueado
  Future<Map<String, dynamic>> createProfileByUser(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiService.post('/platformprofile/by-user', data: profileData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Actualizar perfil del usuario logueado
  Future<Map<String, dynamic>> updateProfileByUser(int userId, Map<String, dynamic> profileData) async {
    try {
      final data = {...profileData, 'userId': userId};
      final response = await _apiService.put('/platformprofile/by-user', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener perfil por userId
  Future<Map<String, dynamic>> getProfileByUserId(int userId) async {
    try {
      final response = await _apiService.get('/platformprofile/by-user', queryParameters: {'userId': userId});
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Subir foto de perfil
  Future<Map<String, dynamic>> uploadProfilePhoto(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _apiService.postMultipart('/platformprofile/upload', formData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Métodos generales de perfil (para administradores)
  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiService.post('/platformprofile', data: profileData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    try {
      final response = await _apiService.get('/platformprofile');
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

  Future<Map<String, dynamic>> getProfileById(int id) async {
    try {
      final response = await _apiService.get('/platformprofile/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateProfile(int id, Map<String, dynamic> profileData) async {
    try {
      final response = await _apiService.put('/platformprofile/$id', data: profileData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteProfile(int id) async {
    try {
      await _apiService.delete('/platformprofile/$id');
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
          return 'Perfil no encontrado.';
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