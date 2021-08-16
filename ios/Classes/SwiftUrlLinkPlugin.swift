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
        _channel = channle
        isRegister = true
        super.init()
    }

    private var isRegister = false

    private var _channel: FlutterMethodChannel

    private var _lastUri: String?

    func setDataUri(url: String?) -> Bool {
        if url != nil {
            _lastUri = url
            if isRegister {
                _channel.invokeMethod("receive_uri", arguments: _lastUri!)
            }
            return true
        }
        return false
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
        isRegister = false
        return nil
    }

    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        let type = userActivity.activityType
        if type == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL?.absoluteString
            if url != nil {
                return setDataUri(url: url!)
            }
        }
        return true
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        let url: URL? = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL
        if url == nil {
            return false
        }
        return setDataUri(url: url!.absoluteString)
    }

    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return setDataUri(url: url.absoluteString)
    }

    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return setDataUri(url: url.absoluteString)
    }

    public func application(_ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any) -> Bool {
        return setDataUri(url: url.absoluteString)
    }
}
