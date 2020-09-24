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
import 'package:database/database.dart' show GeoPoint;
import 'package:flutter/widgets.dart' show Color;
import 'package:maps/maps.dart';
import 'package:meta/meta.dart';

/// Specifies a sequence of lines that should be drawn by [MapWidget].
///
/// Not all [MapAdapter] implementations support this feature.
class MapLine {
  final String id;
  final List<GeoPoint> geoPoints;
  final double width;
  final Color color;

  const MapLine({
    @required this.id,
    @required this.geoPoints,
    this.width,
    this.color,
  })  : assert(id != null),
        assert(geoPoints != null);

  @override
  int get hashCode => const ListEquality<GeoPoint>().hash(geoPoints);

  @override
  bool operator ==(other) =>
      other is MapLine &&
      const ListEquality<GeoPoint>().equals(geoPoints, other.geoPoints) &&
      width == other.width &&
      color == other.color;
}
