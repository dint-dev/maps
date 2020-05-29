import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart' as url_launcher;

Future<bool> canLaunch(String url) {
  return url_launcher.canLaunch(url);
}

Future<bool> launch(String url) {
  return url_launcher.launch(url);
}

bool get isAndroid => Platform.isAndroid;
bool get isIOS => Platform.isIOS;
bool get isMacOS => Platform.isMacOS;
