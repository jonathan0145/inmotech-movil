import 'package:dio/dio.dart';
import 'api_service.dart';

class PerfilService {
  final ApiService _apiService = ApiService();

  // Crear perfil del usuario logueado
  Future<Map<String, dynamic>> createByUser(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/platformprofile/by-user', data: data);
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Error al crear perfil: ${e.response?.data ?? e.message}');
      }
      throw Exception('Error al crear perfil: ${e.toString()}');
    }
  }

  // Editar perfil del usuario logueado
  Future<Map<String, dynamic>> updateByUser(int userId, Map<String, dynamic> data) async {
    try {
      final dataWithUserId = Map<String, dynamic>.from(data);
      dataWithUserId['userId'] = userId;
      
      final response = await _apiService.put('/platformprofile/by-user', data: dataWithUserId);
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Error al actualizar perfil: ${e.response?.data ?? e.message}');
      }
      throw Exception('Error al actualizar perfil: ${e.toString()}');
    }
  }

  // Obtener perfil por userId
  Future<Map<String, dynamic>?> getByUserId(int userId) async {
    try {
      final response = await _apiService.get(
        '/platformprofile/by-user', 
        queryParameters: {'userId': userId}
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return null; // No hay perfil
      }
      if (e is DioException) {
        throw Exception('Error al obtener perfil: ${e.response?.data ?? e.message}');
      }
      throw Exception('Error al obtener perfil: ${e.toString()}');
    }
  }

  // Subir imagen de perfil
  Future<Map<String, dynamic>> uploadProfilePhoto(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      
      // ✅ USAR EL MÉTODO postMultipart DE TU ApiService
      final response = await _apiService.postMultipart('/platformprofile/upload', formData);
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Error al subir imagen: ${e.response?.data ?? e.message}');
      }
      throw Exception('Error al subir imagen: ${e.toString()}');
    }
  }

  // Eliminar perfil
  Future<void> delete(int profileId) async {
    try {
      await _apiService.delete('/platformprofile/$profileId');
    } catch (e) {
      if (e is DioException) {
        throw Exception('Error al eliminar perfil: ${e.response?.data ?? e.message}');
      }
      throw Exception('Error al eliminar perfil: ${e.toString()}');
    }
  }

  // ✅ MÉTODOS ADICIONALES QUE PODRÍAS NECESITAR

  // Obtener todos los perfiles (para admin)
  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    try {
      final response = await _apiService.get('/platformprofile');
      final data = response.data;
      
      if (data is List) {
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else if (data is Map && data['data'] is List) {
        return (data['data'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
      }
      return [];
    } catch (e) {
      if (e is DioException) {
        throw Exception('Error al obtener perfiles: ${e.response?.data ?? e.message}');
      }
      throw Exception('Error al obtener perfiles: ${e.toString()}');
    }
  }

  // Verificar si el usuario tiene perfil
  Future<bool> hasProfile(int userId) async {
    try {
      final profile = await getByUserId(userId);
      return profile != null;
    } catch (e) {
      return false;
    }
  }

  // Actualizar solo la foto de perfil
  Future<Map<String, dynamic>> updateProfilePhoto(int userId, String filePath) async {
    try {
      // Primero subir la imagen
      final uploadResult = await uploadProfilePhoto(filePath);
      final photoUrl = uploadResult['url'] ?? uploadResult['photoUrl'];
      
      if (photoUrl == null) {
        throw Exception('No se pudo obtener la URL de la imagen');
      }

      // Luego actualizar el perfil con la nueva URL
      final updateData = {'Profile_photo': photoUrl};
      return await updateByUser(userId, updateData);
    } catch (e) {
      throw Exception('Error al actualizar foto de perfil: ${e.toString()}');
    }
  }

  // Obtener perfil con validación de token
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      // Verificar si hay token
      final isAuthenticated = await _apiService.isAuthenticated();
      if (!isAuthenticated) {
        throw Exception('Usuario no autenticado');
      }

      // Obtener perfil del usuario actual (necesitarías el userId del token)
      final response = await _apiService.get('/platformprofile/current');
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      if (e is DioException) {
        throw Exception('Error al obtener perfil actual: ${e.response?.data ?? e.message}');
      }
      throw Exception('Error al obtener perfil actual: ${e.toString()}');
    }
  }

  // ✅ MÉTODO PARA BUSCAR TODOS LOS PERFILES (para debugging)
  Future<List<Map<String, dynamic>>> buscarTodosLosPerfiles() async {
    try {
      print('🔍 === BUSCANDO TODOS LOS PERFILES ===');
      
      final response = await _apiService.get('/platformprofile');
      print('🔍 Response: ${response.data}');
      
      if (response.data is List) {
        return (response.data as List).map((item) => Map<String, dynamic>.from(item)).toList();
      } else if (response.data is Map && response.data['data'] is List) {
        return (response.data['data'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error al buscar todos los perfiles: $e');
      return [];
    }
  }

  // ✅ MÉTODO PARA VERIFICAR QUÉ PERFILES EXISTEN
  Future<void> debugPerfiles() async {
    try {
      final perfiles = await buscarTodosLosPerfiles();
      print('🔍 === PERFILES EXISTENTES ===');
      for (var perfil in perfiles) {
        print('🔍 Perfil ID: ${perfil['Profile_id']}, Usuario ID: ${perfil['User_id'] ?? perfil['Platform_user_id']}, Nombre: ${perfil['Profile_name']}');
      }
    } catch (e) {
      print('❌ Error en debug: $e');
    }
  }
}