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

import 'package:cryptography_flutter/cryptography.dart';
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
  Widget buildMapWidget(MapWidget widget, Size size) {
    return buildAppleMapsJs(this, widget, size);
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
  Widget buildMapWidget(MapWidget widget, Size size) {
    return buildAppleMapsNative(this, widget, size);
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
  Widget buildMapWidget(MapWidget widget, Size size) {
    return _AppleMapsStaticWidget(widget, requestSigner, size);
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
  final Size size;

  _AppleMapsStaticWidget(this.mapWidget, this.requestSigner, this.size);

  @override
  State<StatefulWidget> createState() {
    return _AppleMapsStaticWidgetState();
  }
}

class _AppleMapsStaticWidgetState extends State<_AppleMapsStaticWidget> {
  Future<String> _future;
  String _oldUrl;
  String _oldSignedUrl;

  @override
  Widget build(BuildContext context) {
    final url = buildUrl();
    if (url == _oldUrl) {
      return Image.network(_oldSignedUrl);
    }
    _future ??= () {
      return widget.requestSigner.signUrl(url);
    }();
    return FutureBuilder<String>(
      future: _future,
      builder: (context, snapshot) {
        final signedUrl = snapshot.data;
        _future = null;
        _oldUrl = url;
        _oldSignedUrl = signedUrl;
        return Image.network(signedUrl);
      },
    );
  }

  String buildUrl() {
    final sb = StringBuffer();
    sb.write('https://snapshot.apple-mapkit.com/api/v1/snapshot');

    // Size
    final size = widget.size;
    sb.write('?size=');
    sb.write(size.width.toInt());
    sb.write('x');
    sb.write(size.height.toInt());

    // Location
    final location = widget.mapWidget.location;
    final query = location.query ?? '';
    final geoPoint = location.geoPoint;
    if (geoPoint != null) {
      sb.write('&center=');
      sb.write(geoPoint.latitude);
      sb.write(',');
      sb.write(geoPoint.longitude);
    } else if (query.isNotEmpty) {
      sb.write('&center=');
      sb.write(Uri.encodeQueryComponent(query));
    }

    // Zoom
    final zoom = location.zoom;
    if (zoom != null) {
      sb.write('&z=');
      sb.write(zoom.clamp(3, 20));
    }

    // Sign the request
    return sb.toString();
  }

  @override
  void initState() {
    super.initState();
  }
}
