import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static ApiService? _instance;
  late Dio _dio;
  String? _currentBaseUrl;

  ApiService._internal() {
    _initializeDio();
  }

  static ApiService get instance {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  Future<void> _initializeDio() async {
    // Detectar automáticamente la URL base
    _currentBaseUrl = await ApiConfig.getApiBaseUrl();
    
    _dio = Dio(BaseOptions(
      baseUrl: _currentBaseUrl!, // baseUrl en lugar de baseURL
      connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: ApiConfig.sendTimeout),
      headers: ApiConfig.defaultHeaders,
      validateStatus: (status) => status != null && status < 500,
    ));

    // Interceptor para agregar token automáticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          print('🔄 ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ Error: ${error.message}');
          if (error.response?.statusCode == 401) {
            _handleUnauthorized();
          }
          handler.next(error);
        },
      ),
    );

    print('🚀 ApiService inicializado con: $_currentBaseUrl');
  }

  // Reconectar automáticamente si cambia el modo de la API
  Future<void> reconnect() async {
    final newBaseUrl = await ApiConfig.getApiBaseUrl();
    if (newBaseUrl != _currentBaseUrl) {
      print('🔄 Cambiando URL de $_currentBaseUrl a $newBaseUrl');
      _currentBaseUrl = newBaseUrl;
      _dio.options.baseUrl = newBaseUrl; // baseUrl en lugar de baseURL
    }
  }

  void _handleUnauthorized() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Métodos para manejo de tokens
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Métodos HTTP genéricos
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      await reconnect();
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      await reconnect();
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      await reconnect();
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      await reconnect();
      return await _dio.delete(path);
    } catch (e) {
      rethrow;
    }
  }

  // Método para subir archivos con FormData (ESTE ES EL QUE FALTABA)
  Future<Response> postMultipart(String path, FormData formData, {
    Function(int, int)? onSendProgress,
  }) async {
    try {
      await reconnect();
      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: const Duration(minutes: 5), // 5 minutos para subida
          receiveTimeout: const Duration(minutes: 5),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Método para subir archivos con timeouts largos (mantenemos ambos por compatibilidad)
  Future<Response> uploadFile(String path, FormData formData, {
    Function(int, int)? onSendProgress,
  }) async {
    return await postMultipart(path, formData, onSendProgress: onSendProgress);
  }

  // Método PUT para multipart (útil para actualizar archivos)
  Future<Response> putMultipart(String path, FormData formData, {
    Function(int, int)? onSendProgress,
  }) async {
    try {
      await reconnect();
      return await _dio.put(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: const Duration(minutes: 5),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Método para verificar conectividad
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
      return false;
    }
  }

  // Método para descargar archivos
  Future<Response> downloadFile(String path, String savePath, {
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      await reconnect();
      return await _dio.download(
        path,
        savePath,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          receiveTimeout: const Duration(minutes: 10),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtener información del servidor actual
  String get currentBaseUrl => _currentBaseUrl ?? 'No configurado';
}