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

import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/widgets.dart';
import 'package:maps/maps.dart';

import 'apple_maps_impl_default.dart'
    if (dart.library.html) 'apple_maps_impl_browser.dart';

/// Enables [MapWidget] to use [Apple MapKit JS](https://developer.apple.com/documentation/mapkitjs).
///
/// # Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const AppleMapsAdapter(
///     requestSigner: AppleMapsRequestSigner(
///       // ...
///     ),
///   );
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class AppleMapsJsAdapter extends MapAdapter {
  final AppleMapsRequestSigner requestSigner;

  const AppleMapsJsAdapter({@required this.requestSigner})
      : assert(requestSigner != null);

  @override
  String get productName => 'Apple Maps';

  @override
  Widget buildMapWidget(MapWidget widget) {
    return buildAppleMapsJs(this, widget);
  }
}

/// Enables [MapWidget] to use [Apple MapKit](https://developer.apple.com/documentation/mapkit),
/// in iOS.
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const AppleMapsAdapter();
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class AppleMapsNativeAdapter extends MapAdapter {
  const AppleMapsNativeAdapter();

  @override
  String get productName => 'Apple Maps';

  @override
  Widget buildMapWidget(MapWidget widget) {
    return buildAppleMapsNative(this, widget);
  }
}

/// Cryptographically signs API request for [AppleMapsJsAdapter] and [AppleMapsStaticAdapter].
abstract class AppleMapsRequestSigner {
  const AppleMapsRequestSigner();

  /// Constructs a request signer from the private key. __To protect your
  /// private key, you should use this only in the server-side.__
  const factory AppleMapsRequestSigner.withPrivateKey({
    @required String teamId,
    @required String keyId,
    @required EcJwkPrivateKey privateKey,
  }) = _AppleMapsRequestSigner;

  /// Signs the URL using the algorithm described by Apple.
  Future<String> signUrl(String url);
}

/// Enables [MapWidget] to use [Apple Maps Web Snapshots API](https://developer.apple.com/documentation/snapshots).
///
/// ## Getting started
/// You should set [MapAdapter.defaultInstance].
/// In the `main` function of your application:
/// ```dart
/// import 'package:maps/maps.dart';
///
/// void main() {
///   MapAdapter.defaultInstance = const AppleMapsAdapter(
///     requestSigner: AppleMapsRequestSigner.fromPrivateKey(
///       // ...
///     ),
///   );
///
///   // ...
///
///   runApp(yourApp);
/// }
/// ```
class AppleMapsStaticAdapter extends MapAdapter {
  final AppleMapsRequestSigner requestSigner;

  const AppleMapsStaticAdapter({@required this.requestSigner})
      : assert(requestSigner != null);

  @override
  String get productName => 'Apple Maps';

  @override
  Widget buildMapWidget(MapWidget widget) {
    return _AppleMapsStaticWidget(widget, requestSigner);
  }
}

class _AppleMapsRequestSigner extends AppleMapsRequestSigner {
  final String teamId;
  final String keyId;
  final EcJwkPrivateKey privateKey;

  const _AppleMapsRequestSigner(
      {@required this.teamId, @required this.keyId, @required this.privateKey})
      : assert(teamId != null),
        assert(keyId != null),
        assert(privateKey != null);

  @override
  Future<String> signUrl(String url) async {
    if (!url.contains('?')) {
      throw ArgumentError.value(url);
    }
    final sb = StringBuffer();
    sb.write(url);
    sb.write('&teamId=');
    sb.write(Uri.encodeComponent(teamId));
    sb.write('&keyId=');
    sb.write(Uri.encodeComponent(keyId));
    if (ecdsaP256Sha256 == null) {
      throw UnimplementedError();
    }
    final signature = await ecdsaP256Sha256.sign(
      utf8.encode(url),
      KeyPair(
        privateKey: privateKey,
        publicKey: privateKey.toPublicKey(),
      ),
    );
    sb.write('&signature=');
    sb.write(base64.encode(signature.bytes));
    return sb.toString();
  }
}

class _AppleMapsStaticWidget extends StatefulWidget {
  final MapWidget mapWidget;
  final AppleMapsRequestSigner requestSigner;

  _AppleMapsStaticWidget(this.mapWidget, this.requestSigner);

  @override
  State<StatefulWidget> createState() {
    return _AppleMapsStaticWidgetState();
  }
}

class _AppleMapsStaticWidgetState extends State<_AppleMapsStaticWidget> {
  String _src;
  Widget _widget;

  @override
  Widget build(BuildContext context) {
    return _widget;
  }

  @override
  void didUpdateWidget(_AppleMapsStaticWidget oldWidget) {
    if (!_mapsEqual(widget, oldWidget)) {
      _refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _widget = SizedBox(
      width: widget.mapWidget.size.width,
      height: widget.mapWidget.size.height,
    );
  }

  Widget _error(Object error, {@required String src}) {
    var message = 'Building Apple Maps image failed.';
    assert(() {
      message += '\n\nURL: $_src\n\nError: $error';
      return true;
    }());
    return SizedBox(
      width: widget.mapWidget.size.width,
      height: widget.mapWidget.size.height,
      child: Text(message),
    );
  }

  bool _mapsEqual(_AppleMapsStaticWidget a, _AppleMapsStaticWidget b) {
    return a.mapWidget.size == b.mapWidget.size &&
        a.mapWidget.camera == b.mapWidget.camera &&
        a.requestSigner == b.requestSigner;
  }

  void _refresh() {
    final mapWidget = widget.mapWidget;
    final camera = mapWidget.camera;

    // Base URL
    final sb = StringBuffer();
    sb.write('https://snapshot.apple-mapkit.com/api/v1/snapshot');

    // Size
    sb.write('?size=');
    sb.write(mapWidget.size.width.toInt());
    sb.write('x');
    sb.write(mapWidget.size.height.toInt());

    // Query or GeoPoint
    if (camera.geoPoint != null) {
      sb.write('&center=');
      sb.write(Uri.encodeQueryComponent(camera.geoPoint.latitude.toString()));
      sb.write(',');
      sb.write(Uri.encodeQueryComponent(camera.geoPoint.longitude.toString()));
    } else if (camera.query != null) {
      sb.write('&center=');
      sb.write(Uri.encodeQueryComponent(camera.query));
    }

    // Zoom
    sb.write('&z=');
    sb.write(camera.zoom.toInt().clamp(3, 20));

    // Sign the request
    final src = sb.toString();
    widget.requestSigner.signUrl(src).then((src) {
      _widget = Image.network(
        src,
        width: widget.mapWidget.size.width,
        height: widget.mapWidget.size.height,
        errorBuilder: (context, error, stackTrace) {
          return _error(error, src: src);
        },
      );
    }, onError: (error) {
      _widget = _error(error, src: src);
    });
  }
}
