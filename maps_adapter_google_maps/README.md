[![Pub Package](https://img.shields.io/pub/v/maps_adapter_google_maps.svg)](https://pub.dev/packages/maps_adapter_google_maps)
[![Github Actions CI](https://github.com/dint-dev/maps/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/maps/actions?query=workflow%3A%22Dart+CI%22)

# Overview
This is a Google Maps Android/iOS SDK adapter for the package [maps](https://pub.dev/packages/maps).

# Getting started
## 1.Add dependency
In _pubspec.yaml_, you should have:
```yaml
dependencies:
  maps_adapter_google_maps: ^0.1.0
```

## 2.Modify configuration files
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

## 3.Set map adapter
In your main function:
```dart
import 'package:maps/maps.dart';
import 'package:maps_adapter_google_maps';

void main() {
  MapAdapter.defaultInstance = const GoogleMapsNativeAdapter();

  // ...
}
```

# Contributing?

Test changes manually with the example application in the repository.