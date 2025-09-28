import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService.instance;

  // Login de usuario
  Future<Map<String, dynamic>> login(String usuario, String password) async {
    try {
      final response = await _apiService.post('/auth/login', data: {
        'usuario': usuario,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Guardar token si existe
        final token = response.data['data']?['token'];
        if (token != null) {
          await _apiService.saveToken(token);
        }

        return {
          'success': true,
          'message': response.data['message'] ?? 'Login exitoso',
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Credenciales incorrectas',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}',
      };
    }
  }

  // Registro de usuario
  Future<Map<String, dynamic>> register(String usuario, String email, String password) async {
    try {
      final response = await _apiService.post('/auth/register', data: {
        'usuario': usuario,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201 && response.data['success'] == true) {
        // Guardar token si existe
        final token = response.data['data']?['token'];
        if (token != null) {
          await _apiService.saveToken(token);
        }

        return {
          'success': true,
          'message': response.data['message'] ?? 'Usuario registrado exitosamente',
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Error al registrar usuario',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}',
      };
    }
  }

  // Verificar disponibilidad de nombre de usuario
  Future<Map<String, dynamic>> checkUsernameAvailability(String username) async {
    try {
      final response = await _apiService.get('/auth/check-username',
          queryParameters: {'username': username}
      );

      if (response.statusCode == 200) {
        return {
          'available': response.data['available'] ?? false,
          'message': response.data['message'] ?? '',
        };
      } else {
        return {
          'available': false,
          'message': 'Error al verificar disponibilidad',
        };
      }
    } on DioException catch (e) {
      return {
        'available': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'available': false,
        'message': 'Error inesperado: ${e.toString()}',
      };
    }
  }

  // Verificar disponibilidad de email
  Future<Map<String, dynamic>> checkEmailAvailability(String email) async {
    try {
      final response = await _apiService.get('/auth/check-email',
          queryParameters: {'email': email}
      );

      if (response.statusCode == 200) {
        return {
          'available': response.data['available'] ?? false,
          'message': response.data['message'] ?? '',
        };
      } else {
        return {
          'available': false,
          'message': 'Error al verificar disponibilidad',
        };
      }
    } on DioException catch (e) {
      return {
        'available': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'available': false,
        'message': 'Error inesperado: ${e.toString()}',
      };
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      await _apiService.post('/auth/logout');
      await _apiService.clearToken();

      return {
        'success': true,
        'message': 'Sesión cerrada correctamente',
      };
    } catch (e) {
      // Aunque falle la petición, limpiar token local
      await _apiService.clearToken();
      return {
        'success': true,
        'message': 'Sesión cerrada correctamente',
      };
    }
  }

  // Verificar si está autenticado
  Future<bool> isAuthenticated() async {
    return await _apiService.isAuthenticated();
  }

  // Obtener información del usuario actual
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': 'No se pudo obtener información del usuario',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}',
      };
    }
  }

  // Cambiar contraseña
  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await _apiService.post('/auth/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Contraseña cambiada exitosamente',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Error al cambiar contraseña',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}',
      };
    }
  }

  // Recuperar contraseña
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _apiService.post('/auth/forgot-password', data: {
        'email': email,
      });

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Correo de recuperación enviado',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Error al enviar correo de recuperación',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}',
      };
    }
  }

  // Manejo de errores de Dio
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de respuesta agotado';
      case DioExceptionType.badResponse:
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          return e.response!.data['message'];
        }
        return 'Error del servidor: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Petición cancelada';
      case DioExceptionType.connectionError:
        return 'Error de conexión. Verifica tu internet';
      default:
        return 'Error de conexión: ${e.message}';
    }
  }
}