import '../services/api_service.dart';
import 'package:dio/dio.dart';

class InmuebleService {
  final ApiService _apiService = ApiService();

  // ✅ OBTENER TODOS LOS INMUEBLES (para home)
  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      print('🏠 Obteniendo todos los inmuebles...');
      
      final response = await _apiService.get('/inmuebles');
      
      print('🏠 Response status: ${response.statusCode}');
      print('🏠 Response data type: ${response.data.runtimeType}');
      
      if (response.data is List) {
        final List<dynamic> inmuebles = response.data;
        return inmuebles.map((inmueble) => Map<String, dynamic>.from(inmueble)).toList();
      } else if (response.data is Map && response.data['data'] != null) {
        final List<dynamic> inmuebles = response.data['data'];
        return inmuebles.map((inmueble) => Map<String, dynamic>.from(inmueble)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error al obtener todos los inmuebles: $e');
      throw Exception('Error al obtener inmuebles: ${e.toString()}');
    }
  }

  // ✅ OBTENER INMUEBLES POR USUARIO ID (para publicados)
  Future<List<Map<String, dynamic>>> getInmueblesByUserId(int userId) async {
    try {
      print('🏠 === LLAMANDO ENDPOINT POR USER ID ===');
      print('🏠 URL que se va a llamar: /inmuebles/usuario/$userId');
      print('🏠 UserId enviado: $userId');
      
      final response = await _apiService.get('/inmuebles/usuario/$userId');
      
      print('🏠 === RESPUESTA DEL SERVIDOR ===');
      print('🏠 Status Code: ${response.statusCode}');
      print('🏠 Response completa: ${response.data}');
      
      if (response.data is Map) {
        print('🏠 success: ${response.data['success']}');
        print('🏠 user_id: ${response.data['user_id']}');
        print('🏠 count: ${response.data['count']}');
        print('🏠 message: ${response.data['message']}');
        
        if (response.data['data'] != null) {
          final List<dynamic> inmuebles = response.data['data'];
          print('🏠 Cantidad de inmuebles devueltos: ${inmuebles.length}');
          
          // Verificar que todos los inmuebles pertenezcan al usuario
          for (int i = 0; i < inmuebles.length; i++) {
            final inmueble = inmuebles[i];
            final inmuebleUserId = inmueble['Platform_user_FK'];
            print('🏠 Inmueble $i: Platform_user_FK = $inmuebleUserId (esperado: $userId)');
            
            if (inmuebleUserId.toString() != userId.toString()) {
              print('❌ ERROR: Inmueble no pertenece al usuario correcto!');
            }
          }
          
          return inmuebles.map((inmueble) => Map<String, dynamic>.from(inmueble)).toList();
        }
      }
      
      print('🏠 No se encontraron inmuebles o respuesta inválida');
      return [];
    } catch (e) {
      print('❌ Error en getInmueblesByUserId: $e');
      if (e is DioException) {
        print('❌ URL completa llamada: ${e.requestOptions.uri}');
        print('❌ Method: ${e.requestOptions.method}');
        print('❌ Response status: ${e.response?.statusCode}');
        print('❌ Response data: ${e.response?.data}');
      }
      throw Exception('Error al obtener inmuebles: ${e.toString()}');
    }
  }

  // ✅ OBTENER INMUEBLE POR ID (para detalle)
  Future<Map<String, dynamic>?> getById(int inmuebleId) async {
    try {
      print('🏠 Obteniendo inmueble por ID: $inmuebleId');
      
      final response = await _apiService.get('/inmuebles/$inmuebleId');
      
      print('🏠 Response status: ${response.statusCode}');
      
      if (response.data != null) {
        return Map<String, dynamic>.from(response.data);
      }
      
      return null;
    } catch (e) {
      print('❌ Error al obtener inmueble por ID: $e');
      throw Exception('Error al obtener inmueble: ${e.toString()}');
    }
  }

