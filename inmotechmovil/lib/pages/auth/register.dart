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
  
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _isValidating = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  String? _successMessage;
  
  // Estados de validación en tiempo real
  bool? _usuarioDisponible;
  bool? _correoDisponible;
  bool _usuarioChecking = false;
  bool _correoChecking = false;
  
  Timer? _usuarioDebounceTimer;
  Timer? _correoDebounceTimer;

  @override
  void dispose() {
    _usuarioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usuarioDebounceTimer?.cancel();
    _correoDebounceTimer?.cancel();
    super.dispose();
  }

  void _checkUsuarioDisponible(String usuario) {
    if (usuario.length < 3) {
      setState(() {
        _usuarioDisponible = null;
        _usuarioChecking = false;
      });
      return;
    }

    if (!AuthValidators.isValidUsuarioFormat(usuario)) {
      setState(() {
        _usuarioDisponible = null;
        _usuarioChecking = false;
      });
      return;
    }

    setState(() {
      _usuarioChecking = true;
    });

    _usuarioDebounceTimer?.cancel();
    _usuarioDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final disponible = await _authService.checkUsuarioDisponible(usuario);
        if (mounted) {
          setState(() {
            _usuarioDisponible = disponible;
            _usuarioChecking = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _usuarioDisponible = null;
            _usuarioChecking = false;
          });
        }
      }
    });
  }

  void _checkCorreoDisponible(String correo) {
    if (correo.length < 5) {
      setState(() {
        _correoDisponible = null;
        _correoChecking = false;
      });
      return;
    }

    if (!AuthValidators.isValidEmailFormat(correo)) {
      setState(() {
        _correoDisponible = null;
        _correoChecking = false;
      });
      return;
    }

    setState(() {
      _correoChecking = true;
    });

    _correoDebounceTimer?.cancel();
    _correoDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final disponible = await _authService.checkCorreoDisponible(correo);
        if (mounted) {
          setState(() {
            _correoDisponible = disponible;
            _correoChecking = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _correoDisponible = null;
            _correoChecking = false;
          });
        }
      }
    });
  }

  Future<bool> _validarRegistro() async {
    // Validación de usuario
    if (_usuarioDisponible == false) {
      setState(() {
        _errorMessage = 'El usuario ya está registrado.';
      });
      return false;
    }

    // Validación de correo
    if (_correoDisponible == false) {
      setState(() {
        _errorMessage = 'El correo ya está registrado.';
      });
      return false;
    }

    // Otras validaciones ya están manejadas por los validators de los campos
    setState(() {
      _errorMessage = null;
    });
    return true;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isValidating = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final valido = await _validarRegistro();
    setState(() {
      _isValidating = false;
    });

    if (!valido) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.register(
        _usuarioController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _successMessage = 'Registro exitoso. Por favor inicia sesión.';
        _errorMessage = null;
      });

      // Navegar al login después de un delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });

    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _successMessage = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground, // Color gris-azulado de la imagen
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
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
                    children: [
                      // Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/icon.png',
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.home,
                                size: 40,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Título
                      Text(
                        'Registro',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Text(
                        'Crea tu cuenta para comenzar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Mensajes de error/éxito
                      if (_errorMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            border: Border.all(color: Colors.red[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[700]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (_successMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline, color: Colors.green[700]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _successMessage!,
                                  style: TextStyle(color: Colors.green[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Campo Usuario
                      TextFormField(
                        controller: _usuarioController,
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          hintText: 'Ingresa tu usuario',
                          prefixIcon: const Icon(Icons.person_outline),
                          suffixIcon: _usuarioChecking
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  padding: const EdgeInsets.all(12),
                                  child: const CircularProgressIndicator(strokeWidth: 2),
                                )
                              : _usuarioDisponible == true
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : _usuarioDisponible == false
                                      ? const Icon(Icons.error, color: Colors.red)
                                      : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _usuarioDisponible == false 
                                  ? Colors.red 
                                  : _usuarioDisponible == true 
                                      ? Colors.green 
                                      : Colors.grey[300]!
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          _checkUsuarioDisponible(value);
                        },
                        validator: (value) => AuthValidators.validateUsuario(value ?? ''),
                      ),
                      if (_usuarioDisponible == false || (_usuarioController.text.isNotEmpty && !AuthValidators.isValidUsuarioFormat(_usuarioController.text))) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          child: Text(
                            _usuarioDisponible == false 
                                ? 'El usuario ya está registrado.'
                                : 'Solo letras, números y guion bajo. 3-20 caracteres.',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Campo Correo
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo',
                          hintText: 'Ingresa tu correo',
                          prefixIcon: const Icon(Icons.email_outlined),
                          suffixIcon: _correoChecking
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  padding: const EdgeInsets.all(12),
                                  child: const CircularProgressIndicator(strokeWidth: 2),
                                )
                              : _correoDisponible == true
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : _correoDisponible == false
                                      ? const Icon(Icons.error, color: Colors.red)
                                      : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _correoDisponible == false 
                                  ? Colors.red 
                                  : _correoDisponible == true 
                                      ? Colors.green 
                                      : Colors.grey[300]!
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          _checkCorreoDisponible(value);
                        },
                        validator: (value) => AuthValidators.validateEmail(value ?? ''),
                      ),
                      if (_correoDisponible == false || (_emailController.text.isNotEmpty && !AuthValidators.isValidEmailFormat(_emailController.text))) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          child: Text(
                            _correoDisponible == false 
                                ? 'El correo ya está registrado.'
                                : 'Ingresa un correo válido.',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Campo Contraseña
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          hintText: 'Ingresa tu contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleRegister(),
                        validator: (value) => AuthValidators.validatePassword(value ?? '', isRegistration: true),
                      ),
                      if (_passwordController.text.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          child: Text(
                            AuthValidators.getPasswordRequirements(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),

                      // Botón de Registro
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (_isLoading || _isValidating) ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: (_isLoading || _isValidating)
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  _isValidating ? 'Validando...' : 'Registrarse',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'o',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Botón de Login
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: RichText(
                          text: TextSpan(
                            text: '¿Ya tienes cuenta? ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Inicia sesión',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
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
    );
  }
}