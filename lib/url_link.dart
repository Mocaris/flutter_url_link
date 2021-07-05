import 'dart:async';

import 'package:flutter/services.dart';

/// iOS 注册 URL Scheme
/// info.plist里添加URL types
///

/// android mainactivity 下添加 intent-filter
/// scheme path host 自定义填写
/// 在 actitity onCreate(savedInstanceState: Bundle?)    onNewIntent(intent: Intent)
/// 调用  UrlLinkUtil.sendPlugin
//            <intent-filter>
//                 <data
//                     android:host="host"
//                     android:path="/path"
//                     android:scheme="scheme" />
//                 <action android:name="android.intent.action.VIEW" />
//
//                 <category android:name="android.intent.category.DEFAULT" />
//                 <category android:name="android.intent.category.BROWSABLE" />
//             </intent-filter>
class UrlLink {
  static final MethodChannel _channel = MethodChannel('mocaris_url_link');

  static final Stream<String> _eventChannel = EventChannel('mocaris_url_link_stream')
      .receiveBroadcastStream()
      .asBroadcastStream()
      .map((event) => event.toString());

  StreamSubscription? _subscription;
  StreamController<String>? _streamController;

  Stream<String> registerUrlLink() {
    _streamController ??= StreamController();
    _subscription = _eventChannel.listen((event) {
      _streamController?.add(event);
    });
    return _streamController!.stream;
  }

  dispose() {
    _streamController?.close();
    _subscription?.cancel();
  }
}