  // ✅ AGREGAR ESTOS MÉTODOS AL FINAL
  // FAVORITOS - igual al servicio web
  Future<List<Map<String, dynamic>>> getFavoritosByUserId(int userId) async {
    try {
      print('❤️ Obteniendo favoritos del usuario: $userId');
      
      final response = await _apiService.get('/favoritos/usuario/$userId');
      
      print('❤️ Response status: ${response.statusCode}');
      print('❤️ Response data: ${response.data}');
      
      if (response.data is Map && response.data['data'] != null) {
        final List<dynamic> favoritos = response.data['data'];
        return favoritos.map((favorito) => Map<String, dynamic>.from(favorito)).toList();
      } else if (response.data is List) {
        final List<dynamic> favoritos = response.data;
        return favoritos.map((favorito) => Map<String, dynamic>.from(favorito)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error al obtener favoritos: $e');
      throw Exception('Error al obtener favoritos: ${e.toString()}');
    }
  }

  Future<bool> esFavorito(int userId, int inmuebleId) async {
    try {
      final response = await _apiService.get('/favoritos/usuario/$userId/inmueble/$inmuebleId');
      
      if (response.data is Map) {
        return response.data['es_favorito'] ?? false;
      }
      
      return false;
    } catch (e) {
      print('❌ Error al verificar favorito: $e');
      return false;
    }
  }

  Future<bool> toggleFavorito(int userId, int inmuebleId) async {
    try {
      print('❤️ Toggle favorito: userId=$userId, inmuebleId=$inmuebleId');
      
      // ✅ USAR PUT IGUAL AL SERVICIO WEB
      final response = await _apiService.put('/favoritos/usuario/$userId/inmueble/$inmuebleId/toggle');
      
      if (response.data is Map) {
        return response.data['es_favorito'] ?? false;
      }
      
      return false;
    } catch (e) {
      print('❌ Error al cambiar favorito: $e');
      throw Exception('Error al cambiar favorito: ${e.toString()}');
    }
  }

  // ✅ CREAR INMUEBLE (corregir parámetros)
  Future<Map<String, dynamic>> createInmueble(Map<String, dynamic> inmuebleData) async {
    try {
      print('🏠 Creando inmueble...');
      
      // ✅ USAR SOLO UN PARÁMETRO si ApiService.post() solo acepta uno
      // Opción 1: Si post acepta (url, data)
      final response = await _apiService.post('/inmuebles/anidado');
      
      // Opción 2: Si necesitas enviar data, puede que tengas que usar el dio directamente
      // final response = await _apiService.dio.post('/inmuebles/anidado', data: inmuebleData);
      
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print('❌ Error al crear inmueble: $e');
      throw Exception('Error al crear inmueble: ${e.toString()}');
    }
  }

  // ✅ ACTUALIZAR INMUEBLE (corregir parámetros)
  Future<Map<String, dynamic>> updateInmueble(int inmuebleId, Map<String, dynamic> inmuebleData) async {
    try {
      print('🏠 Actualizando inmueble: $inmuebleId');
      
      // ✅ USAR SOLO UN PARÁMETRO
      final response = await _apiService.put('/inmuebles/anidado/$inmuebleId');
      
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print('❌ Error al actualizar inmueble: $e');
      throw Exception('Error al actualizar inmueble: ${e.toString()}');
    }
  }

  // ✅ ELIMINAR INMUEBLE (corregir si es necesario)
  Future<void> deleteInmueble(int inmuebleId) async {
    try {
      print('🏠 Eliminando inmueble: $inmuebleId');
      
      await _apiService.delete('/inmuebles/anidado/$inmuebleId');
      
      print('✅ Inmueble eliminado exitosamente');
    } catch (e) {
      print('❌ Error al eliminar inmueble: $e');
      throw Exception('Error al eliminar inmueble: ${e.toString()}');
    }
  }

  // ✅ SUBIR IMAGEN (corregir parámetros)
  Future<Map<String, dynamic>> uploadImage(String filePath) async {
    try {
      print('📸 Subiendo imagen: $filePath');
      
      final formData = FormData.fromMap({
        'imagen': await MultipartFile.fromFile(filePath),
      });
      
      // ✅ USAR SOLO UN PARÁMETRO
      final response = await _apiService.post('/inmuebles/upload-imagen');
      
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print('❌ Error al subir imagen: $e');
      throw Exception('Error al subir imagen: ${e.toString()}');
    }
  }

  // ✅ CONTAR INMUEBLES DEL USUARIO
  Future<int> getInmueblesCountByUserId(int userId) async {
    try {
      final response = await _apiService.get('/inmuebles/usuario/$userId');
      
      if (response.data is Map && response.data['success'] == true) {
        return response.data['count'] ?? 0;
      }
      
      return 0;
    } catch (e) {
      print('❌ Error al contar inmuebles: $e');
      return 0;
    }
  }

  // NUEVO MÉTODO: OBTENER INFORMACIÓN COMPLETA DEL INMUEBLE
  Future<Map<String, dynamic>> getCompleto(int id) async {
    try {
      print('🔍 Obteniendo información completa del inmueble: $id');
      
      final response = await _apiService.get('/inmueble/completo/$id');
      
      print('📡 Status getCompleto: ${response.statusCode}');
      print('📄 Data getCompleto: ${response.data}');
      
      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Error obteniendo información completa del inmueble');
      }
    } catch (e) {
      print('❌ Error en getCompleto: $e');
      throw Exception('Error obteniendo información completa: ${e.toString()}');
    }
  }
}