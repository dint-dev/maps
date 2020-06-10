import 'package:flutter/material.dart';
import 'package:maps/maps.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: MapWidget(
        location: MapLocation(
          query: 'Paris',
        ),

        // Bing Maps iframe API does not necessarily require API credentials
        // so we use it in the example.
        adapter: BingMapsIframeAdapter(),
      ),
    ),
  ));
}
