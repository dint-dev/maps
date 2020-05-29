import 'dart:async';
import 'dart:html' as html;

bool get isAndroid => _userAgentContains('Android');

bool get isIOS => _userAgentContains('iPhone');

bool get isMacOS => _userAgentContains('Mac OS X');

Future<bool> canLaunch(String url) {
  return Future<bool>.value(url.startsWith('https://'));
}

Future<bool> launch(String url) {
  if (!url.startsWith('https://')) {
    return Future<bool>.value(false);
  }
  html.window.location.href = url;
  return Future<bool>.value(true);
}

bool _userAgentContains(String s) {
  return html.window.navigator.userAgent?.contains(s) ?? false;
}
