import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/perfil.dart';
import '../services/perfil_service.dart';

class CrearPerfilForm extends StatefulWidget {
  final int userId;
  final Perfil? perfil;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const CrearPerfilForm({
    Key? key,
    required this.userId,
    this.perfil,
    required this.onSuccess,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<CrearPerfilForm> createState() => _CrearPerfilFormState();
}

class _CrearPerfilFormState extends State<CrearPerfilForm> {
  final _formKey = GlobalKey<FormState>();
  final PerfilService _perfilService = PerfilService();
  
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _telefonoController;
  late TextEditingController _direccionController;
  late TextEditingController _emailController;
  late TextEditingController _documentoController;
  late TextEditingController _biografiaController;
  late TextEditingController _websiteController;
  late TextEditingController _socialController;
  
  String? _genero;
  DateTime? _fechaNacimiento;
  File? _imagenSeleccionada;
  String? _urlImagenActual;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final perfil = widget.perfil;
    _nombreController = TextEditingController(text: perfil?.profileName ?? '');
    _apellidoController = TextEditingController(text: perfil?.profileLastname ?? '');
    _telefonoController = TextEditingController(text: perfil?.profilePhone ?? '');
    _direccionController = TextEditingController(text: perfil?.profileAddress ?? '');
    _emailController = TextEditingController(text: perfil?.profileEmail ?? '');
    _documentoController = TextEditingController(text: perfil?.profileNationalId ?? '');
    _biografiaController = TextEditingController(text: perfil?.profileBio ?? '');
    _websiteController = TextEditingController(text: perfil?.profileWebsite ?? '');
    _socialController = TextEditingController(text: perfil?.profileSocial ?? '');
    
    _genero = perfil?.profileGender;
    _urlImagenActual = perfil?.profilePhoto;
    
    if (perfil?.profileBirthdate != null) {
      try {
        _fechaNacimiento = DateTime.parse(perfil!.profileBirthdate!);
      } catch (e) {
        _fechaNacimiento = null;
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _emailController.dispose();
    _documentoController.dispose();
    _biografiaController.dispose();
    _websiteController.dispose();
    _socialController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imagenSeleccionada = File(image.path);
      });
    }
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (fecha != null) {
      setState(() {
        _fechaNacimiento = fecha;
      });
    }
  }

  Future<void> _guardarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      String? urlImagen = _urlImagenActual;
      
      // Subir imagen si se seleccionó una nueva
      if (_imagenSeleccionada != null) {
        final resultadoImagen = await _perfilService.uploadProfilePhoto(_imagenSeleccionada!.path);
        urlImagen = resultadoImagen['url'];
      }

      final datosFormulario = {
        'Profile_name': _nombreController.text.trim(),
        'Profile_lastname': _apellidoController.text.trim(),
        'Profile_phone': _telefonoController.text.trim(),
        'Profile_addres': _direccionController.text.trim(),
        'Profile_email': _emailController.text.trim(),
        'Profile_photo': urlImagen,
        'Profile_birthdate': _fechaNacimiento?.toIso8601String().split('T')[0],
        'Profile_gender': _genero,
        'Profile_national_id': _documentoController.text.trim(),
        'Profile_bio': _biografiaController.text.trim(),
        'Profile_website': _websiteController.text.trim(),
        'Profile_social': _socialController.text.trim(),
      };

      if (widget.perfil != null) {
        // Actualizar perfil existente
        await _perfilService.updateByUser(widget.userId, datosFormulario);
      } else {
        // Crear nuevo perfil
        await _perfilService.createByUser(datosFormulario);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.perfil != null ? 'Perfil actualizado correctamente' : 'Perfil creado correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      widget.onSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perfil != null ? 'Editar Perfil' : 'Crear Perfil'),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onCancel,
        ),
        actions: [
          if (_cargando)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _guardarPerfil,
              child: const Text(
                'GUARDAR',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      backgroundColor: const Color(0xFF15365F),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Avatar/Foto
            Center(
              child: GestureDetector(
                onTap: _seleccionarImagen,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF72A3D1), width: 3),
                    color: Colors.white,
                  ),
                  child: _imagenSeleccionada != null
                      ? ClipOval(
                          child: Image.file(
                            _imagenSeleccionada!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : _urlImagenActual != null && _urlImagenActual!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                _urlImagenActual!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person, size: 60, color: Color(0xFF72A3D1));
                                },
                              ),
                            )
                          : const Icon(Icons.person, size: 60, color: Color(0xFF72A3D1)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Toca para cambiar foto',
                style: TextStyle(color: Color(0xFF72A3D1), fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Campos del formulario
            _buildTextField('Nombre *', _nombreController, validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El nombre es requerido';
              }
              return null;
            }),
            
            _buildTextField('Apellido *', _apellidoController, validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El apellido es requerido';
              }
              return null;
            }),

            _buildTextField('Teléfono', _telefonoController, keyboardType: TextInputType.phone),
            
            _buildTextField('Dirección', _direccionController),
            
            _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
            
            _buildTextField('Documento de Identidad', _documentoController),

            // Fecha de nacimiento
            GestureDetector(
              onTap: _seleccionarFecha,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _fechaNacimiento != null
                          ? 'Fecha de nacimiento: ${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}'
                          : 'Seleccionar fecha de nacimiento',
                      style: TextStyle(
                        color: _fechaNacimiento != null ? Colors.black : Colors.grey,
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: Color(0xFF72A3D1)),
                  ],
                ),
              ),
            ),

            // Género
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonFormField<String>(
                value: _genero,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  border: InputBorder.none,
                ),
                items: const [
                  DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                  DropdownMenuItem(value: 'Prefiero no decir', child: Text('Prefiero no decir')),
                ],
                onChanged: (value) => setState(() => _genero = value),
              ),
            ),

            _buildTextField('Biografía', _biografiaController, maxLines: 3),
            
            _buildTextField('Sitio Web', _websiteController),
            
            _buildTextField('Red Social', _socialController),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF72A3D1)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF72A3D1), width: 2),
          ),
        ),
      ),
    );
  }
}