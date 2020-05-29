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

import 'bing_maps_impl_default.dart'
    if (dart.library.html) 'bing_maps_impl_browser.dart';
import 'internal/iframe.dart';
import 'internal/static.dart';

/// Enables [MapWidget] to use [Bing Maps Custom Map URLs](https://docs.microsoft.com/en-us/bingmaps/articles/create-a-custom-map-url).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const BingMapsIframeAdapter(
///     apiKey: 'YOUR API KEY',
///   );
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class BingMapsIframeAdapter extends MapAdapter {
  const BingMapsIframeAdapter();

  @override
  String get productName => 'Bing Maps';

  @override
  Widget buildMapWidget(MapWidget widget) {
    final sb = StringBuffer();
    final camera = widget.camera;
    final width = widget.size.width.toInt();
    final height = widget.size.height.toInt();

    // Base URL
    sb.write('https://www.bing.com/maps/embed');

    // Size
    sb.write('?h=');
    sb.write(height);
    sb.write('&w=');
    sb.write(width);

    // GeoPoint
    sb.write('&cp=');
    sb.write(camera.geoPoint.latitude.toString());
    sb.write('~');
    sb.write(camera.geoPoint.longitude.toString());

    // Zoom
    sb.write('&lvl=');
    sb.write(camera.zoom);

    // Other
    sb.write('&typ=d&sty=r&src=SHELL&FORM=MBEDV8');
    return buildIframeMapWidget(
      mapWidget: widget,
      mapAdapterClassName: 'BingMapsIframeApi',
      src: sb.toString(),
    );
  }
}

/// Enables [MapWidget] to use [Bing Maps Javascript API](https://docs.microsoft.com/en-us/bingmaps/v8-web-control/).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const BingMapsJsAdapter(
///     apiKey: 'YOUR API KEY',
///   );
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class BingMapsJsAdapter extends MapAdapter {
  final String apiKey;

  const BingMapsJsAdapter({@required this.apiKey}) : assert(apiKey != null);

  @override
  String get productName => 'Bing Maps';

  @override
  Widget buildMapWidget(MapWidget widget) {
    return buildBingMapsJs(this, widget);
  }
}

/// Enables [MapWidget] to use [Bing Maps REST API for static maps](https://docs.microsoft.com/en-us/bingmaps/rest-services/imagery/get-a-static-map).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const BingMapsStaticAdapter(
///     apiKey: 'YOUR API KEY',
///   );
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
///
/// It's also possible to specify map engine for individual [MapWidget]
/// instances:
/// ```
/// const widget = MapWidget(
///   engine: BingMapsStaticAdapter(
///     apiKey: 'YOUR API KEY',
///   ),
///   query: 'Paris',
/// );
/// ```
class BingMapsStaticAdapter extends MapAdapter {
  final String apiKey;

  const BingMapsStaticAdapter({
    @required this.apiKey,
  }) : assert(apiKey != null);

  @override
  String get productName => 'Bing Maps';

  @override
  Widget buildMapWidget(MapWidget widget) {
    final camera = widget.camera;
    final sb = StringBuffer();

    // Base URL
    sb.write(
      'https://dev.virtualearth.net/REST/v1/Imagery/Map/imagerySet/centerPoint/zoomLevel',
    );

    // Size
    sb.write('?size=');
    sb.write(widget.size.width.toInt());
    sb.write(',');
    sb.write(widget.size.height.toInt());

    // Query o GeoPoint
    if (camera.geoPoint != null) {
      sb.write('&centerPoint=');
      sb.write(Uri.encodeQueryComponent(camera.geoPoint.latitude.toString()));
      sb.write(',');
      sb.write(Uri.encodeQueryComponent(camera.geoPoint.longitude.toString()));
    } else if (camera.query != null) {
      sb.write('&query=');
      sb.write(Uri.encodeQueryComponent(camera.query));
    }

    // Zoom
    sb.write('&lvl=');
    sb.write(camera.zoom.toInt().clamp(0, 20));

    // API key
    sb.write('&key=');
    sb.write(Uri.encodeQueryComponent(apiKey));

    return buildStaticMapWidget(
      mapWidget: widget,
      mapAdapterClassName: 'BingMapsStaticApi',
      src: sb.toString(),
    );
  }
}
