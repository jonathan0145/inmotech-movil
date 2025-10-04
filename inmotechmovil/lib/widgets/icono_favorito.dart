import 'package:flutter/material.dart';
import '../services/inmueble_service.dart';

class IconoFavorito extends StatefulWidget {
  final int inmuebleId;
  final int? userId;
  final bool esFavoritoInicial;
  final double size;
  final Function(bool)? onFavoritoChanged;

  const IconoFavorito({
    Key? key,
    required this.inmuebleId,
    required this.userId,
    this.esFavoritoInicial = false,
    this.size = 24.0,
    this.onFavoritoChanged,
  }) : super(key: key);

  @override
  State<IconoFavorito> createState() => _IconoFavoritoState();
}

class _IconoFavoritoState extends State<IconoFavorito>
    with SingleTickerProviderStateMixin {
  final InmuebleService _inmuebleService = InmuebleService();
  bool _esFavorito = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _esFavorito = widget.esFavoritoInicial;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorito() async {
    if (_isLoading || widget.userId == null) return;

    setState(() => _isLoading = true);

    try {
      // ✅ ANIMACIÓN AL TOCAR
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      final nuevoEstado = await _inmuebleService.toggleFavorito(
        widget.userId!,
        widget.inmuebleId,
      );

      setState(() {
        _esFavorito = nuevoEstado;
        _isLoading = false;
      });

      // ✅ CALLBACK PARA NOTIFICAR CAMBIO
      if (widget.onFavoritoChanged != null) {
        widget.onFavoritoChanged!(_esFavorito);
      }

      // ✅ MOSTRAR FEEDBACK
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_esFavorito 
                ? 'Agregado a favoritos' 
                : 'Removido de favoritos'),
            backgroundColor: _esFavorito 
                ? const Color(0xFF28a745) 
                : Colors.orange,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _toggleFavorito,
            child: Container(
              padding: const EdgeInsets.all(8),
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
              child: _isLoading
                  ? SizedBox(
                      width: widget.size,
                      height: widget.size,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _esFavorito 
                              ? const Color(0xFFdc3545) 
                              : Colors.grey,
                        ),
                      ),
                    )
                  : Icon(
                      _esFavorito ? Icons.favorite : Icons.favorite_border,
                      color: _esFavorito 
                          ? const Color(0xFFdc3545) // Rojo igual al CSS
                          : Colors.grey,
                      size: widget.size,
                    ),
            ),
          ),
        );
      },
    );
  }
}