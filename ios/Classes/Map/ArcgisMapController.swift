//
// Created by Valentin Grigorean on 23.03.2021.
//

import Foundation
import SwiftUI
import ArcGIS
import Combine


public class ArcgisMapController: NSObject, FlutterPlatformView {

    private let taskManager = TaskManager()
    private let viewModel = MapViewModel()
    private let hostingView = HostingView()

    private let selectionPropertiesHandler: SelectionPropertiesHandler

    private let channel: FlutterMethodChannel
    private let layersController: LayersController
    private let markersController: MarkersController
    private let polygonsController: PolygonsController
    private let polylinesController: PolylinesController

    private let legendInfoController: LegendInfoController

    private let locationDisplayController: LocationDisplayController

    private let symbolVisibilityFilterController: SymbolVisibilityFilterController

    private let geoViewTouchDelegate: GeoViewTouchDelegate

    private var lastScreenPoint = CGPoint.zero

    private let symbolsControllers: [SymbolsController]

    private var cancellables = Set<AnyCancellable>()

    private var trackIdentityLayers = false

    private var trackTimeExtent = false

    private var trackViewpointChangedListenerEvent = false

    private var haveScaleBar = false

    public init(
            withRegistrar registrar: FlutterPluginRegistrar,
            withFrame frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?) {

        channel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_maps_\(viewId)", binaryMessenger: registrar.messenger())

        hostingView.frame = frame
        hostingView.setView(AnyView(MapContentView(viewModel: viewModel)))


        selectionPropertiesHandler = SelectionPropertiesHandler(mapViewModel: viewModel)

        symbolVisibilityFilterController = SymbolVisibilityFilterController(mapViewModel: viewModel)

        let graphicsOverlay = GraphicsOverlay()
        polygonsController = PolygonsController(methodChannel: channel, graphicsOverlays: graphicsOverlay)
        polylinesController = PolylinesController(methodChannel: channel, graphicsOverlays: graphicsOverlay)
        markersController = MarkersController(methodChannel: channel, graphicsOverlays: graphicsOverlay)

        symbolsControllers = [polygonsController, polylinesController, markersController]

        viewModel.addGraphicOverlay(graphicsOverlay)


        layersController = LayersController(methodChannel: channel)

        let locationDisplayChannel = FlutterMethodChannel(name: "plugins.flutter.io/arcgis_maps_\(viewId)_location_display", binaryMessenger: registrar.messenger())
        locationDisplayController = LocationDisplayController(methodChannel: locationDisplayChannel, mapViewModel: viewModel)

        geoViewTouchDelegate = GeoViewTouchDelegate(methodChannel: channel, viewModel: viewModel)
        geoViewTouchDelegate.addDelegates(graphicTouchDelegates: [markersController, polygonsController, polylinesController, locationDisplayController])


        legendInfoController = LegendInfoController(layersController: layersController)

        super.init()

        setMethodCallHandlers()

        initSymbolsControllers()

        viewModel.$viewpoint.sink { _ in
                    self.viewpointChangedHandler()
                }
                .store(in: &cancellables)
        initWithArgs(args: args)
    }

    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
        cancellables.removeAll()
        hostingView.removeView()
        channel.setMethodCallHandler(nil)
        clearSymbolsControllers()
        symbolVisibilityFilterController.clear()
    }

    public func view() -> UIView {
        hostingView
    }

    private func setMethodCallHandlers() -> Void {
        channel.setMethodCallHandler({ [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self else {
                return
            }
            self.methodCallHandler(call: call, result: result)
        })
    }

    private func methodCallHandler(call: FlutterMethodCall, result: @escaping FlutterResult) {
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
        case "map#exportImage":
            guard let proxyView = viewModel.mapViewProxy else {
                result(nil)
                break
            }
            taskManager.createTask {
                do {
                    let image = try await proxyView.exportImage()
                    result(image.pngData())
                } catch {
                    result(FlutterError(code: "exportImage_error", message: error.localizedDescription, details: nil))
                }
            }
            break
        case "map#getLegendInfos":
            taskManager.createTask {
                result(await self.legendInfoController.loadAsync(args: call.arguments))
            }
            break
        case "map#getMapMaxExtend":
            let map = viewModel.map
            let extent = map.maxExtent
            result(extent?.toJSONFlutter())
            break
        case "map#getLocation":
            let location = viewModel.locationDisplay.location
            if location == nil {
                result(nil)
            } else {
                result(location!.toJSONFlutter())
            }
            break
        case "map#getMapLocation":
            let mapLocation = viewModel.locationDisplay.mapLocation
            if mapLocation == nil {
                result(nil)
            } else {
                result(mapLocation!.toJSONFlutter())
            }
            break
        case "map#setMapMaxExtent":
            if let extent = call.arguments as? Dictionary<String, Any> {
                let maxExtent = Envelope(data: extent)
                viewModel.map.maxExtent = maxExtent
            }
            result(nil)
            break
        case "map#setMap":
            changeMapType(args: call.arguments)
            result(nil)
            break
        case "map#setViewpointChangedListenerEvents":
            if let val = call.arguments as? Bool {
                trackViewpointChangedListenerEvent = val
            }
            result(nil)
            break
        case "map#setTimeExtentChangedListener":
            if let val = call.arguments as? Bool {
                trackTimeExtent = val
            }
            result(nil)
            break
        case "map#setTimeExtent":
            if let timeExtentRaw = call.arguments as? Dictionary<String, Any> {
                let timeExtent = TimeExtent(data: timeExtentRaw)
                if viewModel.timeExtent != timeExtent {
                    viewModel.timeExtent = timeExtent
                }
            } else {
                viewModel.timeExtent = nil
            }
            print("map#setTimeExtent")
            break
        case "map#getTimeExtent":
            result(viewModel.timeExtent?.toJSONFlutter())
            break
        case "map#getMapRotation":
            result(viewModel.rotation)
            break
        case "map#getWanderExtentFactor":
            result(viewModel.locationDisplay.wanderExtentFactor)
            break
        case "map#queryFeatureTableFromLayer":
            handleQueryFeatureTableFromLayer(data: call.arguments as! Dictionary<String, Any>, result: result)
            break
        case "map#getTimeAwareLayerInfos":
            handleTimeAwareLayerInfos(result: result)
            break
        case "map#getCurrentViewpoint":
            let type = Viewpoint.Kind(call.arguments as! Int)
            let currentViewPoint = type == .centerAndScale ? viewModel.viewpointCenterAndScale : viewModel.viewpointBoundingGeometry
            result(currentViewPoint?.toJSON())
            break
        case "map#getInitialViewpoint":
            result(viewModel.map.initialViewpoint?.toJSON())
            break
        case "map#setViewpoint":
            setViewpoint(args: call.arguments, animated: true, result: result)
            break
        case "map#setViewpointGeometry":
            guard let proxyView = viewModel.mapViewProxy else {
                result(false)
                break
            }
            taskManager.createTask {
                let data = call.arguments as! Dictionary<String, Any>
                let geometry = Geometry.fromFlutter(data: data["geometry"] as! Dictionary<String, Any>)!
                result(await proxyView.setViewpointGeometry(geometry.extent, padding: data["padding"] as? Double ?? 0))
            }
            break
        case "map#setViewpointCenter":
            guard let proxyView = viewModel.mapViewProxy else {
                result(false)
                break
            }
            taskManager.createTask {
                let data = call.arguments as! Dictionary<String, Any>
                let center = Point.fromFlutter(data: data["center"] as! Dictionary<String, Any>)! as! Point
                let scale = data["scale"] as! Double
                result(await proxyView.setViewpointCenter(center, scale: scale))
            }
            break
        case "map#setViewpointRotation":
            guard let proxyView = viewModel.mapViewProxy else {
                result(false)
                break
            }
            taskManager.createTask {
                result(await proxyView.setViewpointRotation(call.arguments as! Double))
            }
            break
        case "map#setViewpointScaleAsync":
            guard let proxyView = viewModel.mapViewProxy else {
                result(false)
                break
            }
            taskManager.createTask {
                let data = call.arguments as! Dictionary<String, Any>
                let scale = data["scale"] as! Double
                result(await proxyView.setViewpointScale(scale))
            }
            break
        case "map#locationToScreen":
            guard let proxyView = viewModel.mapViewProxy else {
                result(nil)
                break
            }
            if let screenPoint = proxyView.screenPoint(fromLocation: Point(data: call.arguments as! Dictionary<String, Any>)) {
                result([screenPoint.x, screenPoint.y])
            } else {
                result(nil)
            }
            break
        case "map#screenToLocation":
            guard let proxyView = viewModel.mapViewProxy else {
                result(nil)
                break
            }
            let data = call.arguments as! Dictionary<String, Any>
            let mapPoints = data["position"] as! [Double]
            var mapPoint = proxyView.location(fromScreenPoint: CGPoint(x: mapPoints[0], y: mapPoints[1]))
            let spatialReference = SpatialReference(data: data["spatialReference"] as! Dictionary<String, Any>)!
            if mapPoint != nil && spatialReference.wkid != mapPoint?.spatialReference?.wkid {
                mapPoint = GeometryEngine.project(mapPoint!, into: spatialReference)
            }
            result(mapPoint?.toJSON())
            break
        case "map#getMapScale":
            result(viewModel.currentScale)
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
                symbolVisibilityFilterController.invalidateAll()
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

    private func handleQueryFeatureTableFromLayer(data: Dictionary<String, Any>, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
//        if let data = call.arguments as? Dictionary<String, Any> {
//
//            var queryLayerName = ""
//            let queryParams = QueryParameters()
//
//            for (key, value) in data {
//                switch (key) {
//                case "layerName":
//                    queryLayerName = value as! String
//                    break
//                case "objectId":
//                    if let str = value as? String, let id = Int(str) {
//                        queryParams.objectIDs.append(NSNumber(value: id))
//                    }
//                    break
//                case "maxResults":
//                    if let str = value as? String, let maxResults = Int(str) {
//                        queryParams.maxFeatures = maxResults
//                    }
//                    break
//                case "geometry":
//                    let geometry = Geometry.fromFlutter(data: value as! Dictionary<String, Any>)!
//                    queryParams.geometry = geometry
//                    break
//                case "spatialRelationship":
//                    queryParams.spatialRelationship = AGSSpatialRelationship.fromFlutter(value as! Int)
//                    break
//                default:
//                    if (queryParams.whereClause.isEmpty) {
//                        queryParams.whereClause = "upper(\(key)) LIKE '%\(value as! String).uppercased())%'"
//                    } else {
//                        queryParams.whereClause.append(" AND upper(\(key)) LIKE '%\((value as! String).uppercased())%'")
//                    }
//                    break
//                }
//            }
//
//            if queryLayerName.isEmpty {
//                result(nil)
//                return
//            }
//
//            guard let operationalLayers = mapView.map?.operationalLayers as AnyObject as? [AGSLayer],  operationalLayers.count > 0 else {
//                result(nil)
//                return
//            }
//
//            AGSLoadObjects(operationalLayers) { [weak self] (loaded) in
//
//                guard loaded else {
//                    result(nil)
//                    return
//                }
//
//                guard self != nil else {
//                    result(nil)
//                    return
//                }
//
//                operationalLayers.forEach { (opLayer) in
//
//                    // check if feature layer
//                    if let featLayer = opLayer as? FeatureLayer {
//
//                        if (queryLayerName.uppercased() == featLayer.name.uppercased()) {
//                            featLayer.featureTable?.queryFeatures(with: queryParams, completion: { (qResult:AGSFeatureQueryResult?, error:Error?) -> Void in
//                                if let _ = error {
//                                    print("Error searching for feature")
//                                }
//                                else if let features = qResult?.featureEnumerator().allObjects {
//                                    result(features.map { (feature) -> Any in
//                                        return feature.toJSONFlutter() as! [String : Any]
//                                    })
//                                }
//                            })
//                        }
//                    }
//
//                    // check group layers
//                    guard let groupLayer = opLayer as? AGSGroupLayer else {
//                        return
//                    }
//
//                    for layer in groupLayer.layers {
//
//                        guard let featureLayer = layer as? FeatureLayer else {
//                            return
//                        }
//
//                        if (queryLayerName.uppercased() == featureLayer.name.uppercased()) {
//
//                            featureLayer.featureTable?.queryFeatures(with: queryParams, completion: { (qResult:AGSFeatureQueryResult?, error:Error?) -> Void in
//                                if let _ = error {
//                                    print("Error searching for feature")
//                                }
//                                else if let features = qResult?.featureEnumerator().allObjects {
//                                    result(features.map { (feature) -> Any in
//                                        return feature.toJSONFlutter() as! [String : Any]
//                                    })
//                                }
//                            })
//                        }
//                    }
//                }
//            }
//        } else {
//            result(nil)
//        }

    }

    private func handleTimeAwareLayerInfos(result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
//        guard let layers = mapView.map?.operationalLayers as AnyObject as? [AGSLayer], layers.count > 0 else {
//            result([])
//            return
//        }
//
//        AGSLoadObjects(layers) { [weak self] (loaded) in
//
//            guard loaded else {
//                result([])
//                return
//            }
//
//            guard let self = self else {
//                result([])
//                return
//            }
//
//            var timeAwareLayers = [TimeAware]()
//
//            layers.forEach { (layer) in
//                guard let timeAwareLayer = layer as? TimeAware else {
//                    return
//                }
//                timeAwareLayers.append(timeAwareLayer)
//            }
//            result(timeAwareLayers.map { (layer) -> Any in
//                var layerId: String?
//                if layer is AGSLayer {
//                    layerId = self.layersController.getLayerIdByLayer(layer: layer as! AGSLayer)
//                }
//                return layer.toJSONFlutter(layerId: layerId)
//            })
//        }
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

    private func onTimeExtentChanged(timeExtent: TimeExtent?) {
        channel.invokeMethod("map#timeExtentChanged", arguments: timeExtent?.toJSONFlutter())
    }

    private func viewpointChangedHandler() {
        if trackViewpointChangedListenerEvent {
            channel.invokeMethod("map#viewpointChanged", arguments: nil)
        }
    }

    private func changeMapType(args: Any?) {
        guard let dict = args as? Dictionary<String, Any> else {
            return
        }

        if dict["offlinePath"] != nil {
            loadOfflineMap(args: dict)
            return
        }

        let map = Map(data: dict)
        changeMap(map: map)
    }

    private func loadOfflineMap(args: Dictionary<String, Any>) {
        let offlinePath = args["offlinePath"] as! String
        let mapIndex = args["offlineMapIndex"] as! Int

        let ext = offlinePath.components(separatedBy: ".").last

        switch ext {
        case "vtpk":
            // .vtpk extension is automatically added by the ArcGIS Runtime
            let url = URL(fileURLWithPath: offlinePath.replacingOccurrences(of: ".vtpk", with: ""))
            let vectorTileLayer = ArcGISVectorTiledLayer(url: url)
            let basemap = Basemap(baseLayer: vectorTileLayer)
            let map = Map(basemap: basemap)
            changeMap(map: map)
            return
        default:
            loadMobileMapPackage(offlinePath: offlinePath, mapIndex: mapIndex)
            return
        }
    }

    private func loadMobileMapPackage(offlinePath: String, mapIndex: Int) {
        let mobileMapPackage = MobileMapPackage(fileURL: URL(string: offlinePath)!)

        taskManager.createTask {
            do {
                try await mobileMapPackage.load()
                if mobileMapPackage.maps.isEmpty {
                    self.channel.invokeMethod("map#loaded", arguments: "No maps in the package")
                    return
                }
                let map = mobileMapPackage.maps[mapIndex]
                self.changeMap(map: map)
            } catch {
                self.channel.invokeMethod("map#loaded", arguments: error.localizedDescription)
            }
        }
    }

    private func changeMap(map: Map) {
        let viewPoint = viewModel.viewpointCenterAndScale
        viewModel.map = map
        layersController.setMap(map)

        taskManager.createTask {
            do {
                try await map.load()
                self.channel.invokeMethod("map#loaded", arguments: nil)
            } catch {
                self.channel.invokeMethod("map#loaded", arguments: error.toJSONFlutter(withStackTrace: false))
            }

            if let viewPoint = viewPoint {
                self.setViewpoint(args: viewPoint, animated: false, result: nil)
            }
        }
    }

    private func updateMapOptions(mapOptions: Dictionary<String, Any>) {
        viewModel.updateMapOptions(with: mapOptions)

        if let trackIdentityLayers = mapOptions["trackIdentifyLayers"] as? Bool {
            self.trackIdentityLayers = trackIdentityLayers
        }

        if let trackUserLocationTap = mapOptions["trackUserLocationTap"] as? Bool {
            locationDisplayController.trackUserLocationTap = trackUserLocationTap
        }
    }


    private func setViewpoint(args: Any?,
                              animated: Bool, result: FlutterResult?) {
        let data = args as! Dictionary<String, Any>
        let viewpoint = Viewpoint(data: data)
        viewModel.viewpoint = viewpoint
        guard let proxyView = viewModel.mapViewProxy else {
            result?(nil)
            return
        }

        taskManager.createTask {
            await proxyView.setViewpoint(viewpoint, duration: animated ? 1 : 0)
            result?(nil)
        }
    }

    private func initWithArgs(args: Any?) {
        guard let dict = args as? Dictionary<String, Any> else {
            return
        }
        if let mapType = dict["map"] {
            changeMapType(args: mapType)
        }
        if let viewPoint = dict["viewpoint"] {
            setViewpoint(args: viewPoint, animated: false, result: nil)
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