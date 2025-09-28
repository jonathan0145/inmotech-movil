import 'dart:io';

class ApiConfig {
  // URLs según el escenario
  static const String devBaseUrl = 'http://localhost:3000/api';           // Solo en tu PC
  static const String networkBaseUrl = 'http://10.226.30.202:3000/api';  // En tu red WiFi
  
  // Lista de URLs a intentar (orden de prioridad)
  static const List<String> possibleUrls = [
    'http://localhost:3000/api',           // Desarrollo local (emulador/navegador)
    'http://10.226.30.202:3000/api',       // Red WiFi actual
    'http://192.168.20.21:3000/api',       // Red WiFi alternativa (casa)
    'https://clypeal-iris-rigoristic.ngrok-free.dev/api',   // <-- TU URL REAL DE NGROK
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
    
    for (String url in possibleUrls) {
      try {
        final uri = Uri.parse(url);
        final available = await _isServerAvailable(uri.host, uri.port);
        if (available) {
          print('✅ Servidor encontrado: $url');
          _logConnectionType(url);
          return url;
        } else {
          print('❌ No disponible: $url');
        }
      } catch (e) {
        print('❌ Error probando $url: $e');
        continue;
      }
    }
    
    // Si ninguna funciona, usar la de red como fallback
    print('⚠️ Ningún servidor disponible, usando fallback: $networkBaseUrl');
    return networkBaseUrl;
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

  // Log del tipo de conexión
  static void _logConnectionType(String url) {
    if (url.contains('localhost') || url.contains('127.0.0.1')) {
      print('🔧 Modo: DESARROLLO LOCAL');
    } else if (url.contains('10.226.30.202')) {
      print('🏠 Modo: RED WiFi ACTUAL');
    } else if (url.contains('192.168.20.21')) {
      print('🏠 Modo: RED WiFi CASA');
    } else if (url.contains('ngrok-free.dev') || url.contains('ngrok.io')) {
      print('🌐 Modo: PÚBLICO (ngrok)');
    } else {
      print('❓ Modo: DESCONOCIDO');
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