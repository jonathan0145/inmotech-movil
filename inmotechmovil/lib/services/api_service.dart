import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  static ApiService get instance => _instance;
  
  late Dio _dio;
  String _currentBaseUrl = '';
  bool _isInitialized = false;

  ApiService._internal();

  // Getter para obtener la URL actual
  String get currentBaseUrl => _currentBaseUrl;

  // Inicializar el servicio
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Detectar automáticamente la URL disponible
    _currentBaseUrl = await ApiConfig.getApiBaseUrl();
    
    _dio = Dio(BaseOptions(
      baseUrl: _currentBaseUrl,
      connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: ApiConfig.sendTimeout),
      headers: ApiConfig.defaultHeaders,
    ));

    // Interceptor para logs
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('🔄 ${obj.toString()}'),
    ));

    // Interceptor para agregar token automáticamente
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Si el token expiró, limpiar y redirigir al login
        if (error.response?.statusCode == 401) {
          await clearToken();
        }
        handler.next(error);
      },
    ));

    _isInitialized = true;
    print('✅ ApiService inicializado con: $_currentBaseUrl');
  }

  // Verificar si está conectado al servidor
  Future<bool> isConnected() async {
    try {
      final response = await _dio.get('/test', 
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error de conexión: $e');
      return false;
    }
  }

  // Reconectar con detección automática
  Future<void> reconnect() async {
    print('🔄 Reconectando...');
    _isInitialized = false;
    await initialize();
  }

  // GET
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    if (!_isInitialized) await initialize();
    
    try {
      print('🔄 GET $path');
      final response = await _dio.get(path, queryParameters: queryParameters);
      print('✅ ${response.statusCode} $path');
      return response;
    } catch (e) {
      print('❌ Error GET $path: $e');
      rethrow;
    }
  }

  // POST
  Future<Response> post(String path, {dynamic data}) async {
    if (!_isInitialized) await initialize();
    
    try {
      print('🔄 POST $path');
      final response = await _dio.post(path, data: data);
      print('✅ ${response.statusCode} $path');
      return response;
    } catch (e) {
      print('❌ Error POST $path: $e');
      rethrow;
    }
  }

  // PUT
  Future<Response> put(String path, {dynamic data}) async {
    if (!_isInitialized) await initialize();
    return await _dio.put(path, data: data);
  }

  // DELETE
  Future<Response> delete(String path) async {
    if (!_isInitialized) await initialize();
    return await _dio.delete(path);
  }

  // Gestión de tokens
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // POST Multipart
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
          sendTimeout: const Duration(minutes: 5), // Tiempo extra para archivos
          receiveTimeout: const Duration(minutes: 5),
        ),
      );
      
      print('📡 Status: ${response.statusCode}');
      print('📄 Response: ${response.data}');
      return response;
    } catch (e) {
      print('❌ Error en postMultipart: $e');
      rethrow;
    }
  }

  // PUT Multipart
  Future<Response> putMultipart(String endpoint, FormData formData) async {
    try {
      print('📤 PUT Multipart $endpoint');
      
      final response = await _dio.put(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: const Duration(minutes: 5),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );
      
      print('📡 Status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('❌ Error en putMultipart: $e');
      rethrow;
    }
  }
}