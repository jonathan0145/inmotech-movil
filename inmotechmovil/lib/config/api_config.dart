import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiConfig {
  // URLs según el escenario
  static const String devBaseUrl = 'http://localhost:3000/api';
  static const String networkBaseUrl = 'http://192.168.20.21:3000/api';
  
  // Lista de URLs a intentar (orden de prioridad)
  static const List<String> possibleUrls = [
    'http://localhost:3000/api',           // Desarrollo local
    'http://192.168.20.21:3000/api',       // Red WiFi casa
    'http://10.226.30.202:3000/api',       // Red WiFi actual
    'https://clypeal-iris-rigoristic.ngrok-free.dev/api', // ngrok público
  ];

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
  
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Detectar automáticamente qué URL usar
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
    
    // Fallback
    print('⚠️ Ningún servidor disponible, usando fallback: $networkBaseUrl');
    return networkBaseUrl;
  }

  // Probar conexión a una URL
  static Future<bool> _testConnection(String url) async {
    try {
      if (kIsWeb) {
        // En web, usar fetch API a través de Dio
        return await _testWebConnection(url);
      } else {
        // En móvil, usar Socket
        final uri = Uri.parse(url);
        final socket = await Socket.connect(
          uri.host, 
          uri.port, 
          timeout: const Duration(seconds: 3),
        );
        socket.destroy();
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  // Probar conexión en la web usando Dio
  static Future<bool> _testWebConnection(String url) async {
    try {
      // Importar dio aquí si no está ya importado
      final response = await Dio().get('$url/test', 
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
}