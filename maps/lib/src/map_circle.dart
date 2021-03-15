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

import 'package:flutter/widgets.dart' show Color;
import 'package:maps/maps.dart';
import 'package:meta/meta.dart';

/// Specifies a sequence of lines that should be drawn by [MapWidget].
///
/// Not all [MapAdapter] implementations support this feature.
class MapCircle {
  /// Unique identifier required by some adapters.
  final String _id;

  /// Center point of the circle.
  final GeoPoint geoPoint;

  /// Radius in meters.
  final double radius;

  /// Color for the fill.
  final Color fillColor;

  /// Color for the stroke.
  final Color strokeColor;

  const MapCircle({
    String id,
    @required this.geoPoint,
    @required this.radius,
    this.fillColor,
    this.strokeColor,
  })  : assert(geoPoint != null),
        assert(radius != null),
        _id = id;

  /// Unique identifier required by some adapters.
  String get id => _id ?? geoPoint.toString();

  @override
  bool operator ==(other) =>
      other is MapCircle &&
      id == other.id &&
      geoPoint == other.geoPoint &&
      radius == other.radius &&
      fillColor == other.fillColor &&
      strokeColor == other.strokeColor;
}
