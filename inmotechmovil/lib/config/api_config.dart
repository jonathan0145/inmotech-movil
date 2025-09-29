import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiConfig {
  // URLs base según el escenario
  static const String devBaseUrl = 'http://localhost:3000/api';           // Desarrollo local
  static const String networkBaseUrl = 'http://10.226.30.202:3000/api';  // Red WiFi actual
  
  // Lista de URLs a intentar (orden de prioridad)
  static const List<String> possibleUrls = [
    'http://localhost:3000/api',           // Desarrollo local
    'http://192.168.20.21:3000/api',       // Red WiFi casa
    'http://10.226.30.202:3000/api',       // Red WiFi actual
    'http://192.168.20.21:3000/api',       // Red WiFi alternativa
    'https://clypeal-iris-rigoristic.ngrok-free.dev/api',   // ngrok público
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

  // Log del tipo de conexión
  static void _logConnectionType(String url) {
    if (url.contains('localhost') || url.contains('127.0.0.1')) {
      print('🔧 Modo: DESARROLLO LOCAL');
    } else if (url.contains('10.226.30.202')) {
      print('🏠 Modo: RED WiFi ACTUAL');
    } else if (url.contains('192.168.20.21')) {
      print('🏠 Modo: RED WiFi ALTERNATIVA');
    } else if (url.contains('ngrok-free.dev') || url.contains('ngrok.io')) {
      print('🌐 Modo: PÚBLICO (ngrok)');
    } else {
      print('❓ Modo: DESCONOCIDO');
    }
  }

  // Obtener tipo de conexión para mostrar en UI
  static String getConnectionType(String url) {
    if (url.contains('localhost') || url.contains('127.0.0.1')) {
      return '🔧 Local';
    } else if (url.contains('10.226.30.202')) {
      return '🏠 WiFi';
    } else if (url.contains('192.168.20.21')) {
      return '🏠 WiFi Casa';
    } else if (url.contains('ngrok-free.dev') || url.contains('ngrok.io')) {
      return '🌐 Público';
    } else {
      return '❓ Desconocido';
    }
  }

  // Endpoints
  static const String authEndpoint = '/auth';
  static const String inmueblesEndpoint = '/inmuebles';
  static const String platformProfileEndpoint = '/platformprofile';
  static const String visualizationsEndpoint = '/visualizations';
  static const String terminosEndpoint = '/terminosycondiciones';
  static const String politicaEndpoint = '/politicadeprivacidad';
  
  static Future<String> getEndpointUrl(String endpoint) async {
    final baseUrl = await getApiBaseUrl();
    return '$baseUrl$endpoint';
  }
}