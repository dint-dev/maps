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

import 'package:database/database.dart' show GeoPoint;
import 'package:flutter/widgets.dart';
import 'package:maps/maps.dart';
import 'package:collection/collection.dart';

export 'package:database/database.dart' show GeoPoint;

class MapCamera {
  /// Optional query string such as name of place ("Eiffel Tower") or address.
  /// Not supported by all engines.
  ///
  /// Either [query] or [geoPoint] must be non-null.
  final String query;

  /// Optional geographical point.
  ///
  /// Either [query] or [geoPoint] must be non-null.
  final GeoPoint geoPoint;

  /// Zoom level.
  final double zoom;

  const MapCamera({
    this.query,
    this.geoPoint,
    this.zoom = 10,
  })  : assert(query != null || geoPoint != null),
        assert(zoom != null);

  @override
  int get hashCode => query.hashCode ^ geoPoint.hashCode ^ zoom.hashCode;

  @override
  bool operator ==(other) =>
      other is MapCamera &&
      query == other.query &&
      geoPoint == other.geoPoint &&
      zoom == other.zoom;
}

/// A marker in a map.
///
/// ## Example
/// ```
/// final marker = MapMarker(
///   geoPoint: GeoPoint(0.0, 0.0),
///   label: 'London',
/// );
/// ```
class MapMarker {
  /// Optional query string such as name of place ("Tower Of London") or address.
  final String query;

  /// Optional geographical point.
  final GeoPoint geoPoint;

  /// Optional title of the marker.
  final String title;

  const MapMarker({
    this.query,
    this.geoPoint,
    this.title,
  });

  @override
  int get hashCode => query.hashCode ^ geoPoint.hashCode ^ title.hashCode;

  @override
  bool operator ==(other) =>
      other is MapMarker &&
      query == other.query &&
      geoPoint == other.geoPoint &&
      title == other.title;
}

enum MapType {
  normal,
  traffic,
}

/// A map widget.
///
/// ## Choosing map vendor
/// Before using map widgets, you need to choose some [MapAdapter].
///
/// In the `main` function of your application:
/// ```
/// void main() {
///   // Configure default map engine
///   MapAdapter.defaultInstance = const MapAdapter.platformSpecific(
///     android: GoogleMapsNativeAdapter(apiKey:'YOUR API KEY'),
///     browser: GoogleMapsIframeAdapter(apiKey:'YOUR API KEY'),
///     ios: AppleMapsNativeAdapter(),
///     otherwise: GoogleMapStaticAdapter(apiKey:'YOUR API KEY'),
///   );
/// }
/// ```
///
/// ## Using the widget
/// ```
/// import 'package:flutter/widgets.dart';
/// import 'package:maps/maps.dart';
///
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MapWidget(
///       size: Size(300, 500),
///       query: 'Paris',
///       markers: [
///         MapMarker(
///           query: 'Eiffel Tower',
///         ),
///       ],
///     );
///   }
/// }
/// ```
class MapWidget extends StatefulWidget {
  /// Size of the map. For example, `Size(300, 500)`.
  final Size size;

  /// Camera location and zoom.
  final MapCamera camera;

  /// Markers on the map.
  final List<MapMarker> markers;

  /// Map engine. If null, [MapAdapter.defaultInstance] is used.
  final MapAdapter adapter;

  /// Whether to show the user's current location. The default is `true`.
  final bool userLocationEnabled;

  /// Whether to show a button that shows the user's current location. The
  /// default is `true`.
  final bool userLocationButtonEnabled;

  /// Whether to show zoom buttons. The default is `true`.
  final bool zoomControlsEnabled;

  /// Whether to support zoom gestures. The default is `true`.
  final bool zoomGesturesEnabled;

  /// Optional builder for widget when it is being loaded.
  final Widget Function(BuildContext context, MapWidget widget) loadingBuilder;

  const MapWidget({
    @required this.size,
    @required this.camera,
    this.markers = const <MapMarker>[],
    this.adapter,
    this.userLocationEnabled = true,
    this.userLocationButtonEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.loadingBuilder,
  })  : assert(size != null),
        assert(camera != null),
        assert(markers != null),
        assert(userLocationEnabled != null),
        assert(userLocationButtonEnabled != null);

  @override
  State<StatefulWidget> createState() {
    return MapWidgetState();
  }
}

class MapWidgetState extends State<MapWidget> {
  /// Optimization: we cache the built widget.
  Widget _builtWidget;

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    /// Optimization: we re-build the widget only when necessary.
    final widget = this.widget;
    if (!(widget.adapter == oldWidget.adapter &&
        widget.camera == oldWidget.camera &&
        widget.size == oldWidget.size &&
        widget.userLocationEnabled == oldWidget.userLocationEnabled &&
        widget.userLocationButtonEnabled &&
        oldWidget.userLocationButtonEnabled &&
        widget.zoomControlsEnabled == oldWidget.zoomControlsEnabled &&
        widget.zoomGesturesEnabled == oldWidget.zoomGesturesEnabled &&
        const ListEquality<MapMarker>().equals(
          widget.markers,
          oldWidget.markers,
        ))) {
      _builtWidget = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    /// Optimization: we try to use a cached widget.
    final oldBuiltWidget = _builtWidget;
    if (oldBuiltWidget != null) {
      return oldBuiltWidget;
    }

    final adapter = widget.adapter ?? MapAdapter.defaultInstance;
    if (adapter == null) {
      throw StateError(
        'Both `mapAdapter` and `MapAdapter.defaultInstance` are null',
      );
    }
    final builtWidget = adapter.buildMapWidget(widget);

    /// Optimization: we cache the widget.
    _builtWidget = builtWidget;

    return builtWidget;
  }
}
