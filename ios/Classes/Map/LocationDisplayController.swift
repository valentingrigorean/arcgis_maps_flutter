//
// Created by Valentin Grigorean on 14.04.2022.
//

import Foundation
import ArcGIS

fileprivate let LOCATION_ATTRIBUTE_NAME = "arcgis_flutter_my_location_attribute"

class LocationDisplayController {

    private let taskManager = TaskManager()
    private let locationDisplay: LocationDisplay
    private let locationGraphicsOverlay: GraphicsOverlay
    private let locationGraphic: Graphic

    private let methodChannel: FlutterMethodChannel

    private let mapViewModel: MapViewModel

    private func dataSourceStatusChanged(status: Bool) {

        locationGraphic.geometry = locationDisplay.mapLocation
    }

    init(methodChannel: FlutterMethodChannel, mapViewModel: MapViewModel) {
        self.methodChannel = methodChannel
        self.mapViewModel = mapViewModel
        locationDisplay = mapViewModel.locationDisplay
        locationGraphicsOverlay = GraphicsOverlay()
        locationGraphicsOverlay.opacity = 0;
        locationGraphic = Graphic()
        locationGraphic.setAttributeValue(true, forKey: LOCATION_ATTRIBUTE_NAME)
        locationGraphic.symbol = locationDisplay.defaultSymbol
        locationGraphic.zIndex = Int.max
        locationGraphic.geometry = locationDisplay.mapLocation
        locationGraphicsOverlay.addGraphic(locationGraphic)

        taskManager.createTask {
            for await autoPanMode in self.locationDisplay.$autoPanMode {
                self.methodChannel.invokeMethod("onAutoPanModeChanged", arguments: autoPanMode.toFlutterValue())
            }
        }

        taskManager.createTask {
            for await location in self.locationDisplay.$location {
                self.locationGraphic.geometry = location?.position
                if let location = location {
                    methodChannel.invokeMethod("onLocationChanged", arguments: location.toJSONFlutter())
                }
            }
        }

        setMethodCallHandlers()
    }

    deinit {
        methodChannel.setMethodCallHandler(nil)
    }


    var trackUserLocationTap: Bool = false {
        didSet {
            if (trackUserLocationTap) {
                mapViewModel.addGraphicOverlay(locationGraphicsOverlay)
            } else {
                mapViewModel.removeGraphicOverlay(locationGraphicsOverlay)
            }
        }
    }

    private func setMethodCallHandlers() -> Void {
        methodChannel.setMethodCallHandler({ [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self else {
                return
            }
            self.methodCallHandler(call: call, result: result)
        })
    }

    private func methodCallHandler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "getStarted":
            result(locationDisplay.dataSource.status == .started)
            break
        case "setAutoPanMode":
            locationDisplay.autoPanMode = LocationDisplay.AutoPanMode(call.arguments as! Int)
            result(nil)
            break
        case "setInitialZoomScale":
            locationDisplay.initialZoomScale = call.arguments as! Double
            result(nil)
            break
        case "setNavigationPointHeightFactor":
            locationDisplay.navigationPointHeightFactor = call.arguments as! Float
            result(nil)
            break
        case "setWanderExtentFactor":
            locationDisplay.wanderExtentFactor = call.arguments as! Float
            result(nil)
            break
        case "getLocation":
            result(locationDisplay.location?.toJSONFlutter())
            break
        case "getMapLocation":
            result(locationDisplay.mapLocation?.toJSONFlutter())
            break
        case "getHeading":
            result(locationDisplay.heading)
            break
        case "setUseCourseSymbolOnMovement":
            locationDisplay.usesCourseSymbolOnMovement = call.arguments as! Bool
            result(nil)
            break
        case "setOpacity":
            locationGraphicsOverlay.opacity = call.arguments as! Float
            result(nil)
            break
        case "setShowAccuracy":
            locationDisplay.showsAccuracy = call.arguments as! Bool
            result(nil)
            break
        case "setShowLocation":
            locationDisplay.showsLocation = call.arguments as! Bool
            result(nil)
            break
        case "setShowPingAnimationSymbol":
            locationDisplay.showsPingAnimationSymbol = call.arguments as! Bool
            result(nil)
            break
        case "start":
            taskManager.createTask {
                do {
                    try await self.locationDisplay.dataSource.start()
                    result(nil)
                } catch {
                    result(FlutterError(code: "start", message: error.localizedDescription, details: nil))
                }
            }
            break
        case "stop":
            taskManager.createTask {
                await self.locationDisplay.dataSource.stop()
                result(nil)
            }
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}


extension LocationDisplayController: MapGraphicTouchDelegate {
    func canConsumeTaps() -> Bool {
        trackUserLocationTap
    }

    func didHandleGraphic(graphic: Graphic) -> Bool {
        let result = graphic.attributes[LOCATION_ATTRIBUTE_NAME] != nil
        if result {
            methodChannel.invokeMethod("map#onUserLocationTap", arguments: nil)
        }
        return result
    }
}
