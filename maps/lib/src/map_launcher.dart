// Copyright 2020 Gohilla Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:maps/maps.dart';
import 'package:meta/meta.dart';

import 'map_launcher_impl_default.dart'
    if (dart.library.html) 'map_launcher_impl_browser.dart' as impl;

/// Opens a map in Apple Maps (native application).
///
/// ## Supported parameters
///   * `query`
///   * `geoPoint`
///   * `zoom`
///
/// ## Example
/// ```
/// import 'package:maps/maps.dart';
///
/// Future<void> main() {
///   final launcher = const AppleMapsLauncher();
///   await launcher.launch(
///     geoPoint:GeoPoint(0.0, 0.0),
///   );
/// }
/// ```
class AppleMapsLauncher extends MapLauncher {
  const AppleMapsLauncher();

  @override
  Future<String> buildUrl({
    String query,
    GeoPoint geoPoint,
    Zoom zoom,
    MapType mapType,
  }) async {
    final sb = StringBuffer();
    sb.write('http://maps.apple.com/?');

    // Camera must have either query or geoPoint
    query ??= '';
    if (query.isNotEmpty) {
      sb.write('?q=');
      sb.write(Uri.encodeQueryComponent(query));
      if (geoPoint != null) {
        sb.write('&sll=');
        sb.write(geoPoint.latitude.toString());
        sb.write(',');
        sb.write(geoPoint.longitude.toString());
      }
    } else if (geoPoint != null) {
      sb.write('?ll=');
      sb.write(geoPoint.latitude.toString());
      sb.write(',');
      sb.write(geoPoint.longitude.toString());
    } else {
      return null;
    }

    // Type
    final appleMapsType = {
      MapType.normal: 'm',
      MapType.transit: 'r',
      MapType.satellite: 'k',
      MapType.terrain: 'k',
      MapType.hybrid: 'h',
    }[mapType ?? MapType.normal];
    sb.write('&t=');
    sb.write(appleMapsType);

    // Zoom
    if (zoom != null) {
      sb.write('&z=');
      sb.write(zoom.value.toInt().clamp(2, 20));
    }

    return sb.toString();
  }
}

/// Opens a map in Bing Maps (website)
///
/// ## Supported parameters
///   * `query`
///   * `geoPoint`
///   * `zoom`
///
/// ## Example
/// ```
/// import 'package:maps/maps.dart';
///
/// Future<void> main() {
///   final launcher = const BingMapsLauncher();
///   await launcher.launch(
///     geoPoint:GeoPoint(0.0, 0.0),
///   );
/// }
/// ```
class BingMapsApp extends MapLauncher {
  const BingMapsApp();

  @override
  Future<String> buildUrl({
    String query,
    GeoPoint geoPoint,
    Zoom zoom,
    MapType mapType,
  }) async {
    final sb = StringBuffer();
    sb.write('https://www.bing.com/maps');
    query ??= '';
    if (query.isNotEmpty && geoPoint == null) {
      sb.write('?where1=');
      sb.write(Uri.encodeQueryComponent(query));
    } else if (geoPoint != null) {
      sb.write('?cp=');
      sb.write(geoPoint.latitude.toString());
      sb.write('~');
      sb.write(geoPoint.longitude.toString());
    } else {
      return null;
    }

    // Zoom
    if (zoom != null) {
      sb.write('&lvl=');
      sb.write(zoom.value.toInt().clamp(2, 20));
    }

    // Style
    final style = {
      MapType.satellite: 'h',
      MapType.hybrid: 'h',
    }[mapType];
    if (style != null) {
      sb.write('&style=');
      sb.write(style);
    }

    return sb.toString();
  }
}

/// Opens a map in Google Maps (native application or website).
///
/// ## Supported parameters
///   * `query`
///   * `geoPoint`
///   * `zoom`
///
/// ## Example
/// ```
/// import 'package:maps/maps.dart';
///
/// Future<void> main() {
///   final launcher = const GoogleMapsLauncher();
///   await launcher.launch(
///     geoPoint:GeoPoint(0.0, 0.0),
///   );
/// }
/// ```
class GoogleMapsLauncher extends MapLauncher {
  const GoogleMapsLauncher();

