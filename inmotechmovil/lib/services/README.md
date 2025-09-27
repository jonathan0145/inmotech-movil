# Servicios API - Inmotech Mobile

Este documento explica cómo utilizar los servicios API creados para conectar tu aplicación Flutter con el backend de Inmotech.

## 📁 Estructura de Servicios

```
lib/services/
├── api_service.dart          # Servicio base para configuración HTTP
├── auth_service.dart         # Autenticación y gestión de usuarios
├── inmueble_service.dart     # Gestión de inmuebles
├── profile_service.dart      # Gestión de perfiles de usuario
├── content_service.dart      # Contenido (políticas, FAQ, etc.)
├── visualization_service.dart # Estadísticas y visualizaciones
├── user_service.dart         # Gestión de usuarios de plataforma
└── services.dart            # Exportaciones centralizadas
```

## ⚙️ Configuración Inicial

### 1. Instalar Dependencias

Ejecuta el siguiente comando en tu terminal:

```bash
flutter pub get
```

### 2. Configurar URL de la API

Edita el archivo `lib/config/api_config.dart` y cambia las URLs por las de tu servidor:

```dart
static const String devBaseUrl = 'http://tu-servidor-local:3000/api';
static const String prodBaseUrl = 'https://tu-api-produccion.com/api';
```

### 3. Configurar Entorno

En `api_config.dart`, cambia `isProduction` según tu entorno:

```dart
static const bool isProduction = false; // false para desarrollo, true para producción
```

## 🚀 Ejemplos de Uso

### Autenticación

```dart
import 'package:inmotechmovil/services/services.dart';

class LoginExample {
  final AuthService _authService = AuthService();

  Future<void> login(String username, String password) async {
    try {
      final response = await _authService.login(username, password);
      print('Login exitoso: ${response['user']}');
      // Navegar a la pantalla principal
    } catch (e) {
      print('Error de login: $e');
      // Mostrar error al usuario
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    // Navegar a la pantalla de login
  }
}
```

### Gestión de Inmuebles

```dart
import 'package:inmotechmovil/services/services.dart';
import 'package:inmotechmovil/models/inmueble.dart';

class InmuebleExample {
  final InmuebleService _inmuebleService = InmuebleService();

  // Cargar todos los inmuebles
  Future<List<Inmueble>> loadInmuebles() async {
    try {
      final response = await _inmuebleService.getAllInmuebles();
      return response.map((json) => Inmueble.fromJson(json)).toList();
    } catch (e) {
      print('Error cargando inmuebles: $e');
      return [];
    }
  }

  // Buscar inmuebles
  Future<List<Inmueble>> searchInmuebles(String query) async {
    try {
      final response = await _inmuebleService.searchInmuebles(
        query: query,
        habitaciones: 3, // opcional
        minPrice: 100000, // opcional
      );
      return response.map((json) => Inmueble.fromJson(json)).toList();
    } catch (e) {
      print('Error buscando inmuebles: $e');
      return [];
    }
  }

  // Obtener detalle de inmueble
  Future<Inmueble?> getInmuebleDetail(int id) async {
    try {
      final response = await _inmuebleService.getInmuebleById(id);
      return Inmueble.fromJson(response);
    } catch (e) {
      print('Error obteniendo detalle: $e');
      return null;
    }
  }
}
```

### Gestión de Perfil

```dart
import 'package:inmotechmovil/services/services.dart';

class ProfileExample {
  final ProfileService _profileService = ProfileService();

  Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    try {
      return await _profileService.getProfileByUserId(userId);
    } catch (e) {
      print('Error obteniendo perfil: $e');
      return null;
    }
  }

  Future<void> updateProfile(int userId, Map<String, dynamic> data) async {
    try {
      await _profileService.updateProfileByUser(userId, data);
      print('Perfil actualizado exitosamente');
    } catch (e) {
      print('Error actualizando perfil: $e');
    }
  }
}
```

### Contenido de la App

```dart
import 'package:inmotechmovil/services/services.dart';

class ContentExample {
  final ContentService _contentService = ContentService();

  Future<List<Map<String, dynamic>>> loadFAQs() async {
    try {
      return await _contentService.getAllPreguntas();
    } catch (e) {
      print('Error cargando FAQs: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> loadCarousel() async {
    try {
      return await _contentService.getAllCarrusel();
    } catch (e) {
      print('Error cargando carrusel: $e');
      return [];
    }
  }
}
```

## 📊 Registro de Visualizaciones

Para registrar cuando un usuario ve un inmueble:

```dart
import 'package:inmotechmovil/services/services.dart';

class VisualizationExample {
  final VisualizationService _visualizationService = VisualizationService();

  Future<void> registerView(int inmuebleId) async {
    try {
      await _visualizationService.registerInmuebleView(
        inmuebleId,
        deviceType: 'mobile',
        location: 'app',
      );
    } catch (e) {
      // Error silencioso - no afecta la experiencia del usuario
      print('Error registrando visualización: $e');
    }
  }
}
```

## 🔧 Manejo de Errores

Todos los servicios incluyen manejo de errores. Los tipos comunes de error son:

- **Tiempo de conexión agotado**: Problemas de red
- **401 No autorizado**: Token expirado o inválido
- **404 No encontrado**: Recurso no existe
- **500 Error del servidor**: Problema en el backend

Ejemplo de manejo de errores en un widget:

```dart
Future<void> loadData() async {
  setState(() {
    _isLoading = true;
    _error = null;
  });

  try {
    final data = await _inmuebleService.getAllInmuebles();
    setState(() {
      _inmuebles = data.map((json) => Inmueble.fromJson(json)).toList();
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _error = e.toString();
      _isLoading = false;
    });
    
    // Mostrar snackbar o diálogo de error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

## 🔐 Gestión de Tokens

Los tokens se manejan automáticamente:

- Se guardan en SharedPreferences al hacer login
- Se incluyen automáticamente en las peticiones
- Se eliminan al hacer logout
- Se limpian automáticamente si el servidor responde 401

## 📱 Página de Ejemplo

Revisa `lib/pages/inmuebles_example_page.dart` para ver un ejemplo completo de cómo usar los servicios en una página real.

## 🚀 Próximos Pasos

1. Configura la URL de tu API en `api_config.dart`
2. Ejecuta `flutter pub get` para instalar dependencias
3. Prueba los servicios con datos de tu API
4. Integra los servicios en tus páginas existentes
5. Personaliza el manejo de errores según tus necesidades

¡Ya tienes todo listo para conectar tu app móvil con tu API de Inmotech! 🎉