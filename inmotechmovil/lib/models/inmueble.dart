class Inmueble {
  final List<String> imagenes;
  final int area;
  final int terreno;
  final int habitaciones;
  final int banos;
  final String descripcion;

  Inmueble({
    required this.imagenes,
    required this.area,
    required this.terreno,
    required this.habitaciones,
    required this.banos,
    required this.descripcion,
  });
}