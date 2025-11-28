class Inmueble {
  final int id;
  final List<String> imagenes;
  final int area;
  final int terreno;
  final int habitaciones;
  final int banos;
  final String descripcion;
  final String titulo;
  final double precio;

  Inmueble({
    required this.id,
    required this.imagenes,
    required this.area,
    required this.terreno,
    required this.habitaciones,
    required this.banos,
    required this.descripcion,
    required this.titulo,
    required this.precio,
  });

  factory Inmueble.fromJson(Map<String, dynamic> json) {
    return Inmueble(
      id: json['id'],
      imagenes: List<String>.from(json['imagenes'] ?? []),
      area: json['area'],
      terreno: json['terreno'],
      habitaciones: json['habitaciones'],
      banos: json['banos'],
      descripcion: json['descripcion'],
      titulo: json['titulo'],
      precio: (json['precio'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagenes': imagenes,
      'area': area,
      'terreno': terreno,
      'habitaciones': habitaciones,
      'banos': banos,
      'descripcion': descripcion,
      'titulo': titulo,
      'precio': precio,
    };
  }
}
