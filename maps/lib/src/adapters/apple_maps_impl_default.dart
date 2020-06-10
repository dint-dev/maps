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

Widget buildAppleMapsJs(
    AppleMapsJsAdapter mapAdapter, MapWidget widget, Size size) {
  return null;
}

Widget buildAppleMapsNative(
    AppleMapsNativeAdapter engine, MapWidget widget, Size size) {
  if (!Platform.isIOS) {
    return null;
  }

  return impl.AppleMap(
    initialCameraPosition: _cameraPositionFrom(widget.location),
    myLocationEnabled: widget.userLocationEnabled,
    myLocationButtonEnabled: widget.userLocationButtonEnabled,
    zoomGesturesEnabled: widget.zoomGesturesEnabled,
    annotations: widget.markers.map(_annotationFrom).toSet(),
  );
}

impl.Annotation _annotationFrom(MapMarker marker) {
  impl.InfoWindow infoWindow;

  final details = marker.details;
  if (details != null) {
    infoWindow = impl.InfoWindow(
      title: details.title,
      snippet: details.snippet,
    );
  }

  return impl.Annotation(
    annotationId: impl.AnnotationId(marker.id),
    position: _latLngFrom(marker.geoPoint),
    infoWindow: infoWindow,
    onTap: marker.onTap,
  );
}

impl.CameraPosition _cameraPositionFrom(MapLocation value) {
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
