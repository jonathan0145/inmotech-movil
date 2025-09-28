# 🐌 Solución para Conexiones Lentas - API por IP

## 📱 **Problema Resuelto**
- ❌ **Antes:** Timeout de 10 segundos (muy corto para conexiones por IP/WiFi lentas)
- ✅ **Ahora:** Timeouts optimizados para conexiones lentas desde el celular

## ⏱️ **Nuevos Timeouts Configurados**

### 📋 **En `api_config.dart`:**
```dart
static const Duration connectTimeout = Duration(seconds: 30); // Conexión
static const Duration receiveTimeout = Duration(seconds: 60); // Respuesta  
static const Duration sendTimeout = Duration(seconds: 30);    // Envío
```

### 🔧 **Configuraciones Adicionales:**
- ✅ `followRedirects: true` - Sigue redirecciones automáticamente
- ✅ `maxRedirects: 5` - Máximo 5 redirecciones
- ✅ `persistentConnection: true` - Mantiene conexión activa
- ✅ **Logs detallados** para debug de conexiones

## 🚀 **Métodos Especiales para Conexiones Muy Lentas**

Si aún tienes problemas, usa estos métodos con timeouts personalizados:

```dart
// Para operaciones muy lentas (hasta 2 minutos)
final response = await ApiService.instance.getWithCustomTimeout(
  '/endpoint',
  customTimeout: Duration(minutes: 3), // Timeout personalizado
);

final response = await ApiService.instance.postWithCustomTimeout(
  '/endpoint',
  data: data,
  customTimeout: Duration(minutes: 3),
);
```

## 🔍 **Debug y Monitoreo**

Ahora verás logs detallados en consola:
```
🚀 REQUEST: POST http://192.168.20.21:3000/api/auth/login
📤 Headers: {Content-Type: application/json, Accept: application/json}
✅ RESPONSE: 200 http://192.168.20.21:3000/api/auth/login
```

En caso de errores:
```
❌ ERROR: Connection timeout
🔗 URL: http://192.168.20.21:3000/api/auth/login
📥 Response: null - null
```

## 📱 **Consejos para Mejorar Conexión Desde Celular**

### 🏠 **Red WiFi:**
1. **Verifica que el celular y PC están en la misma red**
2. **Usa IP estática en tu PC** (para evitar cambios de IP)
3. **Desactiva firewall temporalmente** para pruebas

### 🔧 **Configuración de Red:**
```bash
# En tu PC, verifica la IP actual:
ipconfig

# Asegúrate de que el servidor esté corriendo en todas las interfaces:
# En tu API, usar: 0.0.0.0:3000 en lugar de localhost:3000
```

### 📲 **En el Celular:**
1. **Conecta a la misma WiFi** que tu PC
2. **Desactiva datos móviles** durante las pruebas
3. **Acércate al router** para mejor señal

## 🎯 **Resultado Esperado**

Con estos cambios, tu app móvil debería:
- ✅ **Esperar más tiempo** antes de dar timeout
- ✅ **Mostrar logs útiles** para debug
- ✅ **Manejar conexiones lentas** sin problemas
- ✅ **Mantener conexión persistente** para mejor rendimiento

## 🆘 **Si Aún Hay Problemas**

1. **Aumenta más los timeouts** en `api_config.dart`
2. **Usa los métodos personalizados** con timeouts de 3-5 minutos
3. **Verifica que la API responde** desde browser: `http://192.168.20.21:3000/api`
4. **Considera usar ngrok** para túnel público temporal

¡Ahora tu app móvil debería conectarse sin problemas de timeout! 🎉