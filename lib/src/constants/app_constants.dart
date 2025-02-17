import 'package:collection/collection.dart';

const String appName = "TempAppName";

const List<String> countriesAvailable = ['VN', 'BE', 'AU'];

enum CryptoNetwork {
  TRX,
  BSC,
  ETH,
  Unknown;

  bool get isSupported {
    switch (this) {
      case TRX: 
        return true;
      default:
        return false;
    }
  }

  String get name {
    return this.toString().split('.').last;
  }

  static CryptoNetwork fromString(String network) {
    return CryptoNetwork.values.firstWhereOrNull((e) => e.name == network) ??
        CryptoNetwork.Unknown;
  }
}
