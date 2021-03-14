import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class AdState{
  Future<InitializationStatus> initialization ;
  AdState(this.initialization);
    String get bannerAdUnitId => Platform.isAndroid
      ?'ca-app-pub-3152805428748942/3350039103'
      :'ca-app-pub-3152805428748942/3299397209';
  AdListener get adListener => _adListener;
  AdListener _adListener = AdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an ad is in the process of leaving the application.
    onApplicationExit: (Ad ad) => print('Left application.'),
  );
}