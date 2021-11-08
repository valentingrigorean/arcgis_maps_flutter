//
// Created by Valentin Grigorean on 23.03.2021.
//

import Foundation
import ArcGIS

public class ArcgisMapController: NSObject, FlutterPlatformView {

    private let mapWorkerQueue = DispatchQueue(label: "mapWorkerQueue")
    private let mapView: AGSMapView
    private let selectionPropertiesHandler: SelectionPropertiesHandler

    private let channel: FlutterMethodChannel
    private let layersController: LayersController
    private let markersController: MarkersController
    private let polygonsController: PolygonsController
    private let polylinesController: PolylinesController


    private let symbolVisibilityFilterController: SymbolVisibilityFilterController

    private let scaleBarController: ScaleBarController

    private let layersChangedController: LayersChangedController

    private var lastScreenPoint = CGPoint.zero

    private var graphicsTouchDelegates: [MapGraphicTouchDelegate]

    private let symbolsControllers: [SymbolsController]

    private var viewpoint: AGSViewpoint?

    private var graphicsHandle: AGSCancelable?

    private var layerHandle: AGSCancelable?

    private var trackCameraPosition = false

    private var trackIdentityLayers = false

    private var trackViewpointChangedListenerEvent = false

    private var haveScaleBar = false

    private var legendInfoControllers = Array<LegendInfoController>()

    private var timeExtentObservation: NSKeyValueObservation?


    public init(
            withRegistrar registrar: FlutterPluginRegistrar,
            withFrame frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?) {

        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_maps_\(viewId)", binaryMessenger: registrar.messenger())

        mapView = AGSMapView(frame: frame)
        mapView.selectionProperties = AGSSelectionProperties(color: UIColor.cyan)

        selectionPropertiesHandler = SelectionPropertiesHandler(selectionProperties: mapView.selectionProperties)

        symbolVisibilityFilterController = SymbolVisibilityFilterController(workerQueue: mapWorkerQueue, mapView: mapView)

        let graphicsOverlay = AGSGraphicsOverlay()
        polygonsController = PolygonsController(methodChannel: channel, graphicsOverlays: graphicsOverlay, workerQueue: mapWorkerQueue)
        polylinesController = PolylinesController(methodChannel: channel, graphicsOverlays: graphicsOverlay, workerQueue: mapWorkerQueue)
        markersController = MarkersController(methodChannel: channel, graphicsOverlays: graphicsOverlay, workerQueue: mapWorkerQueue)

        symbolsControllers = [polygonsController, polylinesController, markersController]

        mapView.graphicsOverlays.add(graphicsOverlay)

        graphicsTouchDelegates = [markersController, polygonsController, polylinesController]

        layersController = LayersController(methodChannel: channel)

        scaleBarController = ScaleBarController(mapView: mapView)

        layersChangedController = LayersChangedController(geoView: mapView, channel: channel, layersController: layersController)

        super.init()

        initSymbolsControllers()

        mapView.touchDelegate = self
        mapView.locationDisplay.autoPanModeChangedHandler = onAutoPanModeChanged
        mapView.viewpointChangedHandler = viewpointChangedHandler
        channel.setMethodCallHandler(handle)
        initWithArgs(args: args)
    }

    deinit {
        timeExtentObservation?.invalidate()
        timeExtentObservation = nil
        clearSymbolsControllers()
        symbolVisibilityFilterController.clear()
        mapView.locationDisplay.autoPanModeChangedHandler = nil
        mapView.viewpointChangedHandler = nil
    }

    public func view() -> UIView {
        mapView
    }

