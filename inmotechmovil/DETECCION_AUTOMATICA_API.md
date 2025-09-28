# 🚀 Detección Automática de API - Inmotech Móvil

## ✅ ¿Cómo funciona?

Tu app móvil ahora **detecta automáticamente** qué modo de tu API está corriendo:

### 🔧 **Modo Desarrollo** (`npm run dev`)
- API corriendo en: `http://localhost:3000`
- La app se conecta automáticamente a localhost
- Indicador: 🔧 **Desarrollo ✓**

### 🌐 **Modo Producción** (`npm start`)  
- API corriendo en: `http://192.168.20.21:3000`
- La app se conecta automáticamente a la IP de red
- Indicador: 🌐 **Producción ✓**

## 📱 **Indicador Visual**

En la parte superior derecha de tu app verás:

- **🔧 Desarrollo ✓** - Conectado a localhost (npm run dev)
- **🌐 Producción ✓** - Conectado a red local (npm start)  
- **❌ Sin conexión** - No hay API disponible

## 🔄 **Reconexión Automática**

- La app verifica la conexión antes de cada petición
- Si cambias de `npm run dev` a `npm start`, la app se reconecta automáticamente
- Toca el indicador de conexión para verificar manualmente

## 🛠️ **Para desarrolladores**

### **Flujo de trabajo:**

1. **Desarrollo en PC:**
   ```bash
   npm run dev
   ```
   Tu app móvil se conectará automáticamente a localhost

2. **Pruebas desde móvil:**
   ```bash
   npm start  
   ```
   Tu app móvil se conectará automáticamente a la IP de red

3. **Sin interrupciones:** La app cambia automáticamente entre URLs

### **Configuración interna:**

```dart
// URLs configuradas automáticamente
devBaseUrl: 'http://localhost:3000/api'      // npm run dev
prodBaseUrl: 'http://192.168.20.21:3000/api' // npm start
```

## ⚡ **Ventajas**

✅ **Sin configuración manual** - La app detecta automáticamente el servidor  
✅ **Indicador visual** - Siempre sabes a qué servidor estás conectado  
✅ **Reconexión automática** - Cambia entre modos sin reiniciar la app  
✅ **Timeouts optimizados** - 30 segundos para conexiones lentas  
✅ **Fallback inteligente** - Si falla localhost, prueba con IP de red

## 🔍 **Troubleshooting**

**Si aparece "Sin conexión":**

1. Verifica que tu API esté corriendo: `npm run dev` o `npm start`
2. Toca el indicador de conexión para verificar manualmente
3. Asegúrate que tu móvil esté en la misma red WiFi (para modo producción)

**Para verificar la API manualmente:**
- Desarrollo: http://localhost:3000/api/test
- Producción: http://192.168.20.21:3000/api/test