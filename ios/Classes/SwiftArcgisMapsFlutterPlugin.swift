import Flutter
import UIKit
import ArcGIS


public class SwiftArcgisMapsFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel", binaryMessenger: registrar.messenger())
        let instance = SwiftArcgisMapsFlutterPlugin()
        registrar.register(ArcgisMapFactory(registrar: registrar),
                withId: "plugins.flutter.io/arcgis_maps",
                gestureRecognizersBlockingPolicy: FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall,
                       result: @escaping FlutterResult) {
        switch call.method {
        case "arcgis#setApiKey":
            let apiKey = call.arguments as! String
            AGSArcGISRuntimeEnvironment.apiKey = apiKey
            result(nil)
            break
        case "arcgis#getApiKey":
            result(AGSArcGISRuntimeEnvironment.apiKey)
            break
        case "arcgis#setLicense":
            let licenseKey = call.arguments as! String
            do {
                let licenseResult = try AGSArcGISRuntimeEnvironment.setLicenseKey(licenseKey)
                result(licenseResult.licenseStatus.rawValue)
            } catch {
                print("Error licensing app: \(error.localizedDescription)")
                result(AGSLicenseStatus.invalid.rawValue)
            }
            break
        case "arcgis#getApiVersion":
            result(String(AGSArcGISRuntimeEnvironment.version()))
            break;
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }


}
