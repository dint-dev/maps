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

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as impl;
import 'package:maps/maps.dart';

import 'google_maps.dart';

Widget buildGoogleMapsNative(
  GoogleMapsNativeAdapter adapter,
  MapWidget widget,
  Size size,
) {
  if (!(Platform.isAndroid || Platform.isIOS)) {
    throw StateError(
      'GoogleMapsNativeAdapter is only supported in Android/iOS',
    );
  }
  return impl.GoogleMap(
    mapType: _mapTypeFrom(widget.mapType),
    initialCameraPosition: _cameraPositionFrom(widget.location),
    markers: widget.markers.map(_markerFrom).toSet(),
    polylines: widget.lines.map(_polyLineFrom).toSet(),
    circles: widget.circles.map(_circleFrom).toSet(),

    // My location
    myLocationEnabled: widget.userLocationEnabled,
    myLocationButtonEnabled: widget.userLocationButtonEnabled,

    // Scrolling
    scrollGesturesEnabled: widget.scrollGesturesEnabled,

    // Zooming
    zoomControlsEnabled: widget.zoomControlsEnabled,
    zoomGesturesEnabled: widget.zoomGesturesEnabled,
  );
}

impl.CameraPosition _cameraPositionFrom(MapLocation value) {
  return impl.CameraPosition(
    target: _latLngFrom(value.geoPoint ?? GeoPoint.zero),
    zoom: value.zoom.value,
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

impl.InfoWindow _infoWindowFrom(MapMarkerDetails details) {
  if (details == null) {
    return null;
  }
  return impl.InfoWindow(
    title: details.title,
    snippet: details.snippet,
  );
}

impl.LatLng _latLngFrom(GeoPoint value) {
  if (value == null) {
    return null;
  }
  return impl.LatLng(value.latitude, value.longitude);
}

impl.MapType _mapTypeFrom(MapType mapType) {
  switch (mapType) {
    case MapType.normal:
      return impl.MapType.normal;
    case MapType.satellite:
      return impl.MapType.satellite;
    case MapType.terrain:
      return impl.MapType.terrain;
    case MapType.hybrid:
      return impl.MapType.hybrid;
    default:
      return impl.MapType.normal;
  }
}

impl.Marker _markerFrom(MapMarker value) {
  return impl.Marker(
    markerId: impl.MarkerId(value.id),
    position: _latLngFrom(value.geoPoint),
    infoWindow: _infoWindowFrom(value.details),
    onTap: value.onTap,
  );
}

impl.Polyline _polyLineFrom(MapLine value) {
  return impl.Polyline(
    polylineId: impl.PolylineId(value.id),
    points: <impl.LatLng>[...value.geoPoints.map(_latLngFrom)],
    color: value.color,
    width: value.width?.toInt(),
  );
}
