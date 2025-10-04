import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/inmueble_service.dart';
import '../models/inmueble.dart';
import 'detalle_inmueble_page.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({Key? key}) : super(key: key);

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> with TickerProviderStateMixin {
  final InmuebleService _inmuebleService = InmuebleService();
  List<Map<String, dynamic>> _favoritos = [];
  bool _isLoading = false;
  int? _currentUserId;
  late AnimationController _headerAnimationController;
  late AnimationController _gridAnimationController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeAndLoadFavoritos();
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _gridAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeAndLoadFavoritos() async {
    await _getCurrentUserId();
    if (_currentUserId != null) {
      await _loadFavoritos();
    }
  }

  Future<void> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getInt('user_id') ?? 
                     prefs.getInt('Platform_user_id') ?? 
                     prefs.getInt('userId');
      
      print('🔍 Current User ID obtenido: $_currentUserId');
    } catch (e) {
      print('❌ Error obteniendo user ID: $e');
    }
  }

  Future<void> _loadFavoritos() async {
    if (_currentUserId == null) return;

    setState(() => _isLoading = true);
    
    try {
      print('❤️ Cargando favoritos para usuario: $_currentUserId');
      
      final favoritos = await _inmuebleService.getFavoritosByUserId(_currentUserId!);
      
      setState(() {
        _favoritos = favoritos;
        _isLoading = false;
      });

      // ✅ ANIMAR DESPUÉS DE CARGAR
      _headerAnimationController.forward();
      _gridAnimationController.forward();
      
    } catch (e) {
      print('❌ Error cargando favoritos: $e');
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error cargando favoritos: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _currentUserId == null
          ? _buildErrorState()
          : _isLoading
              ? _buildLoadingState()
              : _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      slivers: [
        // ✅ HEADER ESTILIZADO IGUAL AL WEB
        SliverToBoxAdapter(
          child: _buildFavoritosHeader(),
        ),
        
        // ✅ CONTENIDO DE FAVORITOS
        if (_favoritos.isEmpty)
          SliverToBoxAdapter(
            child: _buildEmptyState(),
          )
        else
          SliverToBoxAdapter(
            child: _buildFavoritosSection(),
          ),
      ],
    );
  }

  // ✅ HEADER IGUAL AL CSS DE LA PLATAFORMA WEB
  Widget _buildFavoritosHeader() {
    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _headerAnimationController.value)),
          child: Opacity(
            opacity: _headerAnimationController.value,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667eea), // Igual al CSS
                    Color(0xFF764ba2), // Igual al CSS
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // ✅ PATRÓN DE PUNTOS (igual al CSS)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DotPatternPainter(),
                    ),
                  ),
                  
                  // ✅ CONTENIDO PRINCIPAL
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ✅ SECCIÓN DEL TÍTULO
                          Expanded(
                            child: Row(
                              children: [
                                // ✅ ÍCONO DE CORAZÓN CON ANIMACIÓN
                                TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0.8, end: 1.2),
                                  duration: const Duration(seconds: 3),
                                  builder: (context, scale, child) {
                                    return Transform.scale(
                                      scale: scale,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: const Icon(
                                          Icons.favorite,
                                          color: Color(0xFFff6b6b), // Color igual al CSS
                                          size: 32,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                const SizedBox(width: 16),
                                
                                // ✅ TÍTULO
                                const Expanded(
                                  child: Text(
                                    'Mis Favoritos',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // ✅ BADGE DE CONTEO (igual al CSS)
                          if (_favoritos.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_favoritos.length} inmueble${_favoritos.length != 1 ? 's' : ''} guardado${_favoritos.length != 1 ? 's' : ''}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  
                  // ✅ EFECTO DE BRILLO (igual al CSS)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _headerAnimationController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: ShineEffectPainter(_headerAnimationController.value),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ));
      },
    );
  }

  // ✅ SECCIÓN DE FAVORITOS (igual al CSS)
  Widget _buildFavoritosSection() {
    return AnimatedBuilder(
      animation: _gridAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _gridAnimationController.value)),
          child: Opacity(
            opacity: _gridAnimationController.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // ✅ GLASSMORPHISM IGUAL AL CSS
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // ✅ PATRÓN DE CUADRÍCULA (igual al CSS)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPatternPainter(),
                    ),
                  ),
                  
                  // ✅ GRID DE FAVORITOS
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _favoritos.length,
                    itemBuilder: (context, index) {
                      return _buildPropertyCard(_favoritos[index], index);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ PROPERTY CARD IGUAL AL COMPONENTE WEB
  Widget _buildPropertyCard(Map<String, dynamic> inmuebleData, int index) {
    final valor = inmuebleData['Valor']?.toString() ?? '0';
    final area = inmuebleData['Area']?.toString() ?? 'N/D';
    final descripcion = inmuebleData['Descripcion_General'] ?? 'Sin descripción';
    final direccion = inmuebleData['Direccion']?['Direccion'] ?? 'Sin dirección';
    
    final division = inmuebleData['division'];
    final habitaciones = division?['Habitaciones']?.toString() ?? 'N/D';
    final banos = division?['Baños']?.toString() ?? 'N/D';
    
    final imagenesInmueble = inmuebleData['ImagenesInmueble'] ?? inmuebleData['imagenesInmueble'];
    final imagenUrl = imagenesInmueble is Map ? imagenesInmueble['URL'] : '';

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * animationValue),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF667eea).withOpacity(0.1),
                    const Color(0xFF764ba2).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Card(
                elevation: 0,
                color: const Color(0xFF15365F), // Igual al CSS
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () => _navigateToDetail(inmuebleData),
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ SECCIÓN DE IMAGEN
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              child: imagenUrl != null && imagenUrl.toString().isNotEmpty
                                  ? Image.network(
                                      imagenUrl.toString(),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                                    )
                                  : _buildImagePlaceholder(),
                            ),
                            
                            // ✅ OVERLAY CON PRECIO (igual al CSS)
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF28a745), // Verde igual al CSS
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  '\$${_formatPrice(valor)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            
                            // ✅ ÍCONO FAVORITO (igual al CSS)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () => _toggleFavorito(inmuebleData),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Color(0xFFdc3545), // Rojo igual al CSS
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // ✅ CONTENIDO DE LA CARD (igual al CSS)
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ DESCRIPCIÓN
                              Text(
                                descripcion.length > 50 ? '${descripcion.substring(0, 50)}...' : descripcion,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFFDFDFD), // Igual al CSS
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // ✅ UBICACIÓN
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFFdc3545), // Rojo igual al CSS
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      direccion,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF72A3D1), // Igual al CSS
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const Spacer(),
                              
                              // ✅ DETALLES (igual al CSS)
                              Container(
                                padding: const EdgeInsets.only(top: 8),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color(0xFF72A3D1),
                                      width: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildDetailItem(Icons.bed, habitaciones),
                                    _buildDetailItem(Icons.bathroom, banos),
                                    _buildDetailItem(Icons.square_foot, '${area}m²'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: const Color(0xFF72A3D1), // Igual al CSS
          size: 12,
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFFFDFDFD), // Igual al CSS
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[600],
      child: const Center(
        child: Icon(Icons.home, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 64,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No tienes inmuebles favoritos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF15365F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explora nuestros inmuebles y marca tus favoritos haciendo clic en el corazón.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
          ),
          SizedBox(height: 16),
          Text('Cargando tus favoritos...'),
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
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error de autenticación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Regresar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(Map<String, dynamic> inmuebleData) {
    try {
      final inmueble = Inmueble.fromJson(inmuebleData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalleInmueblePage(
            inmueble: inmueble,
            isOwner: false,
          ),
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Error al abrir detalles: ${e.toString()}');
    }
  }

  Future<void> _toggleFavorito(Map<String, dynamic> inmuebleData) async {
    if (_currentUserId == null) return;
    
    try {
      final inmuebleId = inmuebleData['Inmueble_id'];
      final esFavorito = await _inmuebleService.toggleFavorito(_currentUserId!, inmuebleId);
      
      if (!esFavorito) {
        setState(() {
          _favoritos.removeWhere((item) => item['Inmueble_id'] == inmuebleId);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removido de favoritos'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _formatPrice(String price) {
    try {
      final num = double.parse(price);
      if (num >= 1000000) {
        return '${(num / 1000000).toStringAsFixed(1)}M';
      } else if (num >= 1000) {
        return '${(num / 1000).toStringAsFixed(0)}K';
      }
      return num.toStringAsFixed(0);
    } catch (e) {
      return price;
    }
  }
}

// ✅ PAINTERS PARA LOS EFECTOS VISUALES (igual al CSS)
class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    const double spacing = 20.0;
    for (double x = 10; x < size.width; x += spacing) {
      for (double y = 10; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF667eea).withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const double spacing = 60.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShineEffectPainter extends CustomPainter {
  final double progress;
  
  ShineEffectPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: [0.0, progress, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(ShineEffectPainter oldDelegate) => oldDelegate.progress != progress;
}