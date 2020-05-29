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

import 'package:flutter/material.dart';
import 'package:maps/maps.dart';
import 'API_KEYS.dart';

void main() {
  runApp(_ExampleApp());
}

class _ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: _ExampleWidget(),
      ),
    );
  }
}

class _ExampleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExampleWidgetState();
  }
}

class _ExampleWidgetState extends State<_ExampleWidget> {
  static const defaultMapAdapter = MapAdapter.platformSpecific(
    ios: appleMapsNative,
    otherwise: bingMapsIframe,
  );

  static const AppleMapsJsAdapter appleMapsJs = null;
  static const AppleMapsNativeAdapter appleMapsNative =
      AppleMapsNativeAdapter();
  static const AppleMapsStaticAdapter appleMapsStatic = null;
  static const bingMapsIframe = BingMapsIframeAdapter();
  static const bingMapsJs = BingMapsJsAdapter(apiKey: bingApiKey);
  static const bingMapsStatic = BingMapsStaticAdapter(apiKey: bingApiKey);
  static const googleMapsIframe = GoogleMapsIframeAdapter(apiKey: googleApiKey);
  static const googleMapsJs = GoogleMapsJsAdapter(apiKey: googleApiKey);
  static const googleMapsNative = GoogleMapsNativeAdapter();
  static const googleMapsStatic = GoogleMapsStaticAdapter(apiKey: googleApiKey);

  MapAdapter selectedAdapter = defaultMapAdapter;

  GeoPoint geoPoint = const GeoPoint(48.856613, 2.352222);
  double zoom = 10;

  @override
  Widget build(BuildContext context) {
    final radioButtonRows = <Row>[];
    void f(String name, MapAdapter value) {
      if (value == null) {
        return;
      }
      radioButtonRows.add(Row(
        children: [
          Radio<MapAdapter>(
            value: value,
            groupValue: selectedAdapter,
            onChanged: (newValue) {
              setState(() {
                selectedAdapter = newValue;
              });
            },
          ),
          Text(name),
        ],
      ));
    }

    f('Platform specific', defaultMapAdapter);
    f('Apple Maps (js)', appleMapsJs);
    f('Apple Maps (native)', appleMapsNative);
    f('Apple Maps (static)', appleMapsStatic);
    f('Bing Maps (iframe)', bingMapsIframe);
    f('Bing Maps (js)', bingMapsJs);
    f('Bing Maps (static)', bingMapsStatic);
    f('Google Maps (iframe)', googleMapsIframe);
    f('Google Maps (js)', googleMapsJs);
    f('Google Maps (native)', googleMapsNative);
    f('Google Maps (static)', googleMapsStatic);

    return Column(
      children: [
        Container(
          height: 50,
        ),
        Text('MapWidget:'),
        SizedBox(
          width: 500,
          height: 300,
          child: MapWidget(
            adapter: selectedAdapter,
            size: Size(500, 300),
            camera: MapCamera(
              geoPoint: geoPoint,
              zoom: zoom,
            ),
          ),
        ),
        Text(
          'Choose adapter:',
          textScaleFactor: 1.5,
          textAlign: TextAlign.left,
        ),
        ...radioButtonRows,
      ],
    );
  }
}
