[![Pub Package](https://img.shields.io/pub/v/maps.svg)](https://pub.dev/packages/maps)
[![Github Actions CI](https://github.com/dint-dev/maps/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/maps/actions?query=workflow%3A%22Dart+CI%22)

# Overview

Cross-platform geographic maps for Flutter applications.

__This is an early version and lots of things are still missing or broken.__

Pull requests are welcome! The package is licensed under the [Apache License 2.0](LICENSE).

## Links
  * [Github project](https://github.com/dint-dev/maps)
  * [Issue tracker](https://github.com/dint-dev/maps/issues)
  * [Pub package](https://pub.dev/packages/maps)
  * [API reference](https://pub.dev/documentation/maps/latest/)

# Getting started
## 1.Add dependency
In _pubspec.yaml_:
```yaml
dependencies:
  maps: ^0.5.0
```

Add the following in `ios/Runner/Info.plist`:
```xml
	<key>io.flutter.embedded_views_preview</key>
	<true/>
```

## 2.Use
### Launching external application?
[MapLauncher](https://pub.dev/documentation/maps/latest/maps/MapLauncher-class.html) launches
map applications.

The following implementations are available:
  * [AppleMapsLauncher](https://pub.dev/documentation/maps/latest/maps/AppleMapsLauncher-class.html)
    launches Apple Maps (native application - the user must have an iOS device)
  * [BingMapsLauncher](https://pub.dev/documentation/maps/latest/maps/BingMapsLauncher-class.html)
    launches Bing Maps (website)
  * [GoogleMapsLauncher](https://pub.dev/documentation/maps/latest/maps/GoogleMapsLauncher-class.html)
    launches Google Maps (native application or website)
  * [MapLauncher.platformSpecific](https://pub.dev/documentation/maps/latest/maps/MapLauncher/MapLauncher.platformSpecific.html)
    allows you to specify launcher for each operating system.

```dart
import 'package:maps/maps.dart';

Future<void> main() async {
  // Use default map app
  await MapAppLauncher.defaultInstance.launch(
    query: 'Paris',
  );
}
```

### Rendering a map?
[MapWidget](https://pub.dev/documentation/maps/latest/maps/MapWidget-class.html) shows a map.
It fills all space available to it.

```dart
import 'package:flutter/material.dart';
import 'package:maps/maps.dart';

void main() {
  // Set default adapter
  MapAdapter.defaultInstance = MapAdapter.platformSpecific(
    ios: AppleNativeAdapter(),

    // Bing Maps iframe API does not necessarily require API credentials
    // so we use it in the example.
    otherwise: BingMapsIframeAdapter(),
  );

  // Construct a map widget
  const parisMap = MapWidget(
    location: MapLocation(
      query: 'Paris',
    ),
    markers: [
      MapMarker(
        query: 'Eiffel Tower',
      ),
    ],
  );

  // Run our example app
  runApp(const MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: parisMap, // Full-screen map of Paris
      ),
    ),
  ));
}
```

Assuming that you have enabled Flutter for Web, you can run:
```
flutter run -d chrome
```

# Supported map providers
## Apple Maps APIs
### iOS
  * [AppleMapsNativeAdapter](https://pub.dev/documentation/maps/latest/maps/AppleMapsNativeAdapter-class.html)
    enables you to use [Apple MapKit](https://developer.apple.com/documentation/mapkit).
    The current implementation depends on the Flutter package [apple_maps_flutter](https://pub.dev/packages/apple_maps_flutter),
    a package by a third-party developer.
  * The adapter doesn't require API credentials.
  * You need to edit `ios/Runner/Info.plist`.

### Javascript
  * [AppleMapsJsAdapter](https://pub.dev/documentation/maps/latest/maps/AppleMapsJsAdapter-class.html)
    enables you to uses [Apple MapKit JS](https://developer.apple.com/documentation/mapkitjs).
  * The adapter requires you to have API credentials (ECDSA P-256 key pair).

### Images
  * [AppleMapsStaticAdapter](https://pub.dev/documentation/maps/latest/maps/AppleMapsStaticAdapter-class.html)
    enables you to use [Apple Maps Web Snapshots API](https://developer.apple.com/documentation/snapshots).
  * The adapter requires you to have API credentials (ECDSA P-256 key pair).

## Bing Maps APIs
### Javascript
  * [BingMapsJsAdapter](https://pub.dev/documentation/maps/latest/maps/BingMapsJsAdapter-class.html)
    enables you to use [Bing Maps Javascript API](https://docs.microsoft.com/en-us/bingmaps/v8-web-control/).
  * The adapter requires an API key, which you can get at [Bing Maps API website](https://docs.microsoft.com/en-us/bingmaps/).

### Iframes
  * [BingMapsIframeAdapter](https://pub.dev/documentation/maps/latest/maps/BingMapsIframeAdapter-class.html)
    enables you to uses [Bing Maps Custom Map URLs](https://docs.microsoft.com/en-us/bingmaps/articles/create-a-custom-map-url).
  * Note that markers and many other features are unsupported by Bing Maps Custom Map URLs.
  * The adapter does NOT necessarily require an API key.

### Images
  * [BingMapsStaticAdapter](https://pub.dev/documentation/maps/latest/maps/BingMapsStaticAdapter-class.html)
    enables you to uses [Bing Maps REST API for static maps](https://docs.microsoft.com/en-us/bingmaps/rest-services/imagery/get-a-static-map).
  * The adapter requires an API key, which you can get at [Bing Maps API website](https://docs.microsoft.com/en-us/bingmaps/).

## Google Maps APIs
### Android / iOS native SDK
Use the separate package [maps_adapter_google_maps](https://pub.dev/packages/maps_adapter_google_maps).

### Javascript
  * [GoogleMapsJsAdapter](https://pub.dev/documentation/maps/latest/maps/GoogleMapsJsAdapter-class.html)
    enables you to use [Google Maps Javascript API](https://developers.google.com/maps/documentation/javascript/tutorial).
  * The adapter requires an API key, which you can get at [Google Maps API website](https://cloud.google.com/maps-platform/).

### Iframes
  * [GoogleMapsIframeAdapter](https://pub.dev/documentation/maps/latest/maps/GoogleMapsIframeAdapter-class.html)
     enables you to use [Google Maps Embed API](https://developers.google.com/maps/documentation/embed/guide).
  * Note that markers and many other features are unsupported by Google Maps Embed API.
  * The adapter requires an API key, which you can get at [Google Maps API website](https://cloud.google.com/maps-platform/).

### Images
  * [GoogleMapsStaticAdapter](https://pub.dev/documentation/maps/latest/maps/GoogleMapsStaticAdapter-class.html)
    enables you to use [Google Maps Static API](https://developers.google.com/maps/documentation/maps-static/intro).
  * The adapter requires an API key, which you can get at [Google Maps API website](https://cloud.google.com/maps-platform/).

# Contributing?
  * Pull requests are welcome.
  * Please test your changes manually using the "example" application in the repository.
