[![Pub Package](https://img.shields.io/pub/v/maps.svg)](https://pub.dev/packages/maps)
[![Github Actions CI](https://github.com/dint-dev/maps/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/maps/actions?query=workflow%3A%22Dart+CI%22)

# Overview

Geographic maps for Flutter applications.

This package is:
  * __Cross-platform.__ Browser, Android, iOS, Windows, etc.
  * __Multi-vendor.__ Supports all major map vendors (Apple, Bing, Google).

This is an early-stage version and lots of things are still missing or broken.
Pull requests are welcome!

## Links
  * [Github project](https://github.com/dint-dev/maps)
  * [Issue tracker](https://github.com/dint-dev/maps/issues)
  * [Pub package](https://pub.dev/packages/maps)
  * [API reference](https://pub.dev/documentation/maps/latest/)

# Getting started
## 1.Add dependency
```yaml
dependencies:
  maps: ^0.1.2
```

## 2.Define configuration
We recommend that you set a default [MapAdapter](https://pub.dev/documentation/maps/latest/maps/MapAdapter-class.html)
in the `main` function of your application. This is more convenient than setting a _MapAdapter_ for
each widget separately.

Your main function should look something like this:
```dart
// ...
import 'package:maps/maps.dart';

void main() {
  MapAdapter.defaultInstance = const MapAdapter.platformSpecific(
    android: GoogleMapsNativeAdapter(apiKey:'GOOGLE MAPS API KEY'),
    browser: BingMapsIframeDapter(),
    ios: AppleMapsNativeAdapter(),
    otherwise: GoogleMapsStaticAdapter(apiKey:'GOOGLE MAPS API KEY'),
  );

  // ...

  runApp(MyApp());
}
```

## 3.Use
### MapWidget
[MapWidget](https://pub.dev/documentation/maps/latest/maps/MapWidget-class.html) is a Flutter widget that uses the map engine you chose:
```dart
// ...
import 'package:maps/maps.dart';

final widget = MapWidget(
  size: Size(300, 500),
  query: 'Paris',
  markers: [
    MapMarker(
      query: 'Eiffel Tower',
    ),
  ],
);
```

### MapAppLauncher
[MapAppLauncher](https://pub.dev/documentation/maps/latest/maps/MapAppLAuncher-class.html) launches
either:
  * A map website (such as Google Maps website)
  * A map application in the device (such as Google Maps for Android/iOS)

```dart
import 'package:maps/maps.dart';

Future<void> main() async {
  // Use default app
  await MapAppLauncher.defaultInstance.launch(query:'Eiffel Tower');

  // Use Google Maps
  await MapAppLauncher.googleMaps.launch(query:'Louvre Museum');
}
```


# Supported map providers
## Apple Maps APIs
### iOS
  * [AppleMapsNativeAdapter](https://pub.dev/documentation/maps/latest/maps/AppleMapsNativeAdapter-class.html)
    enables you to use [Apple MapKit](https://developer.apple.com/documentation/mapkit).
    The current implementation depends on the Flutter package [apple_maps_flutter](https://pub.dev/packages/apple_maps_flutter),
    a package by a third-party developer.
  * The adapter doesn't require API credentials.

In `ios/Runner/Info.plist`, you should have something like:
```xml
	<key>io.flutter.embedded_views_preview</key>
	<true/>
	<key>Privacy - Location When In Use Usage Description</key>
	<string>A description of your privacy policy.</string>
```

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
### Android / iOS
  * [GoogleMapsNativeAdapter](https://pub.dev/documentation/maps/latest/maps/GoogleMapsNativeAdapter-class.html)
    enables you to use Google Map Android / iOS SDKs.
  * You need to obtain API keys and follow documentation by
    [google_maps_flutter](https://pub.dev/packages/google_maps_flutter).

For Android support, you need to modify `android/app/src/main/AndroidManifest.xml`.

For iOS support, you need to modify:
  * `ios/Runner/AppDelegate.m` (if your Flutter project uses Objective-C)
  * `ios/Runner/AppDelegate.swift` (if your Flutter project uses Switf)

You also need to ensure that `ios/Runner/Info.plist` has something like:
```xml
	<key>io.flutter.embedded_views_preview</key>
	<true/>
	<key>Privacy - Location When In Use Usage Description</key>
	<string>A description of your privacy policy.</string>
```

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

# Tips
## Use images when you can
Images are rendered identically in all platforms and have the best performance.

## Reducing code size
This package depends on [google_maps_flutter](https://pub.dev/packages/google_maps_flutter).
If you don't use Google Maps Android / iOS SDKs, you can reduce binary size by excluding the
pods from your build script.

