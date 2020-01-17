import 'dart:io';

import 'package:ads/ads.dart';

class AppAds {
  static Ads ads;

  static final String _appId = Platform.isAndroid
      ? 'ca-app-pub-1611091195560104~3590637364'
      : 'ca-app-pub-3940256099942544~1458002511';

  static final String _videoUnitId = Platform.isAndroid
      ? 'ca-app-pub-1611091195560104/1020314344'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Call this static function in your State object's initState() function.
  static void init() => ads ??= Ads(
        _appId,
        videoUnitId: _videoUnitId,
        // testing: true,
        testing: false,
      );

  /// Remember to call this in the State object's dispose() function.
  static void dispose() => ads?.dispose();
}
