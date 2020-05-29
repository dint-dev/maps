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

import 'dart:io';

import 'package:apple_maps_flutter/apple_maps_flutter.dart' as impl;
import 'package:flutter/widgets.dart';
import 'package:maps/maps.dart';

Widget buildAppleMapsJs(AppleMapsJsAdapter mapAdapter, MapWidget widget) {
  return null;
}

Widget buildAppleMapsNative(AppleMapsNativeAdapter engine, MapWidget widget) {
  if (!Platform.isIOS) {
    return null;
  }
  return SizedBox(
    width: widget.size.width,
    height: widget.size.height,
    child: impl.AppleMap(
      initialCameraPosition: _cameraPositionFrom(widget.camera),
      myLocationEnabled: widget.userLocationEnabled,
      myLocationButtonEnabled: widget.userLocationButtonEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
      annotations: (widget.markers ?? const <MapMarker>[]).map((marker) {
        return impl.Annotation(
          annotationId: impl.AnnotationId(
            marker.query ?? marker.geoPoint?.toString(),
          ),
        );
      }).toSet(),
    ),
  );
}

impl.CameraPosition _cameraPositionFrom(MapCamera value) {
  return impl.CameraPosition(
    target: _latLngFrom(value.geoPoint ?? GeoPoint.zero),
    zoom: value.zoom,
  );
}

impl.LatLng _latLngFrom(GeoPoint geoPoint) {
  if (geoPoint == null) {
    return null;
  }
  return impl.LatLng(geoPoint.latitude, geoPoint.longitude);
}
