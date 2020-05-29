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

import 'package:flutter/widgets.dart';
import 'package:maps/maps.dart';
import 'package:meta/meta.dart';

import 'google_maps_impl_default.dart'
    if (dart.library.html) 'google_maps_impl_browser.dart';
import 'internal/iframe.dart';
import 'internal/static.dart';

void _checkApiKey(String apiKey) {
  if (apiKey == null) {
    throw StateError('Google Maps API key is null');
  }
}

/// Enables [MapWidget] to use [Google Maps Javascript API](https://developers.google.com/maps/documentation/javascript/tutorial).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const GoogleMapsIframeAdapter();
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class GoogleMapsIframeAdapter extends MapAdapter {
  final String apiKey;

  const GoogleMapsIframeAdapter({@required this.apiKey})
      : assert(apiKey != null);

  @override
  String get productName => 'Google Maps';

  @override
  Widget buildMapWidget(MapWidget mapWidget) {
    _checkApiKey(apiKey);

    // Base URL
    final sb = StringBuffer();
    sb.write('https://www.google.com/maps/embed/v1/search');

    // Query or GeoPoint
    final query = mapWidget.camera.query;
    final geoPoint = mapWidget.camera.geoPoint;
    if (query != null) {
      sb.write('?q=');
      sb.write(Uri.encodeQueryComponent(query));
    } else if (geoPoint != null) {
      sb.write('?q=');
      sb.write(Uri.encodeQueryComponent(geoPoint.latitude.toString()));
      sb.write(',');
      sb.write(Uri.encodeQueryComponent(geoPoint.longitude.toString()));
    } else {
      throw ArgumentError('Missing query or geoPoint');
    }

    // Zoom
    sb.write('&zoom=');
    sb.write(mapWidget.camera.zoom);

    // API key
    sb.write('&key=');
    sb.write(Uri.encodeQueryComponent(apiKey));

    return buildIframeMapWidget(
      mapWidget: mapWidget,
      mapAdapterClassName: 'GoogleMapsIframeApi',
      src: sb.toString(),
    );
  }
}

/// Enables [MapWidget] to use [Google Maps Javascript API](https://developers.google.com/maps/documentation/javascript/tutorial).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const GoogleMapsJsAdapter(apiKey: 'YOUR API KEY');
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class GoogleMapsJsAdapter extends MapAdapter {
  final String apiKey;

  const GoogleMapsJsAdapter({@required this.apiKey}) : assert(apiKey != null);

  @override
  String get productName => 'Google Maps';

  @override
  Widget buildMapWidget(MapWidget mapWidget) {
    _checkApiKey(apiKey);
    return buildGoogleMapsJs(
      this,
      mapWidget,
    );
  }
}

/// Enables [MapWidget] to use [Google Maps Android SDK](https://developers.google.com/maps/documentation/android-sdk/intro)
/// and [Google Maps iOS SDK](https://developers.google.com/maps/documentation/ios-sdk/intro).
///
/// ## Getting started
/// You need to set API keys by following instructions by
/// [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) (the
/// official plugin by Google that this package uses).
///
/// In summary:
///   * For Android, you need to edit `android/app/src/main/AndroidManifest.xml`.
///   * For iOS, you need to edit one of the following:
///     * `ios/Runner/AppDelegate.swift` (if your Flutter project uses Swift)
///     * `ios/Runner/AppDelegate.m` (if your Flutter project uses Objective-C)
class GoogleMapsNativeAdapter extends MapAdapter {
  const GoogleMapsNativeAdapter();

  @override
  String get productName => 'Google Maps';

  @override
  Widget buildMapWidget(MapWidget mapWidget) {
    return buildGoogleMapsNative(this, mapWidget);
  }
}

/// Enables [MapWidget] to use [Google Maps Static API](https://developers.google.com/maps/documentation/maps-static/intro).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const GoogleMapsStaticAdapter(apiKey: 'YOUR API KEY');
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class GoogleMapsStaticAdapter extends MapAdapter {
  final String apiKey;

  const GoogleMapsStaticAdapter({@required this.apiKey})
      : assert(apiKey != null);

  @override
  String get productName => 'Google Maps';

  @override
  Widget buildMapWidget(MapWidget mapWidget) {
    _checkApiKey(apiKey);
    final camera = mapWidget.camera;

    // Base URL
    final sb = StringBuffer();
    sb.write('https://maps.googleapis.com/maps/api/staticmap');

    // Size
    sb.write('?size=');
    sb.write(mapWidget.size.width.toInt());
    sb.write('x');
    sb.write(mapWidget.size.height.toInt());

    // GeoPoint
    if (camera.geoPoint != null) {
      sb.write('&center=');
      sb.write(Uri.encodeQueryComponent(camera.geoPoint.latitude.toString()));
      sb.write(',');
      sb.write(Uri.encodeQueryComponent(camera.geoPoint.longitude.toString()));
    }

    // Zoom
    final zoom = camera.zoom;
    if (zoom != null) {
      sb.write('&zoom=');
      sb.write(zoom.toInt().clamp(1, 20));
    }

    // API key
    sb.write('&key=');
    sb.write(Uri.encodeQueryComponent(apiKey));
    return buildStaticMapWidget(
      mapWidget: mapWidget,
      mapAdapterClassName: 'GoogleMapsStaticApi',
      src: sb.toString(),
    );
  }
}
