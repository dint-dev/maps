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

import 'dart:html' as html;

import 'package:flutter/widgets.dart';
import 'package:maps/maps.dart';

import 'google_maps_js_bindings.dart' as google_maps;
import 'internal/js.dart';

Widget buildGoogleMapsJs(GoogleMapsJsAdapter adapter, MapWidget mapWidget) {
  return _GoogleMapsJs(
    apiKey: adapter.apiKey,
    mapWidget: mapWidget,
  );
}

Widget buildGoogleMapsNative(
    GoogleMapsNativeAdapter adapter, MapWidget widget) {
  throw StateError('GoogleMapsNativeAdapter is only supported in Android/iOS');
}

class _GoogleMapsJs extends StatefulWidget {
  final String apiKey;
  final MapWidget mapWidget;

  _GoogleMapsJs({
    @required this.apiKey,
    @required this.mapWidget,
  });

  @override
  State<StatefulWidget> createState() {
    return _GoogleMapsJsState();
  }
}

class _GoogleMapsJsState extends State<_GoogleMapsJs> {
  LoadedScript _script;
  google_maps.Map _map;
  Widget _widget;

  @override
  Widget build(BuildContext context) {
    final sb = StringBuffer();
    sb.write('https://maps.googleapis.com/maps/api/js?key=');
    sb.write(Uri.encodeQueryComponent(widget.apiKey));
    sb.write('&callback=initGoogleMaps');

    // Load script
    final src = sb.toString();
    if (_script == null || _script.src != src) {
      _script = LoadedScript(
        src: src,
        readyFunctionName: 'initGoogleMaps',
        isLoadedCallback: () => google_maps.isLoaded,
      );
      _script.load().then((value) {
        setState(() {
          // -
        });
      });
    }

    if (!_script.isLoaded) {
      final loadingBuilder = widget.mapWidget.loadingBuilder;
      if (loadingBuilder != null) {
        return loadingBuilder(context, widget.mapWidget);
      }
      return Text('Loading map...');
    }

    if (_widget == null) {
      final element = html.DivElement();
      element.id = 'map';
      element.style
        ..margin = '0'
        ..padding = '0'
        ..border = '0'
        ..width = '100%'
        ..height = '100%'
        ..zIndex = '9999';
      _map = google_maps.Map(
          element,
          google_maps.MapArgs(
            center: google_maps.LatLng(lat: 0.0, lng: 0.0),
          ));
      _widget = buildHtmlViewFromElement(element);
    }

    return _widget;
  }
}
