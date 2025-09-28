import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static final Dio _dio = Dio();
  
  static ApiService? _instance;
  static ApiService get instance {
    _instance ??= ApiService._init();
    return _instance!;
  }

  ApiService._init() {
    _dio.options = BaseOptions(
      baseUrl: ApiConfig.apiBaseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: ApiConfig.defaultHeaders,
      // Configuraciones adicionales para conexiones lentas
      followRedirects: true,
      maxRedirects: 5,
      persistentConnection: true,
    );

    // Interceptor para agregar el token automáticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          // Log para debug en desarrollo
          if (ApiConfig.enableLogging) {
            print('🚀 REQUEST: ${options.method} ${options.uri}');
            print('📤 Headers: ${options.headers}');
          }
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log para debug en desarrollo
          if (ApiConfig.enableLogging) {
            print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          // Log para debug en desarrollo
          if (ApiConfig.enableLogging) {
            print('❌ ERROR: ${error.message}');
            print('🔗 URL: ${error.requestOptions.uri}');
            if (error.response != null) {
              print('📥 Response: ${error.response?.statusCode} - ${error.response?.statusMessage}');
            }
          }
          
          if (error.response?.statusCode == 401) {
            // Token expirado o inválido
            await _removeToken();
            // Aquí podrías navegar a la pantalla de login
          }
          handler.next(error);
        },
      ),
    );
  }

  // Métodos HTTP genéricos
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } catch (e) {
      rethrow;
    }
  }

  // Método con timeout personalizado para conexiones muy lentas
  Future<Response> getWithCustomTimeout(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Duration? customTimeout,
  }) async {
    try {
      return await _dio.get(
        endpoint, 
        queryParameters: queryParameters,
        options: Options(
          receiveTimeout: customTimeout ?? const Duration(minutes: 2),
          sendTimeout: customTimeout ?? const Duration(minutes: 1),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postWithCustomTimeout(
    String endpoint, {
    dynamic data,
    Duration? customTimeout,
  }) async {
    try {
      return await _dio.post(
        endpoint, 
        data: data,
        options: Options(
          receiveTimeout: customTimeout ?? const Duration(minutes: 2),
          sendTimeout: customTimeout ?? const Duration(minutes: 1),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postMultipart(String endpoint, FormData formData) async {
    try {
      return await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Manejo del token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConfig.tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.tokenKey, token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.tokenKey);
  }

  Future<void> clearToken() async {
    await _removeToken();
  }

  // Método para verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }
}