import Flutter
import UIKit

public class SwiftUrlLinkPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mocaris_url_link", binaryMessenger: registrar.messenger())
        let instance = SwiftUrlLinkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        let eventChannel = FlutterEventChannel(name: "mocaris_url_link_stream", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        registrar.addApplicationDelegate(instance)
    }

    private var eventSink: FlutterEventSink?

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {}

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        self.eventSink?(url.absoluteString)
        return true
    }
    
}
