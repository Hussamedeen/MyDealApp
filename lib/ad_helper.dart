import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3152805428748942/3350039103';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3152805428748942/3299397209';
    }

    throw new UnsupportedError("Unsupported platform");
  }


}