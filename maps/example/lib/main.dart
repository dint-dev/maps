import 'package:flutter/material.dart';
import 'package:maps/maps.dart';

void main() {
  // Choose some underlying map API.
  // Bing Maps 'iframe' doesn't require API credentials so we use it.
  MapAdapter.defaultInstance = BingMapsIframeAdapter();

  // Run app
  runApp(
    MaterialApp(
      home: Scaffold(
        // Show a map of Paris
        body: MapWidget(
          size: Size(500, 300),
          camera: MapCamera(
            query: 'Paris',
            zoom: 8,
          ),
        ),
      ),
    ),
  );
}
