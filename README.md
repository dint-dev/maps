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
  maps: ^0.1.1
```

## 2.Define configuration
We recommend that you set a default [MapAdapter](https://pub.dev/documentation/maps/latest/maps/MapAdapter-class.html)
in the `main` function of your application. This is more convenient than setting a _MapAdapter_ for
each widget separately.

Your main function should look something like this:
```dart
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
import 'package:flutter/widgets.dart';
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
## Apple Maps
Available implementations:
  * [AppleMapsNativeAdapter](https://pub.dev/documentation/maps/latest/maps/AppleMapsNativeAdapter-class.html) (iOS)
    * Uses [Apple MapKit](https://developer.apple.com/documentation/mapkit).
      Currently depends on the Flutter package [apple_maps_flutter](https://pub.dev/packages/apple_maps_flutter)
      (by a third-party developer).
  * [AppleMapsJsAdapter](https://pub.dev/documentation/maps/latest/maps/AppleMapsJsAdapter-class.html) (browsers)
    * Uses [Apple MapKit JS](https://developer.apple.com/documentation/mapkitjs).
  * [AppleMapsStaticAdapter](https://pub.dev/documentation/maps/latest/maps/AppleMapsStaticAdapter-class.html) (all platforms)
    * Uses [Apple Maps Web Snapshots API](https://developer.apple.com/documentation/snapshots).

The iOS API does not require API credentials. For using other APIs you need to obtain API
credentials from Apple. API requests are signed with your ECDSA P-256 key pair.

## Bing Maps
Available implementations:
  * [BingMapsIframeAdapter](https://pub.dev/documentation/maps/latest/maps/BingMapsIframeAdapter-class.html) (browsers)
    * Uses [Bing Maps Custom Map URLs](https://docs.microsoft.com/en-us/bingmaps/articles/create-a-custom-map-url).
    * Note that markers and many other features are unsupported.
  * [BingMapsJsAdapter](https://pub.dev/documentation/maps/latest/maps/BingMapsJsAdapter-class.html) (browsers)
    * Uses [Bing Maps Javascript API](https://docs.microsoft.com/en-us/bingmaps/v8-web-control/).
  * [BingMapsStaticAdapter](https://pub.dev/documentation/maps/latest/maps/BingMapsStaticAdapter-class.html) (all platforms)
    * Uses [Bing Maps REST API for static maps](https://docs.microsoft.com/en-us/bingmaps/rest-services/imagery/get-a-static-map).

Bing Maps may allow you to use the _iframe_ API without API credentials. For using other APIs, you
need to obtain API credentials from Microsoft. You can do that in the
[Bing Maps API website](https://docs.microsoft.com/en-us/bingmaps/).

## Google Maps
Available implementations:
  * [GoogleMapsIframeAdapter](https://pub.dev/documentation/maps/latest/maps/GoogleMapsIframeAdapter-class.html) (browsers)
    * Uses [Google Maps Embed API](https://developers.google.com/maps/documentation/embed/guide).
    * Note that markers and many other features are unsupported.
  * [GoogleMapsJsAdapter](https://pub.dev/documentation/maps/latest/maps/GoogleMapsJsAdapter-class.html) (browsers)
    * Uses [Google Maps Javascript API](https://developers.google.com/maps/documentation/javascript/tutorial).
  * [GoogleMapsNativeAdapter](https://pub.dev/documentation/maps/latest/maps/GoogleMapsNativeAdapter-class.html) (Android, iOS)
    * Uses Google Maps Android / iOS SDK.
      Depends on [google_maps_flutter](https://pub.dev/packages/google_maps_flutter).
      which is the official package maintained by Google. You need to edit your
      configuration files. See documentation for [google_maps_flutter](https://pub.dev/packages/google_maps_flutter).
  * [GoogleMapsStaticAdapter](https://pub.dev/documentation/maps/latest/maps/GoogleMapsStaticAdapter-class.html) (all platforms)
    * Uses [Google Maps Static API](https://developers.google.com/maps/documentation/maps-static/intro).

You need to obtain API credentials from Google. You can do that in the
[Google Maps API website](https://cloud.google.com/maps-platform/).