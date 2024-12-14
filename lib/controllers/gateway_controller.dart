import 'package:flutter/foundation.dart';

class GatewayController with ChangeNotifier {
  GatewayController._();
  static final GatewayController _instance = GatewayController._();
  factory GatewayController() => _instance;

  String _gatewayUrl = "";

  String get gatewayUrl => _gatewayUrl;
  void setGatewayUrl(String gatewayUrl) {
    _gatewayUrl = gatewayUrl;
    notifyListeners();
  }

}
