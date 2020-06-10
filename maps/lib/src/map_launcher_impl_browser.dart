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
