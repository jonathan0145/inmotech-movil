import 'package:dio/dio.dart';
import 'dart:io';
import 'api_service.dart';

class InmuebleService {
  final ApiService _apiService = ApiService.instance;

  // Obtener todos los inmuebles
  Future<List<Map<String, dynamic>>> getAllInmuebles({Map<String, dynamic>? filters}) async {
    try {
      final response = await _apiService.get('/inmuebles', queryParameters: filters);
      
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

  // Obtener inmueble por ID
  Future<Map<String, dynamic>> getInmuebleById(int id) async {
    try {
      final response = await _apiService.get('/inmuebles/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Crear inmueble simple
  Future<Map<String, dynamic>> createInmueble(Map<String, dynamic> inmuebleData) async {
    try {
      final response = await _apiService.post('/inmuebles', data: inmuebleData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Crear inmueble anidado (con relaciones)
  Future<Map<String, dynamic>> createInmuebleAnidado(Map<String, dynamic> inmuebleData) async {
    try {
      final response = await _apiService.post('/inmuebles/anidado', data: inmuebleData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Actualizar inmueble
  Future<Map<String, dynamic>> updateInmueble(int id, Map<String, dynamic> inmuebleData) async {
    try {
      final response = await _apiService.put('/inmuebles/$id', data: inmuebleData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Eliminar inmueble
  Future<void> deleteInmueble(int id) async {
    try {
      await _apiService.delete('/inmuebles/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Subir imagen de inmueble
  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'imagen': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _apiService.postMultipart('/inmuebles/upload-imagen', formData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Buscar inmuebles con filtros específicos
  Future<List<Map<String, dynamic>>> searchInmuebles({
    String? query,
    int? minPrice,
    int? maxPrice,
    int? habitaciones,
    int? banos,
    String? tipo,
    String? ubicacion,
  }) async {
    Map<String, dynamic> filters = {};
    
    if (query != null && query.isNotEmpty) filters['q'] = query;
    if (minPrice != null) filters['min_price'] = minPrice;
    if (maxPrice != null) filters['max_price'] = maxPrice;
    if (habitaciones != null) filters['habitaciones'] = habitaciones;
    if (banos != null) filters['banos'] = banos;
    if (tipo != null && tipo.isNotEmpty) filters['tipo'] = tipo;
    if (ubicacion != null && ubicacion.isNotEmpty) filters['ubicacion'] = ubicacion;

    return await getAllInmuebles(filters: filters);
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
          return 'Inmueble no encontrado.';
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