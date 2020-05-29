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

import 'package:flutter/cupertino.dart';
import 'package:maps/maps.dart';
import 'package:meta/meta.dart';

import 'platform_specific_impl_default.dart'
    if (dart.library.html) 'platform_specific_impl_browser.dart';

class PlatformSpecificMapAdapter extends MapAdapter {
  final MapAdapter android;
  final MapAdapter browser;
  final MapAdapter ios;
  final MapAdapter windows;
  final MapAdapter macos;
  final MapAdapter linux;
  final MapAdapter otherwise;

  @override
  String get productName => getPlatformSpecificEngine(this)?.productName;

  const PlatformSpecificMapAdapter({
    this.android,
    this.browser,
    this.ios,
    this.windows,
    this.macos,
    this.linux,
    @required this.otherwise,
  });

  @override
  Widget buildMapWidget(MapWidget widget) {
    /// Use conditionally imported function to determine the engine.
    /// (This enables tree-shaking by the compiler to prune browser/non-browser
    /// code.)
    final engine = getPlatformSpecificEngine(this);
    if (engine == null) {
      return Text('No map engine is configured for this platform');
    }
    return engine.buildMapWidget(widget);
  }
}
