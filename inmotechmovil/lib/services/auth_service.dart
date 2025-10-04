import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🔍 Intentando login con username: $username');
      
      // ✅ USAR EL MISMO FORMATO QUE TU WEB
      Map<String, dynamic> loginData = {
        'Username': username.trim(), // ✅ CON MAYÚSCULA IGUAL QUE WEB
        'password': password.trim(),
      };

      print('🔍 Datos a enviar: $loginData');

      final response = await _apiService.post('/login', data: loginData);

      print('📡 Status: ${response.statusCode}');
      print('📄 Response completa: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        
        final token = data['token'] as String?;
        final userData = data['user'] as Map<String, dynamic>?;
        
        if (token != null && userData != null) {
          final prefs = await SharedPreferences.getInstance();
          
          // ✅ GUARDAR TOKEN
          await prefs.setString('auth_token', token);
          await prefs.setString('token', token); // ✅ BACKUP IGUAL QUE WEB
          print('💾 Token guardado: ${token.substring(0, 20)}...');
          
          // ✅ GUARDAR USER DATA IGUAL QUE WEB
          final userId = userData['id'];
          if (userId != null) {
            await prefs.setInt('user_id', userId);
            await prefs.setInt('Platform_user_id', userId);
            await prefs.setInt('userId', userId);
            print('👤 User ID guardado: $userId');
          }
          
          // ✅ GUARDAR USER OBJECT COMPLETO (igual que localStorage en web)
          await prefs.setString('user', 
              '{"id":${userData['id']},"username":"${userData['username']}","role":${userData['role']},"status":${userData['status']}}');
          await prefs.setString('usuario', 
              '{"id":${userData['id']},"username":"${userData['username']}","role":${userData['role']},"status":${userData['status']}}');
          
          final username = userData['username'];
          final role = userData['role'];
          final status = userData['status'];
          
          if (username != null) {
            await prefs.setString('username', username.toString());
            print('👤 Username guardado: $username');
          }
          
          if (role != null) {
            await prefs.setInt('user_role', role);
            print('🔐 Role guardado: $role');
          }
          
          if (status != null) {
            await prefs.setInt('user_status', status);
            print('📊 Status guardado: $status');
          }

          final savedUserId = prefs.getInt('user_id');
          print('🔍 User ID verificado: $savedUserId');

          return {
            'success': true,
            'token': token,
            'user': userData,
            'message': 'Login exitoso'
          };
        } else {
          throw Exception('Token o datos de usuario faltantes');
        }
      } else {
        throw Exception('Respuesta inválida del servidor');
      }
    } catch (e) {
      // ✅ CAPTURAR RESPUESTA DEL ERROR 400
      if (e is DioException && e.response != null) {
        print('❌ Status Code: ${e.response!.statusCode}');
        print('❌ Response Data: ${e.response!.data}');
        print('❌ Request Data: ${e.requestOptions.data}');
        print('❌ Request Headers: ${e.requestOptions.headers}');
        
        // ✅ EXTRAER MENSAJE ESPECÍFICO DEL SERVIDOR
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map<String, dynamic>;
          final errorMessage = errorData['error'] ?? 
                             errorData['message'] ?? 
                             'Credenciales incorrectas';
          throw Exception(errorMessage);
        }
      }
      
      print('❌ Error en login: $e');
      throw Exception('Error de login: ${e.toString()}');
    }
  }

  // ✅ MÉTODO PARA REGISTRO (igual formato que web)
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      print('🔍 Intentando registro con username: $username, email: $email');
      
      // ✅ VALIDAR EMAIL TEMPORAL
      if (isTemporaryEmail(email)) {
        throw Exception('No se permiten emails temporales');
      }
      
      // ✅ USAR EL MISMO FORMATO QUE TU WEB
      Map<String, dynamic> registerData = {
        'Username': username.trim(), // ✅ CON MAYÚSCULA IGUAL QUE WEB
        'email': email.trim(),
        'password': password.trim(),
      };

      print('🔍 Datos de registro a enviar: $registerData');

      final response = await _apiService.post('/register', data: registerData);

      print('📡 Register Status: ${response.statusCode}');
      print('📄 Register Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Registro exitoso',
          'data': response.data
        };
      } else {
        throw Exception('Error en el registro');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        print('❌ Register Status Code: ${e.response!.statusCode}');
        print('❌ Register Response Data: ${e.response!.data}');
        
        if (e.response!.data is Map) {
          final errorData = e.response!.data as Map<String, dynamic>;
          final errorMessage = errorData['error'] ?? 
                             errorData['message'] ?? 
                             'Error en el registro';
          throw Exception(errorMessage);
        }
      }
      
      print('❌ Error en registro: $e');
      throw Exception('Error de registro: ${e.toString()}');
    }
  }

  // ✅ AGREGAR MÉTODO PARA VERIFICAR DISPONIBILIDAD DE USERNAME
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      print('🔍 Verificando disponibilidad de username: $username');
      
      final response = await _apiService.get('/check-username', 
        queryParameters: {'username': username.trim()});
      
      print('📡 Username check status: ${response.statusCode}');
      print('📄 Username check response: ${response.data}');
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        
        // ✅ ASUMIR QUE EL SERVIDOR RETORNA { available: true/false }
        final available = data['available'] ?? true;
        print('✅ Username disponible: $available');
        return available;
      }
      
      // ✅ SI NO HAY ENDPOINT, ASUMIR DISPONIBLE
      return true;
    } catch (e) {
      print('❌ Error verificando username: $e');
      
      // ✅ SI HAY ERROR 404, ASUMIR QUE EL ENDPOINT NO EXISTE
      if (e is DioException && e.response?.statusCode == 404) {
        print('⚠️ Endpoint de verificación no disponible, asumiendo username disponible');
        return true;
      }
      
      // ✅ EN OTROS ERRORES, ASUMIR DISPONIBLE PARA NO BLOQUEAR
      return true;
    }
  }

  // ✅ AGREGAR MÉTODO PARA VERIFICAR DISPONIBILIDAD DE EMAIL
  Future<bool> checkEmailAvailability(String email) async {
    try {
      print('🔍 Verificando disponibilidad de email: $email');
      
      final response = await _apiService.get('/check-email', 
        queryParameters: {'email': email.trim()});
      
      print('📡 Email check status: ${response.statusCode}');
      print('📄 Email check response: ${response.data}');
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        
        // ✅ ASUMIR QUE EL SERVIDOR RETORNA { available: true/false }
        final available = data['available'] ?? true;
        print('✅ Email disponible: $available');
        return available;
      }
      
      // ✅ SI NO HAY ENDPOINT, ASUMIR DISPONIBLE
      return true;
    } catch (e) {
      print('❌ Error verificando email: $e');
      
      // ✅ SI HAY ERROR 404, ASUMIR QUE EL ENDPOINT NO EXISTE
      if (e is DioException && e.response?.statusCode == 404) {
        print('⚠️ Endpoint de verificación no disponible, asumiendo email disponible');
        return true;
      }
      
      // ✅ EN OTROS ERRORES, ASUMIR DISPONIBLE PARA NO BLOQUEAR
      return true;
    }
  }

  // ✅ MÉTODO PARA VALIDAR EMAIL TEMPORAL (igual que tu web)
  bool isTemporaryEmail(String email) {
    const tempDomains = [
      'mailinator.com',
      'tempmail.com',
      '10minutemail.com',
      'guerrillamail.com',
      'yopmail.com',
      'temp-mail.org',
      'throwaway.email',
      'maildrop.cc',
      'mailcatch.com',
      'mohmal.com',
    ];
    
    final domain = email.split('@').last.toLowerCase();
    final isTempEmail = tempDomains.contains(domain);
    
    print('🔍 Verificando email temporal: $email -> $isTempEmail');
    return isTempEmail;
  }

  Future<int?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      int? userId = prefs.getInt('user_id') ?? 
                   prefs.getInt('Platform_user_id') ?? 
                   prefs.getInt('userId');
      
      print('🔍 Current User ID obtenido: $userId');
      
      // ✅ SI NO ENCUENTRA POR INT, INTENTAR EXTRAER DEL USER STRING
      if (userId == null) {
        final userString = prefs.getString('user') ?? prefs.getString('usuario');
        if (userString != null) {
          try {
            // ✅ PARSEAR JSON BÁSICO (sin dart:convert para evitar dependencias)
            final userIdMatch = RegExp(r'"id":(\d+)').firstMatch(userString);
            if (userIdMatch != null) {
              userId = int.parse(userIdMatch.group(1)!);
              print('🔍 User ID extraído del JSON: $userId');
              
              // ✅ GUARDARLO COMO INT PARA PRÓXIMAS VECES
              await prefs.setInt('user_id', userId);
            }
          } catch (e) {
            print('❌ Error parseando user JSON: $e');
          }
        }
      }
      
      return userId;
    } catch (e) {
      print('❌ Error obteniendo current user ID: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? prefs.getString('token');
      print('🔑 Token obtenido: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
      return token;
    } catch (e) {
      print('❌ Error obteniendo token: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final userId = await getCurrentUserId();
    
    final isLoggedIn = token != null && userId != null;
    print('🔐 Usuario logueado: $isLoggedIn (token: ${token != null}, userId: $userId)');
    
    return isLoggedIn;
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // ✅ LIMPIAR TODOS LOS DATOS (igual que web)
      await prefs.remove('auth_token');
      await prefs.remove('token');
      await prefs.remove('user_id');
      await prefs.remove('Platform_user_id');
      await prefs.remove('userId');
      await prefs.remove('username');
      await prefs.remove('user_role');
      await prefs.remove('user_status');
      await prefs.remove('user');
      await prefs.remove('usuario');
      
      print('🚪 Logout completo - datos limpiados');
    } catch (e) {
      print('❌ Error en logout: $e');
    }
  }

  // ✅ MÉTODO PARA DEBUG
  Future<void> debugSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      print('🐛 DEBUG - SharedPreferences:');
      for (String key in keys) {
        final value = prefs.get(key);
        if (key.contains('pass') || key.contains('token')) {
          print('  - $key: [HIDDEN]');
        } else {
          print('  - $key: $value');
        }
      }
    } catch (e) {
      print('❌ Error en debug: $e');
    }
  }
}