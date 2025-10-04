import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/inmueble.dart';

class DetalleInmuebleWidget extends StatelessWidget {
  final Inmueble inmueble;
  final bool showEditButton;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DetalleInmuebleWidget({
    Key? key,
    required this.inmueble,
    this.showEditButton = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ CONVERTIR EL INMUEBLE A MAP PARA ACCESO DIRECTO
    final inmuebleData = inmueble.toJson();
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageGallery(inmuebleData),
          _buildMainInfo(inmuebleData),
          _buildDetails(inmuebleData),
          _buildLocation(inmuebleData),
          _buildAdditionalFeatures(inmuebleData),
          _buildContactInfo(inmuebleData),
          if (showEditButton) _buildOwnerActions(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImageGallery(Map<String, dynamic> data) {
    // ✅ ACCESO CORRECTO A IMÁGENES
    final imagenesInmueble = data['ImagenesInmueble'] ?? data['imagenesInmueble'];
    final imageUrl = imagenesInmueble is Map ? imagenesInmueble['URL'] : '';
    
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: imageUrl != null && imageUrl.toString().isNotEmpty
            ? Image.network(
                imageUrl.toString(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64, color: Colors.grey),
            SizedBox(height: 8),
            Text('Sin imagen disponible', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ PRECIO CORREGIDO
          Text(
            '\$${_formatPrice(data['Valor'])}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C56A7),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // ✅ DESCRIPCIÓN CORREGIDA
          Text(
            data['Descripcion_General']?.toString() ?? 'Sin descripción disponible',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF15365F),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: data['Estado'] == 'Activo' ? Colors.green[100] : Colors.orange[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data['Estado']?.toString() ?? 'Sin estado',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: data['Estado'] == 'Activo' ? Colors.green[700] : Colors.orange[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(Map<String, dynamic> data) {
    // ✅ ACCESO CORRECTO A DIVISIÓN Y TIPO EDIFICACIÓN
    final division = data['division'];
    final tipoEdificacion = data['TipoEdificacion'] ?? data['tipoEdificacion'];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF72A3D1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles del Inmueble',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF15365F),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.square_foot,
                  'Área',
                  '${data['Area']?.toString() ?? 'N/D'} m²',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  Icons.bed,
                  'Habitaciones',
                  division?['Habitaciones']?.toString() ?? 'N/D',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.bathroom,
                  'Baños',
                  division?['Baños']?.toString() ?? 'N/D',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  Icons.local_parking,
                  'Parqueaderos',
                  division?['Parqueaderos']?.toString() ?? 'N/D',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          _buildDetailItem(
            Icons.home_work,
            'Tipo de Edificación',
            tipoEdificacion?['TipoEdificacion']?.toString() ?? 'N/D',
          ),
          
          const SizedBox(height: 8),
          
          _buildDetailItem(
            Icons.business,
            'Situación',
            data['SituacionInmueble']?.toString() ?? 'N/D',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1C56A7)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF15365F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(Map<String, dynamic> data) {
    // ✅ ACCESO CORRECTO A DIRECCIÓN
    final direccion = data['Direccion'] ?? data['direccion'];
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ubicación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF15365F),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF1C56A7)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  direccion?['Direccion']?.toString() ?? 'Dirección no disponible',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          
          // ✅ BARRIO/CIUDAD CORREGIDO
          if (direccion != null && direccion['BarrioCiudadCorregimientoVereda'] != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.place, color: Color(0xFF1C56A7)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _buildLocationText(direccion),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdditionalFeatures(Map<String, dynamic> data) {
    // ✅ ACCESO CORRECTO A CARACTERÍSTICAS ADICIONALES
    final acercaEdificacion = data['AcercaEdificacion'] ?? data['acercaEdificacion'];
    final otrasCaracteristicas = data['OtrasCaracteristicas'] ?? data['otrasCaracteristicas'];
    
    if (acercaEdificacion == null && otrasCaracteristicas == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Características Adicionales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF15365F),
            ),
          ),
          
          const SizedBox(height: 12),
          
          if (acercaEdificacion != null) ...[
            const Text(
              'Información de la Edificación:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C56A7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              acercaEdificacion['AcercaEdificacion']?.toString() ?? 
              acercaEdificacion.toString(),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
          ],
          
          if (otrasCaracteristicas != null) ...[
            const Text(
              'Otras Características:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C56A7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              otrasCaracteristicas is Map 
                  ? otrasCaracteristicas['OtrasCaracteristicas']?.toString() ?? 'N/D'
                  : otrasCaracteristicas.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactInfo(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15365F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Contacto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('3001234567'),
                  icon: const Icon(Icons.phone),
                  label: const Text('Llamar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF72A3D1),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _sendWhatsApp('3001234567', data),
                  icon: const Icon(Icons.message),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Editar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showDeleteDialog(context),
              icon: const Icon(Icons.delete),
              label: const Text('Eliminar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Inmueble'),
        content: const Text('¿Estás seguro de que deseas eliminar este inmueble? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onDelete != null) onDelete!();
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ FORMATEO DE PRECIO MEJORADO
  String _formatPrice(dynamic precio) {
    if (precio == null) return '0';
    
    try {
      final num = precio is String 
          ? double.tryParse(precio) ?? 0 
          : precio is int 
              ? precio.toDouble() 
              : precio as double;
      
      if (num >= 1000000) {
        return '${(num / 1000000).toStringAsFixed(1)}M';
      } else if (num >= 1000) {
        return '${(num / 1000).toStringAsFixed(0)}K';
      }
      return num.toStringAsFixed(0);
    } catch (e) {
      return '0';
    }
  }

  // ✅ CONSTRUCCIÓN DE TEXTO DE UBICACIÓN CORREGIDA
  String _buildLocationText(Map<String, dynamic> direccion) {
    final barrio = direccion['BarrioCiudadCorregimientoVereda'];
    final parts = <String>[];
    
    if (barrio != null) {
      // Intenta diferentes estructuras de datos
      if (barrio is Map) {
        if (barrio['barrio'] != null) {
          final barrioData = barrio['barrio'];
          parts.add(barrioData is Map ? barrioData['barrio']?.toString() ?? '' : barrioData.toString());
        }
        if (barrio['ciudad'] != null) {
          final ciudadData = barrio['ciudad'];
          parts.add(ciudadData is Map ? ciudadData['ciudad']?.toString() ?? '' : ciudadData.toString());
        }
        if (barrio['corregimiento'] != null) {
          final corregimientoData = barrio['corregimiento'];
          parts.add(corregimientoData is Map ? corregimientoData['corregimiento']?.toString() ?? '' : corregimientoData.toString());
        }
        if (barrio['vereda'] != null) {
          final veredaData = barrio['vereda'];
          parts.add(veredaData is Map ? veredaData['vereda']?.toString() ?? '' : veredaData.toString());
        }
      } else {
        parts.add(barrio.toString());
      }
    }
    
    return parts.where((part) => part.isNotEmpty).join(', ').ifEmpty('Ubicación no especificada');
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      print('Error al hacer llamada: $e');
    }
  }

  Future<void> _sendWhatsApp(String phoneNumber, Map<String, dynamic> data) async {
    final descripcion = data['Descripcion_General']?.toString() ?? 'Sin descripción';
    final message = 'Hola, estoy interesado en el inmueble: $descripcion';
    final uri = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
    }
  }
}

// ✅ EXTENSIÓN PARA STRING VACÍO
extension StringExtension on String {
  String ifEmpty(String defaultValue) => isEmpty ? defaultValue : this;
}