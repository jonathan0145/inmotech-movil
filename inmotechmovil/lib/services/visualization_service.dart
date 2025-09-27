import 'package:dio/dio.dart';
import 'api_service.dart';

class VisualizationService {
  final ApiService _apiService = ApiService.instance;

  // Registrar una visualización
  Future<Map<String, dynamic>> registerVisualization(Map<String, dynamic> visualizationData) async {
    try {
      final response = await _apiService.post('/visualizations', data: visualizationData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Obtener estadísticas de visualizaciones
  Future<Map<String, dynamic>> getStats({Map<String, dynamic>? filters}) async {
    try {
      final response = await _apiService.get('/visualizations/estadisticas', queryParameters: filters);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Registrar visualización de un inmueble específico
  Future<Map<String, dynamic>> registerInmuebleView(int inmuebleId, {
    String? deviceType,
    String? location,
    Map<String, dynamic>? metadata,
  }) async {
    final data = {
      'inmuebleId': inmuebleId,
      'timestamp': DateTime.now().toIso8601String(),
      if (deviceType != null) 'deviceType': deviceType,
      if (location != null) 'location': location,
      if (metadata != null) ...metadata,
    };

    return await registerVisualization(data);
  }

  // Obtener estadísticas de un inmueble específico
  Future<Map<String, dynamic>> getInmuebleStats(int inmuebleId) async {
    return await getStats(filters: {'inmuebleId': inmuebleId});
  }

  // Obtener estadísticas por rango de fechas
  Future<Map<String, dynamic>> getStatsByDateRange(DateTime startDate, DateTime endDate) async {
    return await getStats(filters: {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });
  }

  // Obtener estadísticas más populares
  Future<Map<String, dynamic>> getMostViewedInmuebles({int limit = 10}) async {
    return await getStats(filters: {'mostViewed': true, 'limit': limit});
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
          return 'Estadísticas no encontradas.';
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