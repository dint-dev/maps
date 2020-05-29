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
import 'package:webview_flutter/webview_flutter.dart' as web_view;

Widget buildIframeMapWidget({
  @required MapWidget mapWidget,
  @required String src,
  @required String mapAdapterClassName,
}) {
  src = src.replaceAll('&', '&amp;').replaceAll('"', '&quot;');
  return web_view.WebView(
    initialUrl: Uri.dataFromString(
      '<html>'
      '<head><style>html,body,iframe{margin:0;padding:0;border:0;background:pink;}</style></head>'
      '<body>'
      '<iframe src="$src" frameborder="0" width="100%" height="100%"></iframe>'
      '</body></html>',
      mimeType: 'text/html',
    ).toString(),
    javascriptMode: web_view.JavascriptMode.unrestricted,
  );
  //throw StateError('$mapAdapterClassName is only supported in browsers');
}
