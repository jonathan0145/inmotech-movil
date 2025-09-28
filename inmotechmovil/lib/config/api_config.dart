import 'dart:io';

class ApiConfig {
  // URLs de tu API según el modo
  static const String devBaseUrl = 'http://localhost:3000/api';      // Para npm run dev
  static const String prodBaseUrl = 'http://192.168.20.21:3000/api'; // Para npm start
  
  // Timeouts aumentados para conexiones lentas
  static const int connectTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos
  static const int sendTimeout = 30000;    // 30 segundos
  
  // Headers por defecto
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Detectar automáticamente qué URL usar
  static Future<String> getApiBaseUrl() async {
    try {
      // Primero intentar localhost (modo desarrollo)
      final localhost = await _isServerAvailable('localhost', 3000);
      if (localhost) {
        print('🔧 Conectando a API en modo DESARROLLO: $devBaseUrl');
        return devBaseUrl;
      }
      
      // Si localhost no está disponible, intentar IP de red (modo producción)
      final networkServer = await _isServerAvailable('192.168.20.21', 3000);
      if (networkServer) {
        print('🌐 Conectando a API en modo PRODUCCIÓN: $prodBaseUrl');
        return prodBaseUrl;
      }
      
      // Si ninguno está disponible, usar producción como fallback
      print('⚠️ No se pudo detectar el servidor, usando fallback: $prodBaseUrl');
      return prodBaseUrl;
      
    } catch (e) {
      print('❌ Error detectando servidor: $e');
      return prodBaseUrl; // Fallback a producción
    }
  }

  // Verificar si un servidor está disponible
  static Future<bool> _isServerAvailable(String host, int port) async {
    try {
      final socket = await Socket.connect(
        host, 
        port, 
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Endpoints específicos
  static const String authEndpoint = '/auth';
  static const String inmueblesEndpoint = '/inmuebles';
  static const String platformProfileEndpoint = '/platformprofile';
  static const String visualizationsEndpoint = '/visualizations';
  static const String terminosEndpoint = '/terminosycondiciones';
  static const String politicaEndpoint = '/politicadeprivacidad';
  
  // Método para obtener URL completa de endpoint
  static Future<String> getEndpointUrl(String endpoint) async {
    final baseUrl = await getApiBaseUrl();
    return '$baseUrl$endpoint';
  }
}