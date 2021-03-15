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

/// Specifies a marker that should be drawn by [MapWidget].
///
/// Not all [MapAdapter] implementations support this feature.
///
/// ## Example
/// ```
/// final marker = MapMarker(
///   geoPoint: GeoPoint(0.0, 0.0),
///   label: 'London',
/// );
/// ```
class MapMarker {
  /// Unique identifier required by some adapters.
  final String _id;

  /// Optional query string such as name of place ("Tower Of London") or address.
  final String query;

  /// Optional geographical point.
  final GeoPoint geoPoint;

  /// Details shown when the marker is tapped.
  final MapMarkerDetails details;

  /// Optional tap handling callback.
  final void Function() onTap;

  const MapMarker({
    String id,
    this.query,
    this.geoPoint,
    this.details,
    this.onTap,
  }) : _id = id;

  @override
  int get hashCode => query.hashCode ^ geoPoint.hashCode ^ details.hashCode;

  /// Unique identifier required by some adapters.
  String get id => _id ?? '${geoPoint ?? query}';

  @override
  bool operator ==(other) =>
      other is MapMarker &&
      query == other.query &&
      geoPoint == other.geoPoint &&
      details == other.details &&
      onTap == other.onTap;
}

/// Detailed information about a place. Used by [MapMarker].
class MapMarkerDetails {
  /// Optional title of the marker.
  final String title;

  /// Optional snippet.
  final String snippet;

  const MapMarkerDetails({this.title, this.snippet});

  @override
  int get hashCode => title.hashCode ^ snippet.hashCode;

  @override
  bool operator ==(other) =>
      other is MapMarkerDetails &&
      title == other.title &&
      snippet == other.snippet;
}
