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
import 'package:web_browser/web_browser.dart';

import 'bing_maps_js_bindings.dart' as api;
import 'internal/js.dart';

Widget buildBingMapsJs(BingMapsJsAdapter mapAdapter, MapWidget widget) {
  return _BingMapsJsWidget(
    apiKey: mapAdapter.apiKey,
    widget: widget,
  );
}

class _BingMapsJsWidget extends StatefulWidget {
  final String apiKey;
  final MapWidget widget;

  _BingMapsJsWidget({@required this.apiKey, @required this.widget});

  @override
  State<_BingMapsJsWidget> createState() {
    return _BingMapsJsWidgetState();
  }
}

class _BingMapsJsWidgetState extends State<_BingMapsJsWidget> {
  static int _bingElementNextId = 0;
  LoadedScript _script;
  Widget _builtWidget;
  api.Map _map;

  @override
  Widget build(BuildContext context) {
    // Create URL
    final sb = StringBuffer();
    sb.write('https://www.bing.com/api/maps/mapcontrol?callback=initBingMaps');
    sb.write('&key=');
    sb.write(Uri.encodeQueryComponent(widget.apiKey));
    final src = sb.toString();

    if (_script == null || _script.src != src) {
      // Load script
      _script = LoadedScript(
        src: src,
        readyFunctionName: 'initBingMaps',
        isLoadedCallback: () => api.isLoaded,
      );
      _script.load().then((_) {
        setState(() {});
      });
      _builtWidget = null;
    }

    if (!_script.isLoaded) {
      return Text('Loading Bing Maps Javascript...');
    }

    if (_builtWidget == null) {
      // Generate ID
      final id = 'bing-map-$_bingElementNextId';
      _bingElementNextId++;

      // Create a DIV element
      final htmlElement = html.DivElement()..id = id;

      // Insert it into the body temporarily
      html.document.body.append(htmlElement);

      // Call Javascript API
      final camera = widget.widget.camera;
      _map = api.Map(
        id,
        api.MapArgs(
          center: api.Location(
            camera.geoPoint.latitude,
            camera.geoPoint.longitude,
          ),
          zoom: camera.zoom.toInt(),
        ),
      );

      // Construct a widget that will eventually move the element into the
      // right location.
      _builtWidget = WebNode(
        node: htmlElement,
      );
    }
    return _builtWidget;
  }
}
