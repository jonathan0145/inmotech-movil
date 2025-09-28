import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ConnectionStatusWidget extends StatefulWidget {
  const ConnectionStatusWidget({Key? key}) : super(key: key);

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  bool _isConnected = false;
  bool _isChecking = true;
  String _currentUrl = '';

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() => _isChecking = true);
    
    try {
      final apiService = ApiService.instance;
      _currentUrl = apiService.currentBaseUrl;
      _isConnected = await apiService.isConnected();
    } catch (e) {
      _isConnected = false;
    }
    
    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Verificando...', style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    final isLocalhost = _currentUrl.contains('localhost');
    final modeText = isLocalhost ? 'Desarrollo' : 'Producción';
    final modeIcon = isLocalhost ? Icons.build : Icons.cloud;
    
    return GestureDetector(
      onTap: _checkConnection,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isConnected 
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isConnected 
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isConnected ? Icons.wifi : Icons.wifi_off,
              size: 16,
              color: _isConnected ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 4),
            Icon(
              modeIcon,
              size: 14,
              color: isLocalhost ? Colors.blue : Colors.purple,
            ),
            const SizedBox(width: 6),
            Text(
              '$modeText ${_isConnected ? '✓' : '✗'}',
              style: TextStyle(
                fontSize: 12,
                color: _isConnected ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}