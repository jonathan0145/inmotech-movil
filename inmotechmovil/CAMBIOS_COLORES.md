# 🎨 Actualización de Colores - Fondo de Autenticación

He actualizado el fondo de las páginas de autenticación con el color gris-azulado que me proporcionaste.

## ✅ **Cambios Realizados**

### 📁 **Nuevo archivo de colores**
**`lib/config/app_colors.dart`**
- ✅ Color principal de fondo: `Color(0xFF6B8CAE)` (gris-azulado)
- ✅ Paleta completa de colores para toda la app
- ✅ Colores organizados por categorías (texto, estado, superficies, etc.)

### 🔄 **Páginas actualizadas**

1. **`LoginPage`** - Fondo cambiado de blanco a gris-azulado
2. **`RegisterPage`** - Fondo cambiado de blanco a gris-azulado  
3. **`LoadingPage`** - Fondo cambiado + CircularProgressIndicator en blanco

### 🎯 **Color específico usado**
```dart
static const Color primaryBackground = Color(0xFF6B8CAE);
```

Este color es un **gris-azulado suave** que:
- ✅ Proporciona un contraste elegante con las cards blancas
- ✅ Es amigable para los ojos
- ✅ Da una apariencia moderna y profesional

## 🚀 **Cómo usar los colores**

En cualquier página puedes usar:

```dart
import '../../config/app_colors.dart';

Scaffold(
  backgroundColor: AppColors.primaryBackground, // Fondo principal
  body: Card(
    color: AppColors.cardBackground, // Fondo de cards
    child: Text(
      'Mi texto',
      style: TextStyle(color: AppColors.textPrimary),
    ),
  ),
)
```

## 🎨 **Paleta completa disponible**

- **Fondos:** `primaryBackground`, `cardBackground`, `surfaceColor`
- **Textos:** `textPrimary`, `textSecondary`, `textLight`
- **Estados:** `success`, `error`, `warning`, `info`
- **Acentos:** `primary`, `accent`
- **Bordes:** `borderLight`, `borderDark`

## 📱 **Resultado Visual**

Ahora tus páginas de autenticación tienen:
- ✅ Fondo gris-azulado elegante
- ✅ Cards blancos que resaltan sobre el fondo
- ✅ Indicadores de carga en blanco (visibles en el fondo)
- ✅ Colores consistentes en toda la aplicación

¡El cambio está listo y la aplicación se ve mucho más profesional! 🎉