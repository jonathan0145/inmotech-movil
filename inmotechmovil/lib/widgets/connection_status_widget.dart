import 'package:flutter/material.dart';
import 'package:inmotechmovil/config/api_config.dart' as config;
import 'package:inmotechmovil/services/api_service.dart';

class ConnectionStatusWidget extends StatefulWidget {
  const ConnectionStatusWidget({Key? key}) : super(key: key);

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  bool _isConnected = false;
  bool _isChecking = true;
  String _currentUrl = '';
  String _connectionType = '';

  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService.instance;
    _loadConnectionStatus();
  }

  Future<void> _loadConnectionStatus() async {
    setState(() => _isChecking = true);

    try {
      await _apiService.initialize();
      _currentUrl = _apiService.currentBaseUrl;
      _connectionType = config.ApiConfig.getConnectionType(_currentUrl);
      _isConnected = await _apiService.isConnected();
    } catch (e) {
      _isConnected = false;
      _connectionType = '❌ Error';
    }

    setState(() => _isChecking = false);
  }

  Future<void> _reconnect() async {
    await _apiService.reconnect();
    await _loadConnectionStatus();
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

    return GestureDetector(
      onTap: _reconnect,
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
            const SizedBox(width: 6),
            Text(
              '$_connectionType ${_isConnected ? '✓' : '✗'}',
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