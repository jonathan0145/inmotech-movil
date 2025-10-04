import 'package:flutter/material.dart';
import '../models/perfil.dart';

class ProfileModal extends StatelessWidget {
  final dynamic perfil; // ✅ CAMBIAR DE Perfil? A dynamic
  final List<Map<String, dynamic>> inmuebles;
  final Function(Map<String, dynamic>) onInmuebleTap;

  const ProfileModal({
    Key? key,
    required this.perfil,
    required this.inmuebles,
    required this.onInmuebleTap,
  }) : super(key: key);

  // ✅ GETTERS SEGUROS PARA AMBOS TIPOS
  String get nombreCompleto {
    if (perfil is Perfil) {
      return (perfil as Perfil).nombreCompleto ?? 'Sin nombre';
    } else if (perfil is Map<String, dynamic>) {
      return perfil["nombre"] ?? 'Sin nombre';
    }
    return 'Sin nombre';
  }

  String get profileEmail {
    if (perfil is Perfil) {
      return (perfil as Perfil).profileEmail ?? '';
    } else if (perfil is Map<String, dynamic>) {
      return perfil["email"] ?? '';
    }
    return '';
  }

  String get profilePhone {
    if (perfil is Perfil) {
      return (perfil as Perfil).profilePhone ?? '';
    } else if (perfil is Map<String, dynamic>) {
      return perfil["telefono"] ?? '';
    }
    return '';
  }

  String get profilePhoto {
    if (perfil is Perfil) {
      return (perfil as Perfil).profilePhoto ?? '';
    } else if (perfil is Map<String, dynamic>) {
      return perfil["avatar"] ?? '';
    }
    return '';
  }

  String get profileBio {
    if (perfil is Perfil) {
      return (perfil as Perfil).profileBio ?? '';
    } else if (perfil is Map<String, dynamic>) {
      return perfil["bio"] ?? '';
    }
    return '';
  }

  String get profileAddress {
    if (perfil is Perfil) {
      return (perfil as Perfil).profileAddress ?? '';
    } else if (perfil is Map<String, dynamic>) {
      return perfil["direccion"] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF15365F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              
              const TabBar(
                labelColor: Color(0xFF72A3D1),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF72A3D1),
                tabs: [
                  Tab(text: "Perfil"),
                  Tab(text: "Inmuebles"),
                ],
              ),
              
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPerfilTab(),
                    _buildInmueblesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerfilTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // ✅ AVATAR CON MANEJO ROBUSTO
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF72A3D1),
            backgroundImage: _getProfileImage(),
            child: _getProfileImage() == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            nombreCompleto,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          if (profileEmail.isNotEmpty)
            Text(
              profileEmail,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF72A3D1),
              ),
            ),
          
          const SizedBox(height: 8),
          
          if (profilePhone.isNotEmpty)
            Text(
              profilePhone,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF72A3D1),
              ),
            ),
          
          const SizedBox(height: 16),
          
          if (profileBio.isNotEmpty) ...[
            const Text(
              'Biografía:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF72A3D1),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profileBio,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          const SizedBox(height: 16),
          
          if (profileAddress.isNotEmpty)
            _buildInfoRow(Icons.location_on, profileAddress),
        ],
      ),
    );
  }

  // ✅ MÉTODO HELPER PARA MANEJAR IMÁGENES
  ImageProvider? _getProfileImage() {
    if (profilePhoto.isEmpty) return null;
    
    if (profilePhoto.startsWith('http')) {
      return NetworkImage(profilePhoto);
    } else if (profilePhoto.startsWith('assets/')) {
      return AssetImage(profilePhoto);
    } else {
      // Asumir que es un asset si no es URL
      return AssetImage(profilePhoto);
    }
  }

  Widget _buildInfoRow(IconData icon, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF72A3D1)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInmueblesTab() {
    if (inmuebles.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No hay inmuebles disponibles',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: inmuebles.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey[600]),
      itemBuilder: (context, index) {
        final inmueble = inmuebles[index];
        return _buildInmuebleItem(inmueble, context);
      },
    );
  }

  Widget _buildInmuebleItem(Map<String, dynamic> inmueble, BuildContext context) {
    final titulo = inmueble['titulo'] ?? 'Sin título';
    final direccion = inmueble['direccion'] ?? 'Sin dirección';
    final precio = inmueble['precio'] ?? '0';
    final imagenes = inmueble['imagenes'] as List<dynamic>?;
    final imagenUrl = imagenes != null && imagenes.isNotEmpty ? imagenes[0] as String : '';
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[600],
        ),
        child: imagenUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imagenUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.home, color: Colors.white);
                  },
                ),
              )
            : const Icon(Icons.home, size: 30, color: Colors.white),
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 14,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        direccion,
        style: const TextStyle(
          color: Color(0xFF72A3D1),
          fontSize: 12,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        precio,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onInmuebleTap(inmueble);
      },
    );
  }
}