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

  final markers = widget.markers ?? <MapMarker>[];
  final implMarkers = markers.map(_markerFrom).toList();

  return impl.GoogleMap(
    initialCameraPosition: _cameraPositionFrom(widget.location),
    myLocationEnabled: widget.userLocationEnabled,
    myLocationButtonEnabled: widget.userLocationButtonEnabled,
    zoomControlsEnabled: widget.zoomControlsEnabled,
    zoomGesturesEnabled: widget.zoomGesturesEnabled,
    markers: widget.markers.map(_markerFrom).toSet(),
  );
}

impl.CameraPosition _cameraPositionFrom(MapLocation value) {
  return impl.CameraPosition(
    target: _latLngFrom(value.geoPoint ?? GeoPoint.zero),
    zoom: value.zoom,
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

impl.Marker _markerFrom(MapMarker value) {
  return impl.Marker(
    markerId: impl.MarkerId(value.id),
    position: _latLngFrom(value.geoPoint),
    infoWindow: _infoWindowFrom(value.details),
    onTap: value.onTap,
  );
}
