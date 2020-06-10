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

import 'google_maps_impl_default.dart'
    if (dart.library.html) 'google_maps_impl_browser.dart';

/// Enables [MapWidget] to use [Google Maps Android SDK](https://developers.google.com/maps/documentation/android-sdk/intro)
/// and [Google Maps iOS SDK](https://developers.google.com/maps/documentation/ios-sdk/intro)
/// ([package:google_maps_flutter](https://pub.dev/packages/google_maps_flutter)).
///
/// ## Getting started
/// You need to set API keys by following instructions by
/// [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) (the
/// official plugin by Google that this package uses).
///
/// In summary:
///   * For Android, you need to edit `android/app/src/main/AndroidManifest.xml`.
///   * For iOS, you need to edit one of the following:
///     * `ios/Runner/AppDelegate.swift` (if your Flutter project uses Swift)
///     * `ios/Runner/AppDelegate.m` (if your Flutter project uses Objective-C)
///
/// Then:
/// ```
/// import 'package:maps/maps.dart';
/// import 'package:maps_adapter_google_maps';
///
/// void main() {
///   MapAdapter.defaultInstance = const GoogleMapsNativeAdapter();
///
///   // ...
/// }
/// ```
class GoogleMapsNativeAdapter extends MapAdapter {
  const GoogleMapsNativeAdapter();

  @override
  String get productName => 'Google Maps';

  @override
  Widget buildMapWidget(MapWidget mapWidget, Size size) {
    return buildGoogleMapsNative(this, mapWidget, size);
  }
}
