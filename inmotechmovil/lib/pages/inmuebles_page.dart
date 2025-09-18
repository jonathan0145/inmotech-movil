import 'package:flutter/material.dart';
import '../models/inmueble.dart';
import 'detalle_inmueble_page.dart';

final List<Inmueble> inmuebles = [
  Inmueble(
    imagenes: [
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      'https://images.unsplash.com/photo-1460518451285-97b6aa326961',
      'https://images.unsplash.com/photo-1460518451285-97b6aa326961',
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      'https://images.unsplash.com/photo-1507089947368-19c1da9775ae',
      'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
    ],
    area: 250,
    terreno: 500,
    habitaciones: 4,
    banos: 3,
    descripcion: '¡El hogar familiar de tus sueños te espera! Este espacioso chalet de 250 m² cuenta con 4 habitaciones y 3 baños, perfecto para una familia que busca espacio y privacidad. Ubicado en una calle tranquila y arbolada, la propiedad se asienta en un terreno de 500 m² con un hermoso jardín maduro y una piscina privada.',
  ),
  Inmueble(
    imagenes: [
      'https://images.unsplash.com/photo-1460518451285-97b6aa326961',
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    ],
    area: 200,
    terreno: 400,
    habitaciones: 2,
    banos: 1,
    descripcion: 'Moderno apartamento con vistas espectaculares, 2 habitaciones, 1 baño, cocina equipada y terraza amplia.',
  ),
  Inmueble(
    imagenes: [
      'https://images.unsplash.com/photo-1507089947368-19c1da9775ae',
      'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
    ],
    area: 320,
    terreno: 500,
    habitaciones: 8,
    banos: 3,
    descripcion: 'Casa familiar de gran tamaño, ideal para familias numerosas. 8 habitaciones, 3 baños, gran jardín y cochera doble.',
  ),
  Inmueble(
    imagenes: [
      'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd',
      'https://images.unsplash.com/photo-1507089947368-19c1da9775ae',
    ],
    area: 320,
    terreno: 500,
    habitaciones: 2,
    banos: 1,
    descripcion: 'Cabaña acogedora en la montaña, 2 habitaciones, 1 baño, sala con chimenea y vistas panorámicas.',
  ),
];

class InmueblesPage extends StatefulWidget {
  const InmueblesPage({Key? key}) : super(key: key);

  @override
  State<InmueblesPage> createState() => _InmueblesPageState();
}

class _InmueblesPageState extends State<InmueblesPage> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    // Filtra los inmuebles según el texto de búsqueda
    final filteredInmuebles = inmuebles.where((inmueble) {
      final query = searchText.toLowerCase();
      return inmueble.descripcion.toLowerCase().contains(query) ||
          inmueble.area.toString().contains(query) ||
          inmueble.habitaciones.toString().contains(query) ||
          inmueble.banos.toString().contains(query) ||
          inmueble.terreno.toString().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido Inmotech')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar inmueble...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredInmuebles.length,
              itemBuilder: (context, index) {
                final inmueble = filteredInmuebles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalleInmueblePage(inmueble: inmueble),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.network(
                            inmueble.imagenes[0], // Muestra la primera imagen
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Área: ${inmueble.area} m²'),
                              Text('Terreno: ${inmueble.terreno} m²'),
                              Text('Habitaciones: ${inmueble.habitaciones}'),
                              Text('Baños: ${inmueble.banos}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}