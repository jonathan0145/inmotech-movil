import 'package:flutter/material.dart';
import '../models/inmueble.dart';
import '../services/inmueble_service.dart';

class DetalleInmueblePage extends StatefulWidget {
  final int inmuebleId; // ✅ CAMBIAR A SOLO ID
  final bool isOwner;

  const DetalleInmueblePage({
    super.key,
    required this.inmuebleId, // ✅ SOLO NECESITAMOS EL ID
    this.isOwner = false,
  });

  @override
  State<DetalleInmueblePage> createState() => _DetalleInmueblePageState();
}

class _DetalleInmueblePageState extends State<DetalleInmueblePage> with TickerProviderStateMixin {
  final InmuebleService _inmuebleService = InmuebleService();
  Map<String, dynamic>? _property;
  bool _loading = true;
  String? _error;
  PageController _pageController = PageController();
  int _currentImageIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _fetchCompleto();
  }

  Future<void> _fetchCompleto() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // ✅ USAR EL MISMO SERVICIO QUE TU WEB
      final response = await _inmuebleService.getCompleto(widget.inmuebleId);
      
      setState(() {
        _property = response;
        _loading = false;
      });
      
      _animationController.forward();
    } catch (err) {
      setState(() {
        _error = 'No se pudo cargar la información completa del inmueble';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C56A7),
      appBar: AppBar(
        title: const Text('Detalle del Inmueble'),
        backgroundColor: const Color(0xFF15365F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _shareInmueble(context),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: _loading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : _property != null
                  ? _buildDetailContent()
                  : _buildNoDataState(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando información completa...',
            style: TextStyle(color: Color(0xFFFDFDFD)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFdc3545),
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: const TextStyle(color: Color(0xFFFDFDFD)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchCompleto,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF72A3D1),
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return const Center(
      child: Text(
        'No se encontró el inmueble',
        style: TextStyle(color: Color(0xFFFDFDFD), fontSize: 18),
      ),
    );
  }

  Widget _buildDetailContent() {
    // ✅ EXTRAER DATOS SEGÚN LA ESTRUCTURA REAL DEL API
    final i = _property!['inmueble'] ?? {};
    final a = _property!['acercaEdificacion'] ?? {};
    final o = _property!['otrasCaracteristicas'] ?? {};
    final d = _property!['division'] ?? {};
    final dir = _property!['direccion'] ?? {};
    
    // ✅ EXTRAER DATOS ANIDADOS CORRECTAMENTE SEGÚN TU API
    final loc = dir['Localizacion'] ?? {}; // Mayúscula
    final ndap = dir['BarrioCiudadCorregimientoVereda']?['Ciudad']?['Municipio']?['Ndap'] ?? {};
    final municipio = dir['BarrioCiudadCorregimientoVereda']?['Ciudad']?['Municipio'] ?? {};
    final bccv = dir['BarrioCiudadCorregimientoVereda'] ?? {};
    final designador = dir['DesignadorCardinal'] ?? {}; // Mayúscula
    final tipo = _property!['tipoEdificacion'] ?? {};
    final asignacion = o['asignacion'] ?? {};
    final orgParqueadero = asignacion['organizacionParqueadero'] ?? {};
    
    // ✅ MANEJAR IMAGEN ÚNICA (NO ARRAY)
    final imagenesInmueble = _property!['ImagenesInmueble'] ?? {};
    final imagenesArray = imagenesInmueble.isNotEmpty ? [imagenesInmueble] : [];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Detalle del Inmueble',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFDFDFD),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // ✅ CARRUSEL CON IMAGEN ÚNICA
            _buildCarouselSection(imagenesArray),
            
            const SizedBox(height: 32),
            
            // ✅ TARJETAS DE INFORMACIÓN
            _buildInfoCards(i, a, o, d, dir, loc, ndap, municipio, bccv, designador, tipo, asignacion, orgParqueadero),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSection(List imagenesArray) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imagenesArray.isNotEmpty
            ? Column(
                children: [
                  // ✅ CARRUSEL PRINCIPAL
                  Container(
                    height: 300,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemCount: imagenesArray.length,
                          itemBuilder: (context, index) {
                            final imagen = imagenesArray[index];
                            final imageUrl = imagen['URL'] ?? '';
                            
                            return Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error, color: Colors.white, size: 40),
                                        SizedBox(height: 8),
                                        Text('Error al cargar imagen', style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF72A3D1)),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        
                        // ✅ CONTROLES DE NAVEGACIÓN (SOLO SI HAY MÁS DE 1 IMAGEN)
                        if (imagenesArray.length > 1) ...[
                          // Flecha izquierda
                          Positioned(
                            left: 16,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_currentImageIndex > 0) {
                                    _pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Flecha derecha
                          Positioned(
                            right: 16,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_currentImageIndex < imagenesArray.length - 1) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // ✅ INDICADORES
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: imagenesArray.asMap().entries.map((entry) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == entry.key
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // ✅ CONTADOR DE IMÁGENES
                  if (imagenesArray.length > 1)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF15365F).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF5a7ca3)),
                        ),
                        child: Text(
                          '📸 ${imagenesArray.length} imagen${imagenesArray.length != 1 ? 'es' : ''} disponible${imagenesArray.length != 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: Color(0xFFFDFDFD),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Container(
                height: 300,
                color: Colors.grey[800],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported, color: Colors.white, size: 40),
                      SizedBox(height: 8),
                      Text('Sin Imágenes Disponibles', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInfoCards(Map i, Map a, Map o, Map d, Map dir, Map loc, Map ndap, Map municipio, Map bccv, Map designador, Map tipo, Map asignacion, Map orgParqueadero) {
    // ✅ CREAR GRUPOS EXACTAMENTE IGUAL QUE EN TU WEB
    final grupos = [
      {
        'titulo': 'Datos Principales',
        'contenido': _buildDatosPrincipales(i),
      },
      {
        'titulo': 'Dirección',
        'contenido': _buildDireccion(dir),
      },
      {
        'titulo': 'NDAP',
        'contenido': _buildNDAP(ndap),
      },
      {
        'titulo': 'Municipio',
        'contenido': _buildMunicipio(municipio),
      },
      {
        'titulo': 'Barrio/Ciudad/Corregimiento/Vereda',
        'contenido': _buildBCCV(bccv),
      },
      {
        'titulo': 'Localización',
        'contenido': _buildLocalizacion(loc),
      },
      {
        'titulo': 'Designador Cardinal',
        'contenido': _buildDesignadorCardinal(designador),
      },
      {
        'titulo': 'División y Espacios',
        'contenido': _buildDivision(d),
      },
      {
        'titulo': 'Información de la Edificación',
        'contenido': _buildAcercaEdificacion(a),
      },
      {
        'titulo': 'Tipo Edificación',
        'contenido': _buildTipoEdificacion(tipo),
      },
      {
        'titulo': 'Otras Características',
        'contenido': _buildOtrasCaracteristicas(o),
      },
      {
        'titulo': 'Asignación',
        'contenido': _buildAsignacion(asignacion),
      },
      {
        'titulo': 'Organización Parqueadero',
        'contenido': _buildOrganizacionParqueadero(orgParqueadero),
      },
    ];

    return Column(
      children: grupos.asMap().entries.map((entry) {
        final index = entry.key;
        final grupo = entry.value;
        
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (index * 100)),
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildCustomCard(
            grupo['titulo'] as String,
            grupo['contenido'] as Widget,
            index,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomCard(String title, Widget content, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5a7ca3)),
        color: const Color(0xFF15365F),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3C5A82).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Efecto de toque
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF72A3D1),
                  ),
                ),
                const SizedBox(height: 16),
                content,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetalleItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF72A3D1),
            width: 0.2,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Color(0xFF72A3D1),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFFDFDFD),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextMuted(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF8AABCD),
        fontStyle: FontStyle.italic,
      ),
    );
  }

  // ✅ IMPLEMENTAR TODOS LOS MÉTODOS EXACTAMENTE IGUAL QUE EN TU WEB

  Widget _buildDatosPrincipales(Map i) {
    return Column(
      children: [
        _buildDetalleItem('Valor', '\$${_formatNumber(i['Valor']?.toString() ?? '0')}'),
        _buildDetalleItem('Área', '${i['Area']?.toString() ?? 'N/D'} m²'), // ✅ CONVERTIR A STRING
        _buildDetalleItem('Descripción General', i['Descripcion_General']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
        _buildDetalleItem('Antigüedad', '${i['Antiguedad']?.toString() ?? 'N/D'} años'), // ✅ CONVERTIR A STRING
        _buildDetalleItem('Motivo VoA', i['Motivo_VoA']?.toString() ?? 'N/D'),
        _buildDetalleItem('Situación inmueble', i['Situacion_inmueble']?.toString() ?? 'N/D'),
        _buildDetalleItem('Código interno', i['Codigo_interno']?.toString() ?? 'N/D'),
        _buildDetalleItem('Estado', i['Estado']?.toString() ?? 'N/D'),
        if (i['Observaciones'] != null)
          _buildDetalleItem('Observaciones', i['Observaciones'].toString()),
      ],
    );
  }

  Widget _buildDireccion(Map dir) {
    return Column(
      children: [
        _buildDetalleItem('Dirección', dir['Direccion']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
        _buildDetalleItem('Tipo de vía', dir['Tipo_via']?.toString() ?? 'N/D'),
        _buildDetalleItem('Número vía principal', dir['Numero_via_principal']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
        _buildDetalleItem('Número calle transversal', dir['Numero_calle_transversal']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
        _buildDetalleItem('Número edificación', dir['Numero_edificacion']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
        _buildDetalleItem('Descripción adicional', dir['Descripcion_adicional']?.toString() ?? 'N/D'),
      ],
    );
  }

  Widget _buildNDAP(Map ndap) {
    if (ndap['Ndap_descripcion'] != null) {
      return _buildDetalleItem('Descripción NDAP', ndap['Ndap_descripcion'].toString()); // ✅ CONVERTIR A STRING
    } else {
      return _buildTextMuted('No hay información NDAP disponible');
    }
  }

  Widget _buildMunicipio(Map municipio) {
    if (municipio['Municipio_nombre'] != null || municipio['Municipio_descripcion'] != null) {
      return Column(
        children: [
          _buildDetalleItem('Nombre Municipio', municipio['Municipio_nombre']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Descripción Municipio', municipio['Municipio_descripcion']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
        ],
      );
    } else {
      return _buildTextMuted('No hay información de municipio disponible');
    }
  }

  Widget _buildBCCV(Map bccv) {
    final barrio = bccv['Barrio'];
    final ciudad = bccv['Ciudad'];
    final corregimiento = bccv['Corregimiento'];
    final vereda = bccv['Vereda'];
    
    if (barrio?['Nombre_barrio'] != null || ciudad?['Ciudad'] != null || 
        corregimiento?['Corregimiento'] != null || vereda?['Vereda_nombre'] != null) {
      return Column(
        children: [
          if (barrio?['Nombre_barrio'] != null)
            _buildDetalleItem('Nombre Barrio', barrio['Nombre_barrio'].toString()), // ✅ CONVERTIR A STRING
          if (ciudad?['Ciudad'] != null)
            _buildDetalleItem('Ciudad', ciudad['Ciudad'].toString()), // ✅ CONVERTIR A STRING
          if (corregimiento?['Corregimiento'] != null)
            _buildDetalleItem('Corregimiento', corregimiento['Corregimiento'].toString()), // ✅ CONVERTIR A STRING
          if (vereda?['Vereda_nombre'] != null)
            _buildDetalleItem('Vereda', vereda['Vereda_nombre'].toString()), // ✅ CONVERTIR A STRING
        ],
      );
    } else {
      return _buildTextMuted('No hay información de ubicación específica disponible');
    }
  }

  Widget _buildLocalizacion(Map loc) {
    return Column(
      children: [
        _buildDetalleItem('Descripción', loc['Localizacion_descripcion']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
        if (loc['Latitud'] != null)
          _buildDetalleItem('Latitud', loc['Latitud'].toString()),
        if (loc['Longitud'] != null)
          _buildDetalleItem('Longitud', loc['Longitud'].toString()),
      ],
    );
  }

  Widget _buildDesignadorCardinal(Map designador) {
    if (designador['Cardinalidad'] != null || designador['Abreviacion'] != null) {
      return Column(
        children: [
          if (designador['Cardinalidad'] != null)
            _buildDetalleItem('Cardinalidad', designador['Cardinalidad'].toString()),
          if (designador['Abreviacion'] != null)
            _buildDetalleItem('Abreviación', designador['Abreviacion'].toString()),
        ],
      );
    } else {
      return _buildTextMuted('No hay información de designador cardinal disponible');
    }
  }

  Widget _buildDivision(Map d) {
    if (d.isNotEmpty) {
      return Column(
        children: [
          _buildDetalleItem('División', d['Division']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Habitaciones', d['Habitaciones']?.toString() ?? 'N/D'),
          _buildDetalleItem('Baños', d['Baños']?.toString() ?? 'N/D'),
          _buildDetalleItem('Balcón', d['Balcon']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Terraza', d['Terraza']?.toString() ?? 'N/D'),
          _buildDetalleItem('Garaje', d['Garaje']?.toString() ?? 'N/D'),
          _buildDetalleItem('Ascensores', d['Ascensores']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Área División', d['Area'] != null ? '${d['Area'].toString()} m²' : 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Closets', d['Closets']?.toString() ?? 'N/D'),
          _buildDetalleItem('Estudio', _formatBoolean(d['Estudio'])),
          _buildDetalleItem('Sala', _formatBoolean(d['Sala'])),
          _buildDetalleItem('Comedor', _formatBoolean(d['Comedor'])),
          _buildDetalleItem('Cocina', d['Cocina']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Zona lavandería', _formatBoolean(d['Zona_lavanderia'])),
          _buildDetalleItem('Depósito', _formatBoolean(d['Deposito'])),
          _buildDetalleItem('Descripción adicional', d['Descripcion_adicional']?.toString() ?? 'N/D'),
        ],
      );
    } else {
      return _buildTextMuted('No hay información de división disponible');
    }
  }

  Widget _buildAcercaEdificacion(Map a) {
    if (a.isNotEmpty) {
      return Column(
        children: [
          _buildDetalleItem('Acerca de la Edificación', a['AcercaDeLaEdificacion']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Estrato', a['Estrato']?.toString() ?? 'N/D'),
          _buildDetalleItem('Tipo construcción', a['Tipo_construccion']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Año construcción', a['Anio_construccion']?.toString() ?? 'N/D'),
          _buildDetalleItem('Estado conservación', a['Estado_conservacion']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Zonas comunes', _formatBoolean(a['Zona_comun'])),
          _buildDetalleItem('Descripción adicional', a['Descripcion_adicional']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
        ],
      );
    } else {
      return _buildTextMuted('No hay información de edificación disponible');
    }
  }

  Widget _buildTipoEdificacion(Map tipo) {
    if (tipo.isNotEmpty) {
      return Column(
        children: [
          if (tipo['Tipo_edificacion_categoria'] != null)
            _buildDetalleItem('Categoría', tipo['Tipo_edificacion_categoria'].toString()), // ✅ CONVERTIR A STRING
          if (tipo['Tipo_edificacion_descripcion'] != null)
            _buildDetalleItem('Descripción', tipo['Tipo_edificacion_descripcion'].toString()), // ✅ CONVERTIR A STRING
          if (tipo['Tipo_edificacion_niveles'] != null)
            _buildDetalleItem('Niveles', tipo['Tipo_edificacion_niveles'].toString()),
        ],
      );
    } else {
      return _buildTextMuted('No hay información de tipo de edificación disponible');
    }
  }

  Widget _buildOtrasCaracteristicas(Map o) {
    if (o.isNotEmpty) {
      return Column(
        children: [
          _buildDetalleItem('Descripción características', o['Caracteristicas_descripcion']?.toString() ?? 'N/D'), // ✅ CONVERTIR A STRING
          _buildDetalleItem('Tipo inmueble', o['Tipo_inmueble']?.toString() ?? 'N/D'),
          _buildDetalleItem('Amoblado', _formatBoolean(o['Amoblado'])),
          _buildDetalleItem('Mascotas permitidas', _formatBoolean(o['Mascotas_permitidas'])),
          _buildDetalleItem('Gas', _formatBoolean(o['Gas'])),
          _buildDetalleItem('Lavandería', _formatBoolean(o['Lavanderia'])),
          _buildDetalleItem('Piso', o['Piso']?.toString() ?? 'N/D'),
          _buildDetalleItem('Depósito', o['Deposito']?.toString() ?? 'N/D'),
          _buildDetalleItem('Descripción adicional', o['Descripcion_adicional']?.toString() ?? 'N/D'),
        ],
      );
    } else {
      return _buildTextMuted('No hay otras características disponibles');
    }
  }

  Widget _buildAsignacion(Map asignacion) {
    if (asignacion.isNotEmpty) {
      return Column(
        children: [
          if (asignacion['Parqueaderos_asignados'] != null)
            _buildDetalleItem('Parqueaderos asignados', _formatArray(asignacion['Parqueaderos_asignados'])),
          if (asignacion['Organizacion_parqueadero_FK'] != null)
            _buildDetalleItem('Organización parqueadero FK', asignacion['Organizacion_parqueadero_FK'].toString()),
          if (asignacion['Disponible'] != null)
            _buildDetalleItem('Disponible', asignacion['Disponible'].toString()),
          if (asignacion['Descripcion'] != null)
            _buildDetalleItem('Descripción', asignacion['Descripcion'].toString()),
        ],
      );
    } else {
      return _buildTextMuted('No hay información de asignación disponible');
    }
  }

  Widget _buildOrganizacionParqueadero(Map orgParqueadero) {
    if (orgParqueadero.isNotEmpty) {
      return Column(
        children: [
          if (orgParqueadero['Tipo_parqueadero'] != null)
            _buildDetalleItem('Tipo parqueadero', orgParqueadero['Tipo_parqueadero'].toString()),
          if (orgParqueadero['Cantidad'] != null)
            _buildDetalleItem('Cantidad', orgParqueadero['Cantidad'].toString()),
          if (orgParqueadero['Cubierto'] != null)
            _buildDetalleItem('Cubierto', _formatBoolean(orgParqueadero['Cubierto'])),
          if (orgParqueadero['Disponible'] != null)
            _buildDetalleItem('Disponible', _formatBoolean(orgParqueadero['Disponible'])),
        ],
      );
    } else {
      return _buildTextMuted('No hay información de organización de parqueadero disponible');
    }
  }

  // ✅ UTILIDADES EXACTAMENTE IGUAL QUE EN TU WEB
  String _formatNumber(dynamic number) {
    try {
      // ✅ MANEJAR TANTO INT COMO STRING
      late final int num;
      
      if (number is int) {
        num = number;
      } else if (number is String) {
        num = int.parse(number);
      } else {
        return number?.toString() ?? '0';
      }
      
      return num.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      );
    } catch (e) {
      return number?.toString() ?? '0';
    }
  }

  String _formatBoolean(dynamic value) {
    if (value == null) return 'N/D';
    if (value == 1 || value == '1' || value == 'Si' || value == true) {
      return 'Sí';
    }
    return 'No';
  }

  String _formatArray(dynamic value) {
    if (value == null) return 'N/D';
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }

  void _shareInmueble(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de compartir próximamente'),
        backgroundColor: Color(0xFF1C56A7),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}