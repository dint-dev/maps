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

Widget buildStaticMapWidget({
  @required MapWidget mapWidget,
  @required String mapAdapterClassName,
  @required String src,
}) {
  ImageLoadingBuilder loadingBuilder;
  if (mapWidget.loadingBuilder != null) {
    loadingBuilder = (context, widget, _) {
      return mapWidget.loadingBuilder(context, mapWidget);
    };
  }
  return Image.network(
    src,
    width: mapWidget.size.width,
    height: mapWidget.size.height,
    loadingBuilder: loadingBuilder,
    errorBuilder: (context, error, stackTrace) {
      var message = '$mapAdapterClassName failed.';
      assert(() {
        message += '\n\nURL: $src\n\nError: $error';
        return true;
      }());
      return SizedBox(
        width: mapWidget.size.width,
        height: mapWidget.size.height,
        child: Text(message),
      );
    },
  );
}
