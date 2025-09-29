import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiConfig {
  static const String devBaseUrl = 'http://localhost:3000/api';
  static const String networkBaseUrl = 'http://192.168.20.21:3000/api';
  
  static const List<String> possibleUrls = [
    'http://localhost:3000/api',
    'http://192.168.20.21:3000/api',
    'http://10.226.30.202:3000/api',
    'https://clypeal-iris-rigoristic.ngrok-free.dev/api',
  ];

  static const int connectTimeout = 5000;
  static const int receiveTimeout = 5000;
  static const int sendTimeout = 5000;

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<String> getApiBaseUrl() async {
    print('🔍 Detectando servidor API disponible...');
    
    // Si estamos en web, usar localhost primero
    if (kIsWeb) {
      print('🌐 Ejecutándose en web - probando localhost primero');
      if (await _testConnection('http://localhost:3000/api')) {
        print('✅ Servidor encontrado: http://localhost:3000/api');
        return 'http://localhost:3000/api';
      }
    }
    
    for (String url in possibleUrls) {
      if (await _testConnection(url)) {
        print('✅ Servidor encontrado: $url');
        return url;
      } else {
        print('❌ No disponible: $url');
      }
    }
    
    print('⚠️ Ningún servidor disponible, usando fallback: $networkBaseUrl');
    return networkBaseUrl;
  }

  static Future<bool> _testConnection(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '$url/test',
        options: Options(
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static String getConnectionType(String url) {
    if (url.contains('localhost') || url.contains('127.0.0.1')) {
      return '🔧 Desarrollo';
    } else if (url.contains('192.168.') || url.contains('10.')) {
      return '🌐 WiFi Local';
    } else if (url.contains('ngrok')) {
      return '🌍 Público';
    } else {
      return '🌐 Red';
    }
  }
}

class ApiService {
  final Dio _dio = Dio();

  // ... otros métodos de ApiService

  Future<Response> postMultipart(String endpoint, FormData formData) async {
    try {
      print('📤 POST Multipart $endpoint');
      
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      print('📡 Status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('❌ Error en postMultipart: $e');
      rethrow;
    }
  }
}