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

    var _lastUrl: String?

    private var eventSink: FlutterEventSink?

    func setLasteUrl(url: String) -> Bool {
        let key = "lastUrlKey"
        willChangeValue(forKey: key)
        _lastUrl = url
        didChangeValue(forKey: key)
        if eventSink == nil {
            return false
        }
        eventSink?(url)
        return true
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getLastUrl":
            result(_lastUrl)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        let type = userActivity.activityType
        if type == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL?.absoluteString
            if url != nil {
                return setLasteUrl(url: url!)
            }
        }
        return true
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        let url: URL? = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL
        if url == nil {
            return false
        }
        return setLasteUrl(url: url!.absoluteString)
    }

    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return setLasteUrl(url: url.absoluteString)
    }

    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return setLasteUrl(url: url.absoluteString)
    }

    public func application(_ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any) -> Bool {
        return setLasteUrl(url: url.absoluteString)
    }
}
