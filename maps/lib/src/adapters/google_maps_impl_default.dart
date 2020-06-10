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

import 'package:flutter/widgets.dart';
import 'package:maps/maps.dart';
import 'package:web_browser/web_browser.dart';

Widget buildGoogleMapsIframe(String url, Size size) {
  final width = size.width.toInt();
  final height = size.height.toInt();
  url = url.replaceAll('&', '&amp;').replaceAll('"', '&quot;');
  return WebBrowser(
    // URL
    initialUrl: Uri.dataFromString(
      '''<html><head><meta name="viewport" content="width=$width, height=$height"></head><body style="margin:0;padding:0;"><iframe src="$url" width="$width" height="$height"></iframe></body></html>''',
      mimeType: 'text/html',
    ).toString(),

    // No navigation buttons
    interactionSettings: null,

    // Javascript required
    javascriptEnabled: true,
  );
}

Widget buildGoogleMapsJs(
  GoogleMapsJsAdapter adapter,
  MapWidget mapWidget,
  Size size,
) {
  final sb = StringBuffer();
  sb.write('https://maps.googleapis.com/maps/api/js?key=');
  sb.write(Uri.encodeQueryComponent(adapter.apiKey));
  sb.write('&callback=initMap');
  final src = sb.toString().replaceAll('&', '&amp;').replaceAll('"', '&quot;');

  final scriptSb = StringBuffer();
  scriptSb.writeln('function initMap() {');
  scriptSb.writeln('  new google.maps.Map(document.getElementById("map")); }');
  scriptSb.writeln('}');
  final script =
      scriptSb.toString().replaceAll('&', '&amp;').replaceAll('<', '&lt;');

  final width = size.width.toInt().toString();
  final height = size.height.toInt().toString();
  final html = '<!DOCTYPE html>'
      '<html>'
      '<head><meta name="viewport" content="width=$width, height=$height"></head>'
      '<body style="margin:0;padding:0;">'
      '<div id="map" style="position:fixed;left:0;top:0;width:$width;height:$height"></div>'
      '<script src="$src" async defer></script>'
      '<script type="text/javascript">$script</script>'
      '</body>'
      '</html>';

  final url = Uri.dataFromString(html, mimeType: 'text/html').toString();

  return WebBrowser(
    initialUrl: url,
    javascriptEnabled: true,
  );
}
