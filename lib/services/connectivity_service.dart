import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hybrid_check_list/services/secure_storage_service.dart';

class ConnectivityService {
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void setConnected(bool isConnected) {
    _isConnected = isConnected;
  }

  Future<bool> get hasInternet async {
    var connectivityResult = await Connectivity().checkConnectivity();
    // listen to changes in connectivity
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  // stream of connectivity
  Stream<bool> get hasInternetStream async* {
    yield await hasInternet;
    yield* Connectivity().onConnectivityChanged.map((result) {
      return result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile;
    });
  }
}
