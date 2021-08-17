import Flutter
import UIKit

public class SwiftUrlLinkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mocaris_url_link", binaryMessenger: registrar.messenger())
        let instance = SwiftUrlLinkPlugin(channle: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public init(channle: FlutterMethodChannel) {
        self._channel = channle
        super.init()
    }

    private var _channel: FlutterMethodChannel

    private var _lastUri: String?

    func setDataUri(url: String?) {
        debugPrint("url_link receive url:\(url ?? "")")
        if url != nil {
            _lastUri = url
            _channel.invokeMethod("receive_uri", arguments: _lastUri!)
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getLastUri":
            result(_lastUri)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _lastUri = nil
        return nil
    }

    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        let type = userActivity.activityType
        if type == NSUserActivityTypeBrowsingWeb {
            guard let url = userActivity.webpageURL?.absoluteString else {
                return false
            }
            setDataUri(url: url)
            return true
        }
        return false
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        guard let url: URL = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL else {
            return false
        }
        setDataUri(url: url.absoluteString)
        return true
    }

    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        setDataUri(url: url.absoluteString)
        return true
    }

    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        setDataUri(url: url.absoluteString)
        return true
    }

    public func application(_ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any) -> Bool {
        setDataUri(url: url.absoluteString)
        return true
    }
}
