import 'package:dio/dio.dart';
import 'dart:io';
import 'api_service.dart';

class ContentService {
  final ApiService _apiService = ApiService.instance;

  // ========== TÉRMINOS Y CONDICIONES ==========
  Future<Map<String, dynamic>> createTerminos(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/terminosycondiciones', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAllTerminos() async {
    try {
      final response = await _apiService.get('/terminosycondiciones');
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

  Future<Map<String, dynamic>> getTerminosById(int id) async {
    try {
      final response = await _apiService.get('/terminosycondiciones/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ========== POLÍTICA DE PRIVACIDAD ==========
  Future<Map<String, dynamic>> createPolitica(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/politicadeprivacidad', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAllPoliticas() async {
    try {
      final response = await _apiService.get('/politicadeprivacidad');
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

  Future<Map<String, dynamic>> getPoliticaById(int id) async {
    try {
      final response = await _apiService.get('/politicadeprivacidad/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ========== SOBRE NOSOTROS ==========
  Future<List<Map<String, dynamic>>> getAllSobreNosotros() async {
    try {
      final response = await _apiService.get('/sobrenosotros');
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

  Future<Map<String, dynamic>> getSobreNosotrosById(int id) async {
    try {
      final response = await _apiService.get('/sobrenosotros/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> uploadSobreNosotrosImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'imagen': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _apiService.postMultipart('/sobrenosotros/upload', formData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ========== PREGUNTAS FRECUENTES ==========
  Future<List<Map<String, dynamic>>> getAllPreguntas() async {
    try {
      final response = await _apiService.get('/preguntasfrecuentes');
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

  Future<Map<String, dynamic>> getPreguntaById(int id) async {
    try {
      final response = await _apiService.get('/preguntasfrecuentes/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ========== CARRUSEL ==========
  Future<List<Map<String, dynamic>>> getAllCarrusel() async {
    try {
      final response = await _apiService.get('/carrusel');
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

  Future<Map<String, dynamic>> uploadCarruselImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _apiService.postMultipart('/carrusel/upload', formData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ========== PORQUÉ ELEGIRNOS ==========
  Future<List<Map<String, dynamic>>> getAllPorqueElegirnos() async {
    try {
      final response = await _apiService.get('/porqueelegirnos');
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

  Future<Map<String, dynamic>> getPorqueElegirnosById(int id) async {
    try {
      final response = await _apiService.get('/porqueelegirnos/$id');
      return response.data;
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
          return 'Contenido no encontrado.';
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