    private func handle(_ call: FlutterMethodCall,
                        result: @escaping FlutterResult) -> Void {

        switch call.method {
        case "map#waitForMap":
            result(nil)
            break
        case "map#update":
            if let data = call.arguments as? Dictionary<String, Any> {
                if let mapOptions = data["options"] as? Dictionary<String, Any> {
                    updateMapOptions(mapOptions: mapOptions)
                }
            }
            result(nil)
            break
        case "map#getLegendInfos":
            let legendInfoController = LegendInfoController(layersController: layersController)
            legendInfoController.loadAsync(args: call.arguments, result: { [weak self] items in
                result(items)
                guard let self = self else {
                    return
                }
                self.legendInfoControllers = self.legendInfoControllers.filter {
                    $0 !== legendInfoController
                }
            })
            legendInfoControllers.append(legendInfoController)
            break
        case "map#setMap":
            let viewPoint = mapView.currentViewpoint(with: AGSViewpointType.centerAndScale)
            changeMapType(args: call.arguments)
            if viewPoint != nil {
                mapView.setViewpoint(viewPoint!, duration: 0)
            }
            result(nil)
            break
        case "map#setViewpointChangedListenerEvents":
            if let val = call.arguments as? Bool {
                trackViewpointChangedListenerEvent = val
            }
            result(nil)
            break
        case "map#setLayersChangedListener":
            if let val = call.arguments as? Bool {
                layersChangedController.trackLayersChange = val
            }
            result(nil)
            break
        case "map#setTimeExtentChanged":
            if let val = call.arguments as? Bool {
                if val, timeExtentObservation == nil {
                    timeExtentObservation = mapView.observe(\.timeExtent, options: .new) { [weak self] (_,
                                                                                                        _) in
                        guard let self = self else {
                            return
                        }
                        self.onTimeExtentChanged(timeExtent: self.mapView.timeExtent)
                    }
                } else {
                    timeExtentObservation?.invalidate()
                    timeExtentObservation = nil
                }
            }
            result(nil)
            break
        case "map#setTimeExtent":
            if let timeExtentRaw = call.arguments as? Dictionary<String, Any> {
                let timeExtent = AGSTimeExtent(data: timeExtentRaw)
                if mapView.timeExtent != timeExtent {
                    mapView.timeExtent = timeExtent
                }
            } else {
                mapView.timeExtent = nil
            }
            print("map#setTimeExtent")
            break
        case "map#getTimeExtent":
            result(mapView.timeExtent?.toJSONFlutter())
            break
        case "map#getMapRotation":
            result(mapView.rotation)
            break
        case "map#getWanderExtentFactor":
            result(mapView.locationDisplay.wanderExtentFactor)
            break
        case "map#getTimeAwareLayerInfos":
            handleTimeAwareLayerInfos(result: result)
            break
        case "map#getCurrentViewpoint":
            let type = (call.arguments as! Int).toAGSViewpointType()
            let currentViewPoint = mapView.currentViewpoint(with: type)
            if let json = try? currentViewPoint?.toJSON() {
                result(json)
            } else {
                result(nil)
            }
            break
        case "map#setViewpoint":
            setViewpoint(args: call.arguments, animated: true)
            result(nil)
            break
        case "map#setViewpointRotation":
            if let angleDegrees = call.arguments as? Double {
                mapView.setViewpointRotation(angleDegrees)
            }
            result(nil)
            break
        case "map#isLocationDisplayStarted":
            result(mapView.locationDisplay.started)
            break
        case "map#setLocationDisplay":
            if let started = call.arguments as? Bool {
                if mapView.locationDisplay.started != started {
                    if started {
                        mapView.locationDisplay.start()
                    } else {
                        mapView.locationDisplay.stop()
                    }
                }
            }
            result(nil)
            break
        case "map#locationToScreen":
            if let mapPointData = call.arguments as? Dictionary<String, Any> {
                let screenPoint = mapView.location(toScreen: AGSPoint(data: mapPointData))
                result([screenPoint.x, screenPoint.y])
            } else {
                result(nil)
            }
            break
        case "map#screenToLocation":
            if let data = call.arguments as? Dictionary<String, Any> {
                let mapPoints = data["position"] as! [Double]
                var mapPoint = mapView.screen(toLocation: CGPoint(x: mapPoints[0], y: mapPoints[1]))
                if let spatialReference = AGSSpatialReference(data: data["spatialReference"] as! Dictionary<String, Any>) {
                    if spatialReference.wkid != mapPoint.spatialReference?.wkid {
                        mapPoint = AGSGeometryEngine.projectGeometry(mapPoint, to: spatialReference) as! AGSPoint
                    }
                }
                result(try? mapPoint.toJSON())
            } else {
                result(nil)
            }
            break
        case "map#getMapScale":
            result(mapView.mapScale)
            break
        case "layers#update":
            layersController.updateFromArgs(args: call.arguments as Any)
            result(nil)
            break
        case "markers#update":
            if let markersUpdate = call.arguments as? Dictionary<String, Any> {
                if let markersToAdd = markersUpdate["markersToAdd"] as? [Dictionary<String, Any>] {
                    markersController.addMarkers(markersToAdd: markersToAdd)
                }
                if let markersToChange = markersUpdate["markersToChange"] as? [Dictionary<String, Any>] {
                    markersController.changeMarkers(markersToChange: markersToChange)
                }
                if let markerIdsToRemove = markersUpdate["markerIdsToRemove"] as? [String] {
                    markersController.removeMarkers(markerIdsToRemove: markerIdsToRemove)
                }
            }
            result(nil)
            break
        case "map#clearMarkerSelection":
            selectionPropertiesHandler.reset()
            markersController.clearSelectedMarker()
            result(nil)
            break
        case "polygons#update":
            if let polygonUpdates = call.arguments as? Dictionary<String, Any> {
                if let polygonsToAdd = polygonUpdates["polygonsToAdd"] as? [Dictionary<String, Any>] {
                    polygonsController.addPolygons(polygonsToAdd: polygonsToAdd)
                }
                if let polygonsToChange = polygonUpdates["polygonsToChange"] as? [Dictionary<String, Any>] {
                    polygonsController.changePolygons(polygonsToChange: polygonsToChange)
                }
                if let polygonIdsToRemove = polygonUpdates["polygonIdsToRemove"] as? [String] {
                    polygonsController.removePolygons(polygonIdsToRemove: polygonIdsToRemove)
                }
            }
            result(nil)
            break
        case "polylines#update":
            if let polylineUpdates = call.arguments as? Dictionary<String, Any> {
                if let polylinesToAdd = polylineUpdates["polylinesToAdd"] as? [Dictionary<String, Any>] {
                    polylinesController.addPolylines(polylinesToAdd: polylinesToAdd)
                }
                if let polylinesToChange = polylineUpdates["polylinesToChange"] as? [Dictionary<String, Any>] {
                    polylinesController.changePolylines(polylinesToChange: polylinesToChange)
                }
                if let polylineIdsToRemove = polylineUpdates["polylineIdsToRemove"] as? [String] {
                    polylinesController.removePolylines(polylineIdsToRemove: polylineIdsToRemove)
                }
            }
            result(nil)
            break
        case "layer#setTimeOffset":
            layersController.setTimeOffset(arguments: call.arguments)
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    private func handleTimeAwareLayerInfos(result: @escaping FlutterResult) {
        guard  let layers = mapView.map?.operationalLayers as AnyObject as? [AGSLayer], layers.count > 0 else {
            result([])
            return
        }

        AGSLoadObjects(layers) { [weak self] (loaded) in

            guard loaded else {
                result([])
                return
            }

            guard let self = self else {
                result([])
                return
            }

            var timeAwareLayers = [AGSTimeAware]()

            layers.forEach { (layer) in
                guard let timeAwareLayer = layer as? AGSTimeAware else {
                    return
                }
                timeAwareLayers.append(timeAwareLayer)
            }

            result(timeAwareLayers.map { (layer) -> Any in
                var layerId: String?
                if layer is AGSLayer {
                    layerId = self.layersController.getLayerIdByLayer(layer: layer as! AGSLayer)
                }
                return layer.toJSONFlutter(layerId: layerId)
            })
        }
    }

    private func initSymbolsControllers() {
        for var controller in symbolsControllers {
            controller.selectionPropertiesHandler = selectionPropertiesHandler
            controller.symbolVisibilityFilterController = symbolVisibilityFilterController
        }
    }

    private func clearSymbolsControllers() {
        for var controller in symbolsControllers {
            controller.selectionPropertiesHandler = nil
            controller.symbolVisibilityFilterController = nil
        }
    }

    private func onTimeExtentChanged(timeExtent: AGSTimeExtent?) {
        channel.invokeMethod("map#timeExtentChanged", arguments: timeExtent?.toJSONFlutter())
    }

    private func onAutoPanModeChanged(autoPanMode: AGSLocationDisplayAutoPanMode) {
        channel.invokeMethod("map#autoPanModeChanged", arguments: autoPanMode.rawValue)
    }

    private func viewpointChangedHandler() {

        if trackViewpointChangedListenerEvent {
            channel.invokeMethod("map#viewpointChanged", arguments: nil)
        }

        if trackCameraPosition {
            channel.invokeMethod("camera#onMove", arguments: nil)
        }
    }

    private func changeMapType(args: Any?) {
        guard  let dict = args as? Dictionary<String, Any> else {
            return
        }

        let map = AGSMap(data: dict)
        map.load { [weak self]  error in
            guard let channel = self?.channel else {
                return
            }

            channel.invokeMethod("map#loaded", arguments: error?.toJSON())
        }
        mapView.map = map
        layersController.setMap(map)
    }

    private func updateMapOptions(mapOptions: Dictionary<String, Any>) {

        if let interactionOptions = mapOptions["interactionOptions"] as? Dictionary<String, Any> {
            updateInteractionOptions(interactionOptions: interactionOptions)
        }

        if let myLocationEnabled = mapOptions["myLocationEnabled"] as? Bool {
            mapView.locationDisplay.showLocation = myLocationEnabled
            if myLocationEnabled {
                mapView.locationDisplay.start()
            } else {
                mapView.locationDisplay.stop()
            }
        }

        if let trackIdentityLayers = mapOptions["trackIdentifyLayers"] as? Bool {
            self.trackIdentityLayers = trackIdentityLayers
        }

        if let trackCameraPosition = mapOptions["trackCameraPosition"] as? Bool {
            self.trackCameraPosition = trackCameraPosition
        }

        if let autoPanMode = mapOptions["autoPanMode"] as? Int {
            mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanMode(rawValue: autoPanMode) ?? .off
        }

        if let wanderExtentFactor = mapOptions["wanderExtentFactor"] as? Double {
            mapView.locationDisplay.wanderExtentFactor = Float(wanderExtentFactor)
        }

        if let haveScaleBar = mapOptions["haveScalebar"] as? Bool {
            if self.haveScaleBar && !haveScaleBar {
                scaleBarController.removeScaleBar()
            }
        }

        if let scalebarConfiguration = mapOptions["scalebarConfiguration"] {
            scaleBarController.interpretConfiguration(args: scalebarConfiguration)
        }
    }

    private func updateInteractionOptions(interactionOptions: Dictionary<String, Any>) {
        if let isEnabled = interactionOptions["isEnabled"] as? Bool {
            mapView.interactionOptions.isEnabled = isEnabled
        }
        if let isRotateEnabled = interactionOptions["isRotateEnabled"] as? Bool {
            mapView.interactionOptions.isRotateEnabled = isRotateEnabled
        }
        if let isPanEnabled = interactionOptions["isPanEnabled"] as? Bool {
            mapView.interactionOptions.isPanEnabled = isPanEnabled
        }
        if let isZoomEnabled = interactionOptions["isZoomEnabled"] as? Bool {
            mapView.interactionOptions.isZoomEnabled = isZoomEnabled
        }
        if let isMagnifierEnabled = interactionOptions["isMagnifierEnabled"] as? Bool {
            mapView.interactionOptions.isMagnifierEnabled = isMagnifierEnabled
        }
        if let allowMagnifierToPan = interactionOptions["allowMagnifierToPan"] as? Bool {
            mapView.interactionOptions.allowMagnifierToPan = allowMagnifierToPan
        }
    }

    private func setViewpoint(args: Any?,
                              animated: Bool) {
        guard let data = args as? Dictionary<String, Any> else {
            return
        }

        let newViewpoint = AGSViewpoint(data: data)
        viewpoint = newViewpoint

        if animated {
            mapView.setViewpoint(newViewpoint, completion: nil)
        } else {
            mapView.setViewpoint(newViewpoint, duration: 0)
        }
    }

    private func initWithArgs(args: Any?) {
        guard  let dict = args as? Dictionary<String, Any> else {
            return
        }
        if let mapType = dict["map"] {
            changeMapType(args: mapType)
        }
        if let viewPoint = dict["viewpoint"] {
            setViewpoint(args: viewPoint, animated: false)
        }

        layersController.updateFromArgs(args: dict)
        if let markersToAdd = dict["markersToAdd"] as? [Dictionary<String, Any>] {
            markersController.addMarkers(markersToAdd: markersToAdd)
        }

        if let polygonsToAdd = dict["polygonsToAdd"] as? [Dictionary<String, Any>] {
            polygonsController.addPolygons(polygonsToAdd: polygonsToAdd)
        }

        if let polylinesToAdd = dict["polylinesToAdd"] as? [Dictionary<String, Any>] {
            polylinesController.addPolylines(polylinesToAdd: polylinesToAdd)
        }

        if let options = dict["options"] as? Dictionary<String, Any> {
            updateMapOptions(mapOptions: options)
        }
    }

}

extension ArcgisMapController: AGSGeoViewTouchDelegate {

    public func geoView(_ geoView: AGSGeoView,
                        didTapAtScreenPoint screenPoint: CGPoint,
                        mapPoint: AGSPoint) {
        graphicsHandle?.cancel()
        layerHandle?.cancel()

        lastScreenPoint = screenPoint

        if canConsumeGraphics() {
            graphicsHandle = mapView.identifyGraphicsOverlays(atScreenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false, completion: identifyGraphicsOverlaysCallback)
        } else if trackIdentityLayers {
            layerHandle = mapView.identifyLayers(atScreenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false, completion: identifyLayersCallback)
        } else {
            sendOnMapTap(screenPoint: screenPoint)
        }
    }


    public func geoView(_ geoView: AGSGeoView, didLongPressAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        sendOnMapLongPress(screenPoint: screenPoint)
    }


    private func identifyGraphicsOverlaysCallback(results: [AGSIdentifyGraphicsOverlayResult]?,
                                                  error: Error?) {
        graphicsHandle = nil
        if error != nil {
            return
        }

        if onTapGraphicsCompleted(results: results, screenPoint: lastScreenPoint) {
            return
        }

        if trackIdentityLayers {
            layerHandle = mapView.identifyLayers(atScreenPoint: lastScreenPoint, tolerance: 12, returnPopupsOnly: false, completion: identifyLayersCallback)
        } else {
            sendOnMapTap(screenPoint: lastScreenPoint)
        }
    }

    private func identifyLayersCallback(results: [AGSIdentifyLayerResult]?,
                                        error: Error?) {
        layerHandle = nil
        if error != nil {
            return
        }
        guard let results = results else {
            sendOnMapTap(screenPoint: lastScreenPoint)
            return
        }
        if results.isEmpty {
            sendOnMapTap(screenPoint: lastScreenPoint)
            return
        }

        channel.invokeMethod("map#onIdentifyLayers", arguments: results.toJSONFlutter())
    }

    private func onTapGraphicsCompleted(results: [AGSIdentifyGraphicsOverlayResult]?,
                                        screenPoint: CGPoint) -> Bool {
        if results != nil {
            for result in results! {
                for graphic in result.graphics {
                    for del in graphicsTouchDelegates {
                        if del.didHandleGraphic(graphic: graphic) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }

    private func canConsumeGraphics() -> Bool {
        for del in graphicsTouchDelegates {
            if del.canConsumeTaps() {
                return true
            }
        }
        return false
    }

    private func sendOnMapTap(screenPoint: CGPoint) {
        if let json = try? mapView.screen(toLocation: screenPoint).toJSON() {
            channel.invokeMethod("map#onTap", arguments: ["screenPoint": screenPoint.toJSON(), "position": json])
        }
    }

    private func sendOnMapLongPress(screenPoint: CGPoint) {
        if let json = try? mapView.screen(toLocation: screenPoint).toJSON() {
            channel.invokeMethod("map#onLongPress", arguments: ["screenPoint": screenPoint.toJSON(), "position": json])
        }
    }
}


