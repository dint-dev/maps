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
import 'package:maps/maps.dart';

export 'package:database/database.dart' show GeoPoint;

/// Defines map location.
class MapLocation {
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
  final Zoom zoom;

  const MapLocation({
    this.query,
    this.geoPoint,
    this.zoom,
  }) : assert(query != null || geoPoint != null);

  @override
  int get hashCode => query.hashCode ^ geoPoint.hashCode ^ zoom.hashCode;

  @override
  bool operator ==(other) =>
      other is MapLocation &&
      query == other.query &&
      geoPoint == other.geoPoint &&
      zoom == other.zoom;
}

/// Zoom is a value typically between 1 (farthest) and 20 (closest).
class Zoom {
  final double value;

  const Zoom(this.value) : assert(value != null), assert(value>=0), assert(value<=23);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(other) => other is Zoom && value == other.value;

  @override
  String toString() => 'Zoom($value)';
}
