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
final MethodChannel _channel = MethodChannel('mocaris_url_link')..setMethodCallHandler(_methodHandler);

final StreamController<String> _handlerController = StreamController.broadcast();

Future _methodHandler(MethodCall call) {
  switch (call.method) {
    case "receive_uri":
      print("UrlLink receive uri:${call.arguments}");
      break;
  }
  _handlerController.add(call.arguments);
  return Future.value();
}

class UrlLink {
  StreamSubscription? _subscription;

  Future<String?> getLastLinkUri() async {
    return _channel.invokeMethod("getLastUri") as String?;
  }

  Stream<String> registerUrlLink() {
    return _handlerController.stream;
  }

  dispose() {
    _subscription?.cancel();
  }
}
