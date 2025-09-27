class AuthValidators {
  // Dominios de correo temporal no permitidos
  static const List<String> tempDomains = [
    'mailinator.com',
    'tempmail.com',
    '10minutemail.com',
    'guerrillamail.com',
    'yopmail.com'
  ];

  // Regex para validaciones (igual que en AuthForm.jsx)
  static final RegExp usuarioRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  static final RegExp emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d\S]{8,}$');

  // Validar usuario
  static String? validateUsuario(String usuario) {
    if (usuario.isEmpty) {
      return 'El usuario es requerido';
    }
    if (!usuarioRegex.hasMatch(usuario)) {
      return 'El usuario debe tener entre 3 y 20 caracteres y solo puede contener letras, números y guiones bajos.';
    }
    return null;
  }

  // Validar email
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'El correo es requerido';
    }
    if (!emailRegex.hasMatch(email)) {
      return 'El correo electrónico no tiene un formato válido.';
    }
    
    // Verificar si es un dominio temporal
    final domain = email.split('@').length > 1 ? email.split('@')[1] : '';
    if (tempDomains.contains(domain.toLowerCase())) {
      return 'No se permiten correos temporales.';
    }
    
    return null;
  }

  // Validar contraseña
  static String? validatePassword(String password, {bool isRegistration = false}) {
    if (password.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (isRegistration) {
      if (password.length < 8) {
        return 'La contraseña debe tener al menos 8 caracteres.';
      }
      if (!passwordRegex.hasMatch(password)) {
        return 'La contraseña debe contener al menos una mayúscula, una minúscula y un número, y no debe tener espacios.';
      }
      if (password.contains(' ')) {
        return 'La contraseña no debe contener espacios.';
      }
    }
    
    return null;
  }

  // Obtener descripción de requisitos de contraseña
  static String getPasswordRequirements() {
    return 'Mínimo 8 caracteres, mayúscula, minúscula y número. Sin espacios.';
  }

  // Verificar si el usuario cumple con el formato básico
  static bool isValidUsuarioFormat(String usuario) {
    return usuarioRegex.hasMatch(usuario);
  }

  // Verificar si el email cumple con el formato básico
  static bool isValidEmailFormat(String email) {
    return emailRegex.hasMatch(email);
  }
}