  @override
  Future<String> buildUrl({
    String query,
    GeoPoint geoPoint,
    Zoom zoom,
    MapType mapType,
  }) async {
    // Camera must have either query or geoPoint
    query ??= '';
    if (query.isNotEmpty && geoPoint == null) {
      final sb = StringBuffer();
      sb.write('https://www.google.com/maps/search/?api=1');
      sb.write('&query=');
      sb.write(Uri.encodeQueryComponent(query));
      return sb.toString();
    }

    final sb = StringBuffer();
    sb.write('https://www.google.com/maps/@?api=1&map_action=map');
    if (geoPoint != null) {
      sb.write('&center=');
      sb.write(geoPoint.latitude);
      sb.write(',');
      sb.write(geoPoint.longitude);
    }

    // Zoom
    if (zoom != null) {
      sb.write('&zoom=');
      sb.write(zoom.value.toInt().clamp(1, 20));
    }

    final layer = {
      MapType.traffic: 'traffic',
      MapType.transit: 'transit',
      MapType.bicycling: 'bicycling',
    }[mapType];
    if (layer != null) {
      sb.write('&layer=');
      sb.write(layer);
    }

    return sb.toString();
  }
}

/// Open a map in an external map application.
///
/// ## Available implementations
///   * [AppleMapsLauncher]
///   * [BingMapsLauncher]
///   * [GoogleMapsLauncher]
///
/// ## Example
/// ```
/// import 'package:maps/maps.dart';
///
/// Future<void> main() {
///   final launcher = MapLauncher.defaultInstance;
///   await launcher.launch(
///     geoPoint:GeoPoint(0.0, 0.0),
///   );
/// }
/// ```
abstract class MapLauncher {
  /// Default map application launcher.
  static MapLauncher defaultInstance = const MapLauncher.platformSpecific(
    ios: [AppleMapsLauncher()],
    macos: [AppleMapsLauncher(), GoogleMapsLauncher()],
    otherwise: [GoogleMapsLauncher()],
  );

  const MapLauncher();

  /// Allows you to specify launcher by platform.
  const factory MapLauncher.platformSpecific({
    List<MapLauncher> android,
    List<MapLauncher> ios,
    List<MapLauncher> macos,
    List<MapLauncher> otherwise,
  }) = _PlatformSpecificExternalMapApp;

  /// Builds URL where the map is.
  Future<String> buildUrl({
    String query,
    Zoom zoom,
    GeoPoint geoPoint,
    MapType mapType,
  });

  /// Inquires whether the map can be launched.
  Future<bool> canLaunch({
    String query,
    GeoPoint geoPoint,
    Zoom zoom,
    MapType mapType,
  }) {
    return buildUrl(
      query: query,
      geoPoint: geoPoint,
      zoom: zoom,
      mapType: mapType,
    ).then((url) {
      return impl.canLaunch(url);
    });
  }

  /// Launches map.
  ///
  /// ## Example
  /// ```
  /// import 'package:maps/maps.dart';
  ///
  /// Future<void> main() {
  ///   final launcher = MapLauncher.defaultInstance;
  ///   await launcher.launch(
  ///     geoPoint:GeoPoint(0.0, 0.0),
  ///   );
  /// }
  /// ```
  Future<bool> launch({
    String query,
    GeoPoint geoPoint,
    int zoom,
    MapType mapType,
  }) {
    return buildUrl(
      query: query,
      geoPoint: geoPoint,
      mapType: mapType,
    ).then((url) {
      return impl.launch(url);
    });
  }
}

class _PlatformSpecificExternalMapApp extends MapLauncher {
  final List<MapLauncher> android;
  final List<MapLauncher> ios;
  final List<MapLauncher> macos;
  final List<MapLauncher> otherwise;

  const _PlatformSpecificExternalMapApp({
    this.android,
    this.ios,
    this.macos,
    @required this.otherwise,
  }) : assert(otherwise != null);

  @override
  Future<String> buildUrl({
    String query,
    GeoPoint geoPoint,
    Zoom zoom,
    MapType mapType,
  }) async {
    for (var item in _getList()) {
      final url = await item.buildUrl(
        query: query,
        geoPoint: geoPoint,
        zoom: zoom,
        mapType: mapType,
      );
      if (await impl.canLaunch(url)) {
        return url;
      }
    }
    return null;
  }

  List<MapLauncher> _getList() {
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
