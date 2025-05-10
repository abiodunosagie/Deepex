import 'package:connectivity_plus/connectivity_plus.dart';

class InternetUtils {
  // Check if the device has an internet connection
  static Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // Simple message based on connectivity status
  static Future<String> getConnectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return "No internet connection";
    } else if (connectivityResult == ConnectivityResult.mobile) {
      return "Connected via mobile data";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return "Connected via Wi-Fi";
    } else {
      return "Unknown connection status";
    }
  }
}
