import 'package:flutter/material.dart';
import '../models/inmueble.dart';
import '../pages/detalle_inmueble_page.dart';

class InmuebleCard extends StatelessWidget {
  final Map<String, dynamic> inmuebleData;
  final bool showOwnerActions;
  final bool showFavoriteButton; // ✅ AGREGAR PARÁMETRO FALTANTE
  final bool isOwner;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleFavorito; // ✅ AGREGAR CALLBACK PARA FAVORITOS

  const InmuebleCard({
    Key? key,
    required this.inmuebleData,
    this.showOwnerActions = false,
    this.showFavoriteButton = false, // ✅ AGREGAR CON VALOR POR DEFECTO
    this.isOwner = false,
    this.onEdit,
    this.onDelete,
    this.onToggleFavorito, // ✅ AGREGAR
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagenes = inmuebleData['imagenesInmueble'] ?? inmuebleData['ImagenesInmueble'];
    final primeraImagen = imagenes != null && imagenes is Map 
        ? imagenes['URL'] 
        : (imagenes is List && imagenes.isNotEmpty) 
            ? imagenes[0]['URL'] 
            : null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ IMAGEN CON OVERLAY
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: primeraImagen != null
                      ? Image.network(
                          primeraImagen,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        )
                      : _buildPlaceholderImage(),
                ),
                
                // ✅ BADGE DE PRECIO
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C56A7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatPrice(inmuebleData['Valor']),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ✅ BOTÓN FAVORITO (solo si está habilitado)
                if (showFavoriteButton)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 20,
                        padding: const EdgeInsets.all(4),
                        icon: Icon(
                          inmuebleData['es_favorito'] == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: inmuebleData['es_favorito'] == true 
                              ? Colors.red 
                              : Colors.grey,
                        ),
                        onPressed: () {
                          if (onToggleFavorito != null) {
                            onToggleFavorito!();
                          } else {
                            _toggleFavorito(context);
                          }
                        },
                      ),
                    ),
                  ),

                // ✅ ACCIONES DE PROPIETARIO (solo si está habilitado)
                if (showOwnerActions)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_vert, size: 16),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16, color: Colors.orange),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 16),
                              SizedBox(width: 8),
                              Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) => _handleOwnerAction(context, value),
                    ),
                  ),
              ],
            ),

            // ✅ INFORMACIÓN DEL INMUEBLE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Descripción
                    Text(
                      inmuebleData['Descripcion_General'] ?? 'Sin descripción',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Ubicación
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            inmuebleData['Direccion']?['Direccion'] ?? 
                            inmuebleData['direccion']?['Direccion'] ?? 
                            'Sin dirección',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Detalles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailItem(
                          Icons.bed,
                          '${inmuebleData['division']?['Habitaciones'] ?? 'N/D'}',
                        ),
                        _buildDetailItem(
                          Icons.bathtub,
                          '${inmuebleData['division']?['Baños'] ?? 'N/D'}',
                        ),
                        _buildDetailItem(
                          Icons.square_foot,
                          '${inmuebleData['Area'] ?? 'N/D'}m²',
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Estado
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: inmuebleData['Estado'] == 'Activo' 
                            ? Colors.green[100] 
                            : Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        inmuebleData['Estado'] ?? 'Activo',
                        style: TextStyle(
                          fontSize: 9,
                          color: inmuebleData['Estado'] == 'Activo' 
                              ? Colors.green[700] 
                              : Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 140,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(
        Icons.home,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF72A3D1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: const Color(0xFF1C56A7)),
          const SizedBox(width: 2),
          Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF1C56A7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'N/D';
    
    try {
      final numPrice = double.parse(price.toString());
      if (numPrice >= 1000000) {
        return '\$${(numPrice / 1000000).toStringAsFixed(1)}M';
      } else if (numPrice >= 1000) {
        return '\$${(numPrice / 1000).toStringAsFixed(0)}K';
      } else {
        return '\$${numPrice.toStringAsFixed(0)}';
      }
    } catch (e) {
      return 'N/D';
    }
  }

  void _toggleFavorito(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de favoritos próximamente'),
        backgroundColor: Color(0xFF1C56A7),
      ),
    );
  }

  void _handleOwnerAction(BuildContext context, String action) {
    if (action == 'edit') {
      if (onEdit != null) {
        onEdit!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Editar próximamente'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else if (action == 'delete') {
      if (onDelete != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Eliminar Inmueble'),
            content: const Text('¿Estás seguro de que deseas eliminar este inmueble?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDelete!();
                },
                child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Eliminar próximamente'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToDetail(BuildContext context) {
    try {
      print('🏠 Navegando al detalle del inmueble: ${inmuebleData['Inmueble_id']}');
      
      final inmueble = Inmueble.fromJson(inmuebleData);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalleInmueblePage(inmuebleId: inmueble.id!),
        ),
      );
    } catch (e) {
      print('❌ Error al navegar al detalle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al abrir detalles: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}