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

import 'internal/platform_specific.dart';

/// Superclass for map vendor adapters. The default map vendor is defined by
/// [MapAdapter.defaultInstance].
///
/// ## Available implementations
///   * [AppleMapsJsAdapter] (browser)
///   * [AppleMapsNativeAdapter] (iOS)
///   * [AppleMapsStaticAdapter] (all platforms)
///   * [BingMapsIframeAdapter] (browser)
///   * [BingMapsJsAdapter] (browser)
///   * [BingMapsStaticAdapter] (all platforms)
///   * [GoogleMapsIframeAdapter] (browser)
///   * [GoogleMapsJsAdapter] (browser)
///   * [GoogleMapsNativeAdapter] (Android/iOS)
///   * [GoogleMapsStaticAdapter] (all platforms)
///
/// ## Setting default engine
/// ```
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const MapAdapter.platformSpecific(
///     android: GoogleMapsNativeAdapter(apiKey:'YOUR API KEY'),
///     browser: GoogleMapsIframeAdapter(apiKey:'YOUR API KEY'),
///     ios: AppleMapsNativeAdapter(),
///     otherwise: GoogleMapsStaticAdapter(apiKey:'YOUR API KEY'),
///   );
///
///   // ...
/// }
/// ```
abstract class MapAdapter {
  /// Default instance
  ///
  /// ## Example
  /// ```
  /// import 'package:maps/maps.dart';
  ///
  /// void main() {
  ///   MapAdapter.defaultInstance = const MapAdapter.platformSpecific(
  ///     android: GoogleMapsNativeAdapter(apiKey:'YOUR API KEY'),
  ///     browser: GoogleMapsIframeAdapter(apiKey:'YOUR API KEY'),
  ///     ios: AppleMapsNativeAdapter(),
  ///     otherwise: GoogleMapsStaticAdapter(apiKey:'YOUR API KEY'),
  ///   );
  ///
  ///   // ...
  /// }
  /// ```
  static MapAdapter defaultInstance;

  const MapAdapter();

  const factory MapAdapter.platformSpecific({
    MapAdapter android,
    MapAdapter browser,
    MapAdapter ios,
    MapAdapter linux,
    MapAdapter otherwise,
    MapAdapter macos,
    MapAdapter windows,
  }) = PlatformSpecificMapAdapter;

  /// Name of the product for debugging purposes. Example: "Google Maps".
  String get productName;

  /// Constructs a Flutter widget.
  Widget buildMapWidget(MapWidget widget);
}
