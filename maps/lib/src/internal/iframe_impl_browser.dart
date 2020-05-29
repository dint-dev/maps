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

import 'js.dart';

Widget buildIframeMapWidget({
  @required MapWidget mapWidget,
  @required String src,
  @required String mapAdapterClassName,
  @required bool allowFullScreen,
}) {
  return _IframeWidget(
    src: src,
    width: mapWidget.size.width.toInt(),
    height: mapWidget.size.height.toInt(),
  );
}

class _IframeWidget extends StatefulWidget {
  final String src;
  final int width;
  final int height;

  _IframeWidget({this.src, this.width, this.height});

  @override
  State<StatefulWidget> createState() {
    return _IframeWidgetState();
  }
}

class _IframeWidgetState extends State<_IframeWidget> {
  html.IFrameElement _element;
  Widget _widget;

  @override
  void initState() {
    _element = html.IFrameElement()
      ..src = widget.src
      ..width = '${widget.width.toInt()}'
      ..height = '${widget.height.toInt()}'
      ..allowFullscreen = true
      ..referrerPolicy = 'no-referrer'
      ..style.zIndex = '99999'
      ..style.border = '0'
      ..style.margin = '0';
    super.initState();
  }

  @override
  void dispose() {
    _widget = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(_IframeWidget oldWidget) {
    _element
      ..src = widget.src
      ..width = '${widget.width.toInt()}'
      ..height = '${widget.height.toInt()}';
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _widget ??= buildHtmlViewFromElement(_element);
    return _widget;
  }
}
