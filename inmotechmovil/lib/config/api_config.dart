import 'dart:io';

class ApiConfig {
  // URLs según el escenario
  static const String devBaseUrl = 'http://localhost:3000/api';
  static const String networkBaseUrl = 'http://10.226.30.202:3000/api';
  
  // Lista de URLs a intentar (orden de prioridad)
  static const List<String> possibleUrls = [
    'http://localhost:3000/api',           // Desarrollo local
    'http://10.226.30.202:3000/api',       // Red WiFi actual
    'http://192.168.20.21:3000/api',       // Red WiFi casa
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
    
    for (String url in possibleUrls) {
      try {
        final uri = Uri.parse(url);
        final available = await _isServerAvailable(uri.host, uri.port);
        if (available) {
          print('✅ Servidor encontrado: $url');
          return url;
        } else {
          print('❌ No disponible: $url');
        }
      } catch (e) {
        print('❌ Error probando $url: $e');
        continue;
      }
    }
    
    // Fallback
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
}