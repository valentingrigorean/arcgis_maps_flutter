//
// Created by Valentin Grigorean on 14.04.2022.
//

import Foundation
import ArcGIS

fileprivate let LOCATION_ATTRIBUTE_NAME = "my_location_attribute"

class LocationDisplayController {

    private let mapView: AGSMapView
    private let locationDisplay: AGSLocationDisplay
    private let locationGraphicsOverlay: AGSGraphicsOverlay
    private let locationGraphic: AGSGraphic

    private let methodChannel: FlutterMethodChannel

    init(methodChannel: FlutterMethodChannel, mapView: AGSMapView) {
        self.methodChannel = methodChannel
        self.mapView = mapView
        locationDisplay = mapView.locationDisplay

        locationGraphicsOverlay = AGSGraphicsOverlay()
        locationGraphicsOverlay.opacity = 0;
        locationGraphic = AGSGraphic()
        locationGraphic.attributes[LOCATION_ATTRIBUTE_NAME] = true
        locationGraphic.symbol = locationDisplay.defaultSymbol
        locationGraphic.zIndex = Int.max
        locationGraphicsOverlay.graphics.add(locationGraphic)
        locationDisplay.autoPanModeChangedHandler = autoPanModeChanged
        locationDisplay.locationChangedHandler = locationChanged


        self.methodChannel.setMethodCallHandler(handle)
    }

    deinit {
        locationDisplay.autoPanModeChangedHandler = nil
        locationDisplay.locationChangedHandler = nil
        methodChannel.setMethodCallHandler(nil)
    }


    var trackUserLocationTap: Bool = false {
        didSet {
            if (trackUserLocationTap) {
                mapView.graphicsOverlays.add(locationGraphicsOverlay)
            } else {
                mapView.graphicsOverlays.remove(locationGraphicsOverlay)
            }
        }
    }

    open var locationTapHandler: (() -> Void)?

    private func handle(_ call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {

        switch (call.method) {
        case "getStarted":
            result(locationDisplay.started)
            break
        case "setAutoPanMode":
            locationDisplay.autoPanMode = AGSLocationDisplayAutoPanMode(rawValue: call.arguments as! Int) ?? .off
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
            locationDisplay.useCourseSymbolOnMovement = call.arguments as! Bool
            result(nil)
            break
        case "setOpacity":
            locationGraphicsOverlay.opacity = call.arguments as! Float
            result(nil)
            break
        case "setShowAccuracy":
            locationDisplay.showAccuracy = call.arguments as! Bool
            result(nil)
            break
        case "setShowLocation":
            locationDisplay.showLocation = call.arguments as! Bool
            result(nil)
            break
        case "setShowPingAnimationSymbol":
            locationDisplay.showPingAnimationSymbol = call.arguments as! Bool
            result(nil)
            break
        case "start":
            locationDisplay.start { (error) in
                if let error = error {
                    result(FlutterError(code: "start", message: error.localizedDescription, details: nil))
                } else {
                    result(nil)
                }
            }
            break
        case "stop":
            locationDisplay.stop()
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func autoPanModeChanged(_ mode: AGSLocationDisplayAutoPanMode) {
        methodChannel.invokeMethod("onAutoPanModeChanged", arguments: mode.rawValue)
    }

    private func locationChanged(location: AGSLocation) {
        methodChannel.invokeMethod("onLocationChanged", arguments: location.toJSONFlutter())
        guard let position = location.position else {
            return
        }
        locationGraphic.geometry = position
    }
}


extension LocationDisplayController: MapGraphicTouchDelegate {
    func canConsumeTaps() -> Bool {
        trackUserLocationTap
    }

    func didHandleGraphic(graphic: AGSGraphic) -> Bool {
        let result = graphic.attributes[LOCATION_ATTRIBUTE_NAME] != nil
        if result {
            locationTapHandler?()
        }
        return result
    }
}