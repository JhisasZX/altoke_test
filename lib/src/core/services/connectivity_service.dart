import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  /// Verifica si hay conexión a internet
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();

      // Verificar si hay algún tipo de conectividad
      return connectivityResults.isNotEmpty &&
          !connectivityResults.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Stream de cambios en la conectividad
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}
