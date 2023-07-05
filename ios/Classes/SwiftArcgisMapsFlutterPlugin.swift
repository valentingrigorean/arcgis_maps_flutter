import Flutter
import UIKit
import ArcGIS

public class SwiftArcgisMapsFlutterPlugin: NSObject, FlutterPlugin {

    private let channel: FlutterMethodChannel
    private let geometryController: GeometryEngineController
    private let coordinateFormatterController: CoordinateFormatterController
    private let arcgisNativeObjectsController: ArcgisNativeObjectsController

    init(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel", binaryMessenger: registrar.messenger())
        geometryController = GeometryEngineController(messenger: registrar.messenger())
        coordinateFormatterController = CoordinateFormatterController(messenger: registrar.messenger())
        arcgisNativeObjectsController = ArcgisNativeObjectsController(messenger: registrar.messenger(), factory: ArcgisNativeObjectFactoryImpl())

        super.init()

        registrar.addMethodCallDelegate(self, channel: channel)
    }


    public static func register(with registrar: FlutterPluginRegistrar) {
        let _ = SwiftArcgisMapsFlutterPlugin(with: registrar)
        registrar.register(ArcgisMapFactory(registrar: registrar),
                withId: "plugins.flutter.io/arcgis_maps",
                gestureRecognizersBlockingPolicy: FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded)
    }

    public func handle(_ call: FlutterMethodCall,
                       result: @escaping FlutterResult) {
        switch call.method {
        case "arcgis#setApiKey":
            let apiKey = call.arguments as! String
            ArcGISEnvironment.apiKey =  ArcGIS.APIKey.init(rawValue: apiKey)
            result(nil)
            break
        case "arcgis#getApiKey":
            result(ArcGISEnvironment.apiKey?.rawValue)
            break
        case "arcgis#setLicense":
            let rawLicenseKey = call.arguments as! String
            let licenseKey = LicenseKey(rawValue: rawLicenseKey)!
            do{
                let licenseResult = try ArcGISEnvironment.setLicense(with: licenseKey)
                result(licenseResult.licenseStatus.toFlutterValue())
            }catch{
                result(License.Status.invalid.toFlutterValue())
            }
            break
        case "arcgis#getApiVersion":
            result("--")
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        NativeObjectStorage.shared.clearAll()
    }
}
