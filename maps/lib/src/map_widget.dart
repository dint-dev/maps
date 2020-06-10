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

/// Describes type of map.
enum MapType {
  /// Normal map.
  normal,

  /// Traffic map.
  traffic,
}

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
  /// Camera location and zoom.
  final MapLocation location;

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
    Key key,
    @required this.location,
    this.markers = const <MapMarker>[],
    this.adapter,
    this.userLocationEnabled = true,
    this.userLocationButtonEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.loadingBuilder,
  })  : assert(location != null),
        assert(markers != null),
        assert(userLocationEnabled != null),
        assert(userLocationButtonEnabled != null),
        assert(zoomControlsEnabled != null),
        assert(zoomGesturesEnabled != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MapWidgetState();
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
    /// Optimization: we re-build the widget only when necessary.
    final widget = this.widget;
    if (!(widget.adapter == oldWidget.adapter &&
        widget.location == oldWidget.location &&
        widget.userLocationEnabled == oldWidget.userLocationEnabled &&
        widget.userLocationButtonEnabled &&
        oldWidget.userLocationButtonEnabled &&
        widget.zoomControlsEnabled == oldWidget.zoomControlsEnabled &&
        widget.zoomGesturesEnabled == oldWidget.zoomGesturesEnabled &&
        const ListEquality<MapMarker>().equals(
          widget.markers,
          oldWidget.markers,
        ))) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }
}
