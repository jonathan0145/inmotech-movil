import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/perfil.dart';
import '../services/perfil_service.dart';
import '../widgets/crear_perfil_form.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PerfilService _perfilService = PerfilService();
  
  Perfil? _perfil;
  bool _loading = true;
  String? _error;
  int? _userId;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUserAndProfile();
  }

  Future<void> _loadUserAndProfile() async {
    try {
      // ✅ OBTENER USUARIO ACTUAL
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getInt('user_id') ?? 
               prefs.getInt('Platform_user_id') ?? 
               prefs.getInt('userId');
      
      final userString = prefs.getString('user');
      if (userString != null) {
        _user = Map<String, dynamic>.from(
          // Parsear JSON si es necesario
          userString.contains('{') ? {} : {'Username': userString}
        );
      }

      if (_userId == null) {
        setState(() {
          _error = 'No se pudo obtener información del usuario';
          _loading = false;
        });
        return;
      }

      // ✅ CARGAR PERFIL
      await _loadProfile();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadProfile() async {
    try {
      setState(() => _loading = true);
      
      final perfilData = await _perfilService.getByUserId(_userId!);
      
      setState(() {
        _perfil = perfilData != null ? Perfil.fromJson(perfilData) : null;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // ✅ NAVEGAR AL LOGIN
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    }
  }

  void _showCreateEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearPerfilForm(
          userId: _userId!,
          perfil: _perfil,
          onSuccess: () {
            Navigator.pop(context);
            _loadProfile(); // Recargar perfil
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_perfil != null 
                    ? 'Perfil actualizado correctamente' 
                    : 'Perfil creado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          },
          onCancel: () => Navigator.pop(context),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15365F),
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_loading)
            IconButton(
              onPressed: _loadProfile,
              icon: const Icon(Icons.refresh),
              tooltip: 'Actualizar',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando perfil...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF72A3D1),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF15365F),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF72A3D1).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // ✅ HEADER CON AVATAR Y NOMBRE
          _buildProfileHeader(),
          
          const SizedBox(height: 24),
          
          // ✅ INFORMACIÓN DEL PERFIL
          _buildProfileInfo(),
          
          const SizedBox(height: 24),
          
          // ✅ BOTONES DE ACCIÓN
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        // ✅ AVATAR
        CircleAvatar(
          radius: 45,
          backgroundColor: const Color(0xFF72A3D1),
          backgroundImage: _perfil?.profilePhoto != null && _perfil!.profilePhoto!.isNotEmpty
              ? NetworkImage(_perfil!.profilePhoto!)
              : null,
          child: _perfil?.profilePhoto == null || _perfil!.profilePhoto!.isEmpty
              ? const Icon(Icons.person, size: 50, color: Colors.white)
              : null,
        ),
        
        const SizedBox(width: 20),
        
        // ✅ INFORMACIÓN BÁSICA
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _perfil?.nombreCompleto ?? 
                _user?['Username'] ?? 
                'Usuario sin nombre',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF72A3D1),
                ),
              ),
              
              if (_perfil?.profileEmail != null && _perfil!.profileEmail!.isNotEmpty)
                Text(
                  _perfil!.profileEmail!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    if (_perfil == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF72A3D1).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.person_add,
              size: 48,
              color: Color(0xFF72A3D1),
            ),
            SizedBox(height: 12),
            Text(
              'No tienes un perfil creado',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Crea tu perfil para completar tu información personal',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildInfoRow('Teléfono', _perfil!.profilePhone),
        _buildInfoRow('Dirección', _perfil!.profileAddress),
        _buildInfoRow('Fecha de nacimiento', _perfil!.profileBirthdate),
        _buildInfoRow('Género', _perfil!.profileGender),
        _buildInfoRow('Documento', _perfil!.profileNationalId),
        
        if (_perfil!.profileBio != null && _perfil!.profileBio!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF72A3D1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Biografía:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF72A3D1),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _perfil!.profileBio!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
        
        if (_perfil!.profileWebsite != null && _perfil!.profileWebsite!.isNotEmpty)
          _buildInfoRow('Sitio web', _perfil!.profileWebsite),
        
        if (_perfil!.profileSocial != null && _perfil!.profileSocial!.isNotEmpty)
          _buildInfoRow('Red social', _perfil!.profileSocial),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF72A3D1),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // ✅ BOTÓN CREAR/EDITAR PERFIL
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showCreateEditProfile,
            icon: Icon(_perfil != null ? Icons.edit : Icons.add),
            label: Text(_perfil != null ? 'Editar Perfil' : 'Crear Perfil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C56A7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // ✅ BOTÓN CERRAR SESIÓN
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar Sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}