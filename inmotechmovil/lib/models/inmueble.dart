class Inmueble {
  final int? id;
  final List<String> imagenes;
  final int area;
  final int terreno;
  final int habitaciones;
  final int banos;
  final String descripcion;
  final String? titulo;
  final double? precio;
  final String? tipo;
  final String? estado;
  final String? ubicacion;
  final String? direccion;
  final double? latitud;
  final double? longitud;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;
  final bool? activo;
  final int? propietarioId;
  final Map<String, dynamic>? otrasCaracteristicas;

  const Inmueble({
    this.id,
    required this.imagenes,
    required this.area,
    required this.terreno,
    required this.habitaciones,
    required this.banos,
    required this.descripcion,
    this.titulo,
    this.precio,
    this.tipo,
    this.estado,
    this.ubicacion,
    this.direccion,
    this.latitud,
    this.longitud,
    this.fechaCreacion,
    this.fechaActualizacion,
    this.activo,
    this.propietarioId,
    this.otrasCaracteristicas,
  });

  factory Inmueble.fromJson(Map<String, dynamic> json) {
    return Inmueble(
      id: json['id'] as int?,
      imagenes: json['imagenes'] != null 
        ? List<String>.from(json['imagenes'])
        : [],
      area: json['area'] as int? ?? 0,
      terreno: json['terreno'] as int? ?? 0,
      habitaciones: json['habitaciones'] as int? ?? 0,
      banos: json['banos'] as int? ?? 0,
      descripcion: json['descripcion'] as String? ?? '',
      titulo: json['titulo'] as String?,
      precio: json['precio'] != null ? (json['precio'] as num).toDouble() : null,
      tipo: json['tipo'] as String?,
      estado: json['estado'] as String?,
      ubicacion: json['ubicacion'] as String?,
      direccion: json['direccion'] as String?,
      latitud: json['latitud'] != null ? (json['latitud'] as num).toDouble() : null,
      longitud: json['longitud'] != null ? (json['longitud'] as num).toDouble() : null,
      fechaCreacion: json['fechaCreacion'] != null 
        ? DateTime.parse(json['fechaCreacion'])
        : null,
      fechaActualizacion: json['fechaActualizacion'] != null 
        ? DateTime.parse(json['fechaActualizacion'])
        : null,
      activo: json['activo'] as bool?,
      propietarioId: json['propietarioId'] as int?,
      otrasCaracteristicas: json['otrasCaracteristicas'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'imagenes': imagenes,
      'area': area,
      'terreno': terreno,
      'habitaciones': habitaciones,
      'banos': banos,
      'descripcion': descripcion,
      if (titulo != null) 'titulo': titulo,
      if (precio != null) 'precio': precio,
      if (tipo != null) 'tipo': tipo,
      if (estado != null) 'estado': estado,
      if (ubicacion != null) 'ubicacion': ubicacion,
      if (direccion != null) 'direccion': direccion,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
      if (fechaCreacion != null) 'fechaCreacion': fechaCreacion!.toIso8601String(),
      if (fechaActualizacion != null) 'fechaActualizacion': fechaActualizacion!.toIso8601String(),
      if (activo != null) 'activo': activo,
      if (propietarioId != null) 'propietarioId': propietarioId,
      if (otrasCaracteristicas != null) 'otrasCaracteristicas': otrasCaracteristicas,
    };
  }

  // Método para crear una copia con valores modificados
  Inmueble copyWith({
    int? id,
    List<String>? imagenes,
    int? area,
    int? terreno,
    int? habitaciones,
    int? banos,
    String? descripcion,
    String? titulo,
    double? precio,
    String? tipo,
    String? estado,
    String? ubicacion,
    String? direccion,
    double? latitud,
    double? longitud,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    bool? activo,
    int? propietarioId,
    Map<String, dynamic>? otrasCaracteristicas,
  }) {
    return Inmueble(
      id: id ?? this.id,
      imagenes: imagenes ?? this.imagenes,
      area: area ?? this.area,
      terreno: terreno ?? this.terreno,
      habitaciones: habitaciones ?? this.habitaciones,
      banos: banos ?? this.banos,
      descripcion: descripcion ?? this.descripcion,
      titulo: titulo ?? this.titulo,
      precio: precio ?? this.precio,
      tipo: tipo ?? this.tipo,
      estado: estado ?? this.estado,
      ubicacion: ubicacion ?? this.ubicacion,
      direccion: direccion ?? this.direccion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      activo: activo ?? this.activo,
      propietarioId: propietarioId ?? this.propietarioId,
      otrasCaracteristicas: otrasCaracteristicas ?? this.otrasCaracteristicas,
    );
  }

  @override
  String toString() {
    return 'Inmueble(id: $id, titulo: $titulo, area: $area, habitaciones: $habitaciones, banos: $banos, precio: $precio)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Inmueble && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}