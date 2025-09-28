import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/auth_service.dart';
import '../../utils/auth_validators.dart';
import '../../config/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Estados de validación en tiempo real
  bool _isValidatingUsername = false;
  bool _isValidatingEmail = false;
  bool _usernameAvailable = false;
  bool _emailAvailable = false;
  bool _usernameChecked = false;
  bool _emailChecked = false;
  
  Timer? _usernameDebouncer;
  Timer? _emailDebouncer;

  @override
  void initState() {
    super.initState();
    _usuarioController.addListener(_onUsernameChanged);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray, // Usando el color correcto
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Registro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo o título
                        const Icon(
                          Icons.person_add,
                          size: 80,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(height: 24),
                        
                        const Text(
                          'Crear Cuenta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGray,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Campo Usuario
                        _buildUsernameField(),
                        const SizedBox(height: 16),

                        // Campo Email
                        _buildEmailField(),
                        const SizedBox(height: 16),

                        // Campo Contraseña
                        _buildPasswordField(),
                        const SizedBox(height: 16),

                        // Campo Confirmar Contraseña
                        _buildConfirmPasswordField(),
                        const SizedBox(height: 24),

                        // Botón Registro
                        ElevatedButton(
                          onPressed: _canRegister() ? _register : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),

                        // Link a login
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(color: Colors.black87),
                              children: [
                                TextSpan(text: '¿Ya tienes cuenta? '),
                                TextSpan(
                                  text: 'Inicia Sesión',
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usuarioController,
      decoration: InputDecoration(
        labelText: 'Usuario',
        prefixIcon: const Icon(Icons.person),
        suffixIcon: _buildValidationIcon(_isValidatingUsername, _usernameAvailable, _usernameChecked),
        border: const OutlineInputBorder(),
        helperText: 'Entre 3 y 20 caracteres, solo letras, números y _',
        helperMaxLines: 2,
      ),
      validator: AuthValidators.validateUsername,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Correo Electrónico',
        prefixIcon: const Icon(Icons.email),
        suffixIcon: _buildValidationIcon(_isValidatingEmail, _emailAvailable, _emailChecked),
        border: const OutlineInputBorder(),
        helperText: 'No se permiten correos temporales',
        helperMaxLines: 2,
      ),
      validator: AuthValidators.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: const OutlineInputBorder(),
        helperText: 'Mínimo 8 caracteres, incluir mayúscula, minúscula y número',
        helperMaxLines: 3,
      ),
      validator: AuthValidators.validatePassword,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirmar Contraseña',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) => AuthValidators.validateConfirmPassword(value, _passwordController.text),
    );
  }

  Widget? _buildValidationIcon(bool isValidating, bool isAvailable, bool isChecked) {
    if (isValidating) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (isChecked) {
      return Icon(
        isAvailable ? Icons.check_circle : Icons.cancel,
        color: isAvailable ? Colors.green : Colors.red,
      );
    }
    return null;
  }

  void _onUsernameChanged() {
    _usernameDebouncer?.cancel();
    _usernameDebouncer = Timer(const Duration(milliseconds: 500), () {
      _checkUsernameAvailability();
    });
  }

  void _onEmailChanged() {
    _emailDebouncer?.cancel();
    _emailDebouncer = Timer(const Duration(milliseconds: 500), () {
      _checkEmailAvailability();
    });
  }

  Future<void> _checkUsernameAvailability() async {
    final username = _usuarioController.text;
    if (username.length < 3) return;

    setState(() {
      _isValidatingUsername = true;
      _usernameChecked = false;
    });

    try {
      final response = await _authService.checkUsernameAvailability(username);
      setState(() {
        _usernameAvailable = response['available'] ?? false;
        _usernameChecked = true;
        _isValidatingUsername = false;
      });
    } catch (e) {
      setState(() {
        _usernameAvailable = false;
        _usernameChecked = true;
        _isValidatingUsername = false;
      });
    }
  }

  Future<void> _checkEmailAvailability() async {
    final email = _emailController.text;
    if (!email.contains('@')) return;

    setState(() {
      _isValidatingEmail = true;
      _emailChecked = false;
    });

    try {
      final response = await _authService.checkEmailAvailability(email);
      setState(() {
        _emailAvailable = response['available'] ?? false;
        _emailChecked = true;
        _isValidatingEmail = false;
      });
    } catch (e) {
      setState(() {
        _emailAvailable = false;
        _emailChecked = true;
        _isValidatingEmail = false;
      });
    }
  }

  bool _canRegister() {
    return !_isLoading && 
           _usernameAvailable && 
           _emailAvailable && 
           _usernameChecked && 
           _emailChecked;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_canRegister()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _authService.register(
        _usuarioController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (response['success'] == true) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(response['message'] ?? 'Error al registrar usuario');
      }
    } catch (e) {
      _showErrorDialog('Error de conexión: ${e.toString()}');
    }

    setState(() => _isLoading = false);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Registro Exitoso!'),
        content: const Text('Tu cuenta ha sido creada correctamente. Ahora puedes iniciar sesión.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Volver al login
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameDebouncer?.cancel();
    _emailDebouncer?.cancel();
    _usuarioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}