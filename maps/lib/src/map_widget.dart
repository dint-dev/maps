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

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:maps/maps.dart';

export 'package:database/database.dart' show GeoPoint;

/// A map widget that fills all space available to it.
///
/// ## Choosing MapAdapter
/// Before using map widgets, you need to choose some [MapAdapter].
///
/// In the `main` function of your application:
/// ```
/// import 'package:maps/maps.dart';
///
/// void main() {
///   // Configure default map engine
///   MapAdapter.defaultInstance = const MapAdapter.platformSpecific(
///     ios: AppleMapsNativeAdapter(),
///     otherwise: BingMapsIframeAdapter(apiKey:'YOUR API KEY'),
///   );
///
///   // ...
///
///   runApp(MyApp(
///     // ...
///   ));
/// }
/// ```
///
/// ## Using MapWidget
/// ```
/// import 'package:flutter/widgets.dart';
/// import 'package:maps/maps.dart';
///
/// class ParisMap extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MapWidget(
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
///
/// ## Avoiding resizing
///
/// Resizing the map can be an expensive operation. If the parent widget layout
/// changes often, wrap it with something like:
/// ```
/// final fixedSizeMap = Center(
///   child: SizedWidget(
///     width: 400,
///     height: 400,
///     child: mapWidget,
///   ),
/// );
/// ```
class MapWidget extends StatefulWidget {
  /// Map engine. If null, [MapAdapter.defaultInstance] is used.
  final MapAdapter adapter;

  /// Map type. The default value is [MapType.normal].
  final MapType mapType;

  /// Camera location and zoom.
  final MapLocation location;

  /// Markers that should be drawn by the [adapter].
  /// Not all adapters support this feature.
  final Set<MapMarker> markers;

  /// Lines that should be drawn by the [adapter].
  /// Not all adapters support this feature.
  final Set<MapLine> lines;

  /// Circles that should be drawn by the [adapter].
  /// Not all adapters support this feature.
  final Set<MapCircle> circles;

  /// Whether to show the user's current location. The default is `true`.
  final bool userLocationEnabled;

  /// Whether to show a button that shows the user's current location. The
  /// default is `true`.
  final bool userLocationButtonEnabled;

  /// Whether to support scroll gestures. The default is `true`.
  final bool scrollGesturesEnabled;

  /// Whether to show zoom buttons. The default is `true`.
  final bool zoomControlsEnabled;

  /// Whether to support zoom gestures. The default is `true`.
  final bool zoomGesturesEnabled;

  /// Optional builder for widget when it is being loaded.
  final Widget Function(BuildContext context, MapWidget widget) loadingBuilder;

  const MapWidget({
    Key key,
    this.mapType = MapType.normal,
    @required this.location,
    this.markers = const <MapMarker>{},
    this.lines = const <MapLine>{},
    this.circles = const <MapCircle>{},
    this.adapter,
    this.userLocationEnabled = true,
    this.userLocationButtonEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.loadingBuilder,
  })  : assert(mapType != null),
        assert(location != null),
        assert(markers != null),
        assert(lines != null),
        assert(circles != null),
        assert(userLocationEnabled != null),
        assert(userLocationButtonEnabled != null),
        assert(zoomControlsEnabled != null),
        assert(zoomGesturesEnabled != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MapWidgetState();
  }

  static bool _equal(MapWidget widget, MapWidget oldWidget) {
    return widget.adapter == oldWidget.adapter &&
        widget.location == oldWidget.location &&
        widget.userLocationEnabled == oldWidget.userLocationEnabled &&
        widget.userLocationButtonEnabled &&
        oldWidget.userLocationButtonEnabled &&
        widget.zoomControlsEnabled == oldWidget.zoomControlsEnabled &&
        widget.zoomGesturesEnabled == oldWidget.zoomGesturesEnabled &&
        const SetEquality<MapMarker>().equals(
          widget.markers,
          oldWidget.markers,
        ) &&
        const SetEquality<MapLine>().equals(
          widget.lines,
          oldWidget.lines,
        ) &&
        const SetEquality<MapCircle>().equals(
          widget.circles,
          oldWidget.circles,
        );
  }
}

class MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    final adapter = widget.adapter ?? MapAdapter.defaultInstance;
    if (adapter == null) {
      throw StateError(
        'Both `widget.mapAdapter` and `MapAdapter.defaultInstance` are null',
      );
    }

    return LayoutBuilder(
      builder: (context, dimensions) {
        return adapter.buildMapWidget(widget, dimensions.smallest);
      },
    );
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    // We re-build the widget only when the widget has really been mutated.
    final widget = this.widget;
    if (!MapWidget._equal(widget, oldWidget)) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }
}
