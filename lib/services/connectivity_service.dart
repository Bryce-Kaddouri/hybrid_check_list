import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hybrid_check_list/services/secure_storage_service.dart';

class ConnectivityService {
  Future<bool> get hasInternet async {
    var connectivityResult = await Connectivity().checkConnectivity();
    // listen to changes in connectivity
    Connectivity().onConnectivityChanged.listen((result) {
      SecureStorageService().writeSecureData(
          'connectivity',
          result == ConnectivityResult.wifi ||
                  result == ConnectivityResult.mobile
              ? 'connected'
              : 'disconnected');
    });
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
}
