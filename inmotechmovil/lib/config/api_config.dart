class ApiConfig {
  // URLs base - similar a tu constants.js
  static const String localBaseUrl = 'http://localhost:3000/api';
  static const String networkBaseUrl = 'http://192.168.20.21:3000/api';
  
  // URL base principal - usando la IP de la red como en tu constants.js
  static const String baseUrl = networkBaseUrl;
  
  // Configuraciones de tiempo de espera (aumentadas para conexiones lentas por IP)
  static const Duration connectTimeout = Duration(seconds: 30); // Tiempo para establecer conexión
  static const Duration receiveTimeout = Duration(seconds: 60); // Tiempo para recibir respuesta
  static const Duration sendTimeout = Duration(seconds: 30);    // Tiempo para enviar datos
  
  // Configuraciones de autenticación
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  
  // Headers por defecto
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Endpoints principales
  static const String authEndpoint = '/auth';
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String googleLoginEndpoint = '/google';
  static const String profileEndpoint = '/auth/perfil';
  
  static const String inmueblesEndpoint = '/inmuebles';
  static const String platformProfileEndpoint = '/platformprofile';
  static const String platformUserEndpoint = '/platformuser';
  
  static const String terminosEndpoint = '/terminosycondiciones';
  static const String politicaEndpoint = '/politicadeprivacidad';
  static const String sobreNosotrosEndpoint = '/sobrenosotros';
  static const String preguntasEndpoint = '/preguntasfrecuentes';
  static const String carruselEndpoint = '/carrusel';
  static const String porqueElegirnosEndpoint = '/porqueelegirnos';
  
  static const String visualizationsEndpoint = '/visualizations';
  
  // Configuraciones de entorno
  static const bool isProduction = false; // Cambiar a true en producción
  static const bool enableLogging = true; // Deshabilitar en producción
  
  // Método para obtener la URL base (como getter)
  static String get apiBaseUrl => baseUrl;
}