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
import 'package:maps_adapter_google_maps/maps_adapter_google_maps.dart';

import 'API_KEYS.dart';

void main() {
  runApp(_ExampleApp());
}

class _ExampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExampleAppState();
  }
}

class _ExampleAppState extends State<_ExampleApp> {
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
  var _tab = 0;
  MapAdapter selectedAdapter = defaultMapAdapter;

  String query;
  GeoPoint geoPoint = const GeoPoint(48.856613, 2.352222);

  double zoom = 10;

  // Paris
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: SafeArea(
          child: buildTab(context, _tab),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.launch),
              title: Text('MapLauncher'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('MapWidget'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
          onTap: (i) {
            setState(() {
              _tab = i;
            });
          },
        ),
      ),
    );
  }

  Widget buildMapLauncherDemo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          child: Text('Apple Maps'),
          onPressed: () {
            MapAppLauncher.appleMaps.launch(
              camera: MapCamera(
                query: query,
                geoPoint: geoPoint,
              ),
            );
          },
        ),
        MaterialButton(
          child: Text('Bing Maps'),
          onPressed: () {
            MapAppLauncher.bingMaps.launch(
              camera: MapCamera(
                query: query,
                geoPoint: geoPoint,
              ),
            );
          },
        ),
        MaterialButton(
          child: Text('Google Maps'),
          onPressed: () {
            MapAppLauncher.googleMaps.launch(
              camera: MapCamera(
                query: query,
                geoPoint: geoPoint,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildMapWidgetDemo(BuildContext context) {
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
          Text(
            name,
          ),
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

  Widget buildSettings(BuildContext context) {
    final queryController = TextEditingController();
    queryController.text = query;
    return Column(
      children: <Widget>[
        Row(children: [
          Text('Query:'),
          MaterialButton(
            child: Text('None'),
            onPressed: () {
              setState(() {
                query = '';
              });
            },
          ),
          MaterialButton(
            child: Text('Paris, France'),
            onPressed: () {
              setState(() {
                query = 'Paris, France';
              });
            },
          ),
        ]),
        TextField(
          controller: queryController,
          maxLength: 30,
          onChanged: (newValue) {
            query = newValue;
          },
        ),
      ],
    );
  }

  Widget buildTab(BuildContext context, int i) {
    switch (i) {
      case 0:
        return buildMapLauncherDemo(context);
      case 1:
        return buildMapWidgetDemo(context);
      default:
        return buildSettings(context);
    }
  }
}
