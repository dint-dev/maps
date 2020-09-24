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
    mapType: _mapTypeFrom(widget.mapType),
    initialCameraPosition: _cameraPositionFrom(widget.location),
    annotations: widget.markers.map(_annotationFrom).toSet(),
    polylines: widget.lines.map(_polyLineFrom).toSet(),
    circles: widget.circles.map(_circleFrom).toSet(),

    // My location
    myLocationEnabled: widget.userLocationEnabled,
    myLocationButtonEnabled: widget.userLocationButtonEnabled,

    // Scrolling
    scrollGesturesEnabled: widget.scrollGesturesEnabled,

    // Zooming
    zoomGesturesEnabled: widget.zoomGesturesEnabled,
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

impl.CameraPosition _cameraPositionFrom(MapLocation mapLocation) {
  return impl.CameraPosition(
    target: _latLngFrom(mapLocation.geoPoint ?? GeoPoint.zero),
    zoom: mapLocation.zoom.value,
  );
}

impl.Circle _circleFrom(MapCircle value) {
  return impl.Circle(
    circleId: impl.CircleId(value.id),
    center: _latLngFrom(value.geoPoint),
    radius: value.radius,
    fillColor: value.fillColor,
    strokeColor: value.strokeColor,
  );
}

impl.LatLng _latLngFrom(GeoPoint geoPoint) {
  if (geoPoint == null) {
    return null;
  }
  return impl.LatLng(geoPoint.latitude, geoPoint.longitude);
}

impl.Polyline _polyLineFrom(MapLine value) {
  return impl.Polyline(
    polylineId: impl.PolylineId(value.id),
    points: <impl.LatLng>[...value.geoPoints.map(_latLngFrom)],
    color: value.color,
    width: value.width?.toInt(),
  );
}

impl.MapType _mapTypeFrom(MapType mapType) {
  switch (mapType) {
    case MapType.normal:
      return impl.MapType.standard;
    case MapType.satellite:
      return impl.MapType.satellite;
    case MapType.terrain:
      return impl.MapType.satellite;
    case MapType.hybrid:
      return impl.MapType.hybrid;
    default:
      return impl.MapType.standard;
  }
}
