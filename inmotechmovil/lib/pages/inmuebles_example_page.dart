import 'package:flutter/material.dart';
import '../services/services.dart';
import '../models/inmueble.dart';

class InmueblesExamplePage extends StatefulWidget {
  const InmueblesExamplePage({Key? key}) : super(key: key);

  @override
  State<InmueblesExamplePage> createState() => _InmueblesExamplePageState();
}

class _InmueblesExamplePageState extends State<InmueblesExamplePage> {
  final InmuebleService _inmuebleService = InmuebleService();
  final VisualizationService _visualizationService = VisualizationService();
  
  List<Inmueble> _inmuebles = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInmuebles();
  }

  Future<void> _loadInmuebles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _inmuebleService.getAllInmuebles();
      final inmuebles = response.map((json) => Inmueble.fromJson(json)).toList();
      
      setState(() {
        _inmuebles = inmuebles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _searchInmuebles(String query) async {
    if (query.isEmpty) {
      _loadInmuebles();
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _inmuebleService.searchInmuebles(query: query);
      final inmuebles = response.map((json) => Inmueble.fromJson(json)).toList();
      
      setState(() {
        _inmuebles = inmuebles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _registerView(int inmuebleId) async {
    try {
      await _visualizationService.registerInmuebleView(
        inmuebleId,
        deviceType: 'mobile',
      );
    } catch (e) {
      // Manejo silencioso del error de visualización
      print('Error registrando visualización: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inmuebles - Ejemplo API'),
        actions: [
          IconButton(
            onPressed: _loadInmuebles,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar inmuebles...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Debounce la búsqueda
                Future.delayed(const Duration(milliseconds: 500), () {
                  _searchInmuebles(value);
                });
              },
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
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
              style: TextStyle(
                color: Colors.red[300],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadInmuebles,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_inmuebles.isEmpty) {
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
              'No se encontraron inmuebles',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _inmuebles.length,
      itemBuilder: (context, index) {
        final inmueble = _inmuebles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              if (inmueble.id != null) {
                _registerView(inmueble.id!);
              }
              // Aquí navegarías a la página de detalle
              _showInmuebleDetail(inmueble);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del inmueble
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: inmueble.imagenes.isNotEmpty
                        ? Image.network(
                            inmueble.imagenes.first,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(Icons.home),
                              );
                            },
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.home),
                          ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Información del inmueble
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (inmueble.titulo != null)
                          Text(
                            inmueble.titulo!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          inmueble.descripcion,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.square_foot, size: 16, color: Colors.grey[600]),
                            Text(' ${inmueble.area} m²'),
                            const SizedBox(width: 16),
                            Icon(Icons.bed, size: 16, color: Colors.grey[600]),
                            Text(' ${inmueble.habitaciones}'),
                            const SizedBox(width: 16),
                            Icon(Icons.bathroom, size: 16, color: Colors.grey[600]),
                            Text(' ${inmueble.banos}'),
                          ],
                        ),
                        if (inmueble.precio != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            '\$${inmueble.precio!.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showInmuebleDetail(Inmueble inmueble) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(inmueble.titulo ?? 'Inmueble'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Área: ${inmueble.area} m²'),
              Text('Terreno: ${inmueble.terreno} m²'),
              Text('Habitaciones: ${inmueble.habitaciones}'),
              Text('Baños: ${inmueble.banos}'),
              if (inmueble.precio != null)
                Text('Precio: \$${inmueble.precio!.toStringAsFixed(0)}'),
              if (inmueble.ubicacion != null)
                Text('Ubicación: ${inmueble.ubicacion}'),
              const SizedBox(height: 16),
              Text('Descripción:\n${inmueble.descripcion}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}