import 'package:maps/maps.dart';
import 'package:meta/meta.dart';

import 'map_app_launcher_impl_default.dart'
    if (dart.library.html) 'map_app_launcher_impl_browser.dart' as impl;

/// Launches external map applications.
abstract class MapAppLauncher {
  /// Default map application launcher.
  static MapAppLauncher defaultInstance = const MapAppLauncher.platformSpecific(
    ios: [appleMaps],
    macos: [appleMaps, googleMaps],
    otherwise: [googleMaps],
  );

  /// Launcher for Apple Maps.
  static const MapAppLauncher appleMaps = _AppleMapApp();

  /// Launcher for Bing Maps.
  static const MapAppLauncher bingMaps = _BingMapsApp();

  /// Launcher for Google Maps.
  static const MapAppLauncher googleMaps = _GoogleMapsApp();

  const MapAppLauncher();

  const factory MapAppLauncher.platformSpecific({
    List<MapAppLauncher> android,
    List<MapAppLauncher> ios,
    List<MapAppLauncher> macos,
    List<MapAppLauncher> otherwise,
  }) = _PlatformSpecificExternalMapApp;

  Future<String> buildUrl({@required MapCamera camera, MapType mapType});

  Future<bool> canLaunch({@required MapCamera camera, MapType mapType}) {
    return buildUrl(camera: camera, mapType: mapType).then((url) {
      return impl.canLaunch(url);
    });
  }

  Future<bool> launch({@required MapCamera camera, MapType mapType}) {
    return buildUrl(camera: camera, mapType: mapType).then((url) {
      return impl.launch(url);
    });
  }
}

class _AppleMapApp extends MapAppLauncher {
  const _AppleMapApp();

  @override
  Future<String> buildUrl({@required MapCamera camera, MapType mapType}) async {
    ArgumentError.checkNotNull(camera, 'camera');

    final sb = StringBuffer();
    sb.write('http://maps.apple.com/?');

    // Camera must have either query or geoPoint
    final query = camera.query;
    final geoPoint = camera.geoPoint;
    if (query != null) {
      sb.write('?q=');
      sb.write(Uri.encodeQueryComponent(query));
    } else if (geoPoint != null) {
      sb.write('?ll=');
      sb.write(Uri.encodeQueryComponent(geoPoint.latitude.toString()));
      sb.write(',');
      sb.write(Uri.encodeQueryComponent(geoPoint.longitude.toString()));
    } else {
      return null;
    }

    // Zoom
    sb.write('&z=');
    sb.write(Uri.encodeQueryComponent(camera.zoom.toString()));

    return sb.toString();
  }
}

class _BingMapsApp extends MapAppLauncher {
  const _BingMapsApp();

  @override
  Future<String> buildUrl({MapCamera camera, MapType mapType}) async {
    ArgumentError.checkNotNull(camera, 'camera');

    final sb = StringBuffer();
    sb.write('https://www.bing.com/maps');
    final query = camera.query;
    final geoPoint = camera.geoPoint;
    if (query != null) {
      sb.write('?where1=');
      sb.write(Uri.encodeQueryComponent(query));
    } else if (geoPoint != null) {
      sb.write('?cp=');
      sb.write(Uri.encodeQueryComponent(geoPoint.latitude.toString()));
      sb.write('~');
      sb.write(Uri.encodeQueryComponent(geoPoint.longitude.toString()));
    } else {
      return null;
    }

    // Zoom
    sb.write('&lvl=');
    sb.write(Uri.encodeQueryComponent(camera.zoom.toString()));

    return sb.toString();
  }
}

class _GoogleMapsApp extends MapAppLauncher {
  const _GoogleMapsApp();

  @override
  Future<String> buildUrl({MapCamera camera, MapType mapType}) async {
    ArgumentError.checkNotNull(camera, 'camera');

    final sb = StringBuffer();
    sb.write('https://www.google.com/maps/search/?api=1');

    // Camera must have either query or geoPoint
    final query = camera.query;
    final geoPoint = camera.geoPoint;
    if (query != null) {
      sb.write('?query=');
      sb.write(Uri.encodeQueryComponent(query));
    } else if (geoPoint != null) {
      sb.write('?map_action=map');
      sb.write('&center=');
      sb.write(Uri.encodeQueryComponent(geoPoint.latitude.toString()));
      sb.write(',');
      sb.write(Uri.encodeQueryComponent(geoPoint.longitude.toString()));
    } else {
      return null;
    }

    // Zoom
    sb.write('&zoom=');
    sb.write(Uri.encodeQueryComponent(camera.zoom.toString()));

    return sb.toString();
  }
}

class _PlatformSpecificExternalMapApp extends MapAppLauncher {
  final List<MapAppLauncher> android;
  final List<MapAppLauncher> ios;
  final List<MapAppLauncher> macos;
  final List<MapAppLauncher> otherwise;

  const _PlatformSpecificExternalMapApp({
    this.android,
    this.ios,
    this.macos,
    @required this.otherwise,
  }) : assert(otherwise != null);

  @override
  Future<String> buildUrl({@required MapCamera camera, MapType mapType}) async {
    for (var item in _getList()) {
      final url = await item.buildUrl(camera: camera, mapType: mapType);
      if (await impl.canLaunch(url)) {
        return url;
      }
    }
    return null;
  }

  List<MapAppLauncher> _getList() {
    if (impl.isAndroid) {
      return android;
    } else if (impl.isIOS) {
      return ios;
    } else if (impl.isMacOS) {
      return macos;
    } else {
      return otherwise;
    }
  }
}
