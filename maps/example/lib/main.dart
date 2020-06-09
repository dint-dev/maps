import 'package:flutter/material.dart';
import 'package:maps/maps.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: MapWidget(
        size: Size(300, 500),

        camera: MapCamera(
          geoPoint: GeoPoint(0, 0),
        ),

        // Bing Maps iframe API does not necessarily require API credentials
        // so we use it in the example.
        adapter: BingMapsIframeAdapter(),
      ),
    ),
  ));
}
