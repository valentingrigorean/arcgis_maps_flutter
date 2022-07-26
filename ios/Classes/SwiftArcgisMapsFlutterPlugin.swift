import Flutter
import UIKit
import ArcGIS


public class SwiftArcgisMapsFlutterPlugin: NSObject, FlutterPlugin {

    private let channel: FlutterMethodChannel
    private let geometryController: GeometryEngineController
    private let locatorTaskController: LocatorTaskController
    private let routeTaskController: RouteTaskController
    private let offlineMapTaskController: OfflineMapTaskController
    private let coordinateFormatterController: CoordinateFormatterController
    private let arcgisNativeObjectsController: ArcgisNativeObjectsController

    init(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_channel", binaryMessenger: registrar.messenger())
        geometryController = GeometryEngineController(messenger: registrar.messenger())
        locatorTaskController = LocatorTaskController(messenger: registrar.messenger())
        coordinateFormatterController = CoordinateFormatterController(messenger: registrar.messenger())
        routeTaskController = RouteTaskController(messenger: registrar.messenger())
        offlineMapTaskController = OfflineMapTaskController(messenger: registrar.messenger())
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
            result("--")
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
