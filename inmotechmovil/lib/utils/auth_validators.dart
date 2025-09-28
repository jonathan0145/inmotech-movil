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

  // Validar nombre de usuario
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'El usuario es requerido';
    }
    
    if (value.length < 3) {
      return 'El usuario debe tener al menos 3 caracteres';
    }
    
    if (value.length > 20) {
      return 'El usuario no puede tener más de 20 caracteres';
    }
    
    // Solo letras, números y guión bajo
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Solo se permiten letras, números y guión bajo (_)';
    }
    
    return null;
  }
  
  // Validar email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    
    // Expresión regular para validar email
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    
    // Lista de proveedores de correo temporal (opcional)
    final tempEmailProviders = [
      '10minutemail.com',
      'tempmail.org',
      'guerrillamail.com',
      'mailinator.com',
      'throwaway.email'
    ];
    
    final domain = value.split('@').last.toLowerCase();
    if (tempEmailProviders.contains(domain)) {
      return 'No se permiten correos temporales';
    }
    
    return null;
  }
  
  // Validar contraseña
  static String? validatePassword(String? value, {bool isRegistration = true}) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (!isRegistration) {
      // Para login, solo verificar que no esté vacía
      return null;
    }
    
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    
    // Verificar que tenga al menos una letra minúscula
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Debe contener al menos una letra minúscula';
    }
    
    // Verificar que tenga al menos una letra mayúscula
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Debe contener al menos una letra mayúscula';
    }
    
    // Verificar que tenga al menos un número
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Debe contener al menos un número';
    }
    
    return null;
  }
  
  // Validar confirmación de contraseña
  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Debes confirmar tu contraseña';
    }
    
    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }
  
  // Validar nombre completo
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre completo es requerido';
    }
    
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    if (value.length > 50) {
      return 'El nombre no puede tener más de 50 caracteres';
    }
    
    // Solo letras y espacios
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$').hasMatch(value)) {
      return 'Solo se permiten letras y espacios';
    }
    
    return null;
  }
  
  // Validar teléfono
  static String? validatePhone(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'El teléfono es requerido' : null;
    }
    
    // Remover espacios y guiones
    final cleanPhone = value.replaceAll(RegExp(r'[\s-]'), '');
    
    if (cleanPhone.length < 10 || cleanPhone.length > 15) {
      return 'El teléfono debe tener entre 10 y 15 dígitos';
    }
    
    // Solo números y caracteres permitidos
    if (!RegExp(r'^[\+]?[0-9]+$').hasMatch(cleanPhone)) {
      return 'Formato de teléfono inválido';
    }
    
    return null;
  }
}