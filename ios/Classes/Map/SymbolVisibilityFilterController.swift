//
// Created by Valentin Grigorean on 08.09.2021.
//

import Foundation
import ArcGIS

struct SymbolVisibilityFilter: Hashable {

    let minZoom: Double
    let maxZoom: Double

    init(data: Dictionary<String, Any>) {
        minZoom = data["minZoom"] as! Double
        maxZoom = data["maxZoom"] as! Double
    }
}

class SymbolVisibilityFilterController {
    private var graphicControllers = Dictionary<UInt, GraphicControllerInfo>()
    private var initialValues = Dictionary<UInt, Bool>()


    private var scaleObservation: NSKeyValueObservation?

    private var mapScale: Double


    init(mapViewModel:MapViewModel) {

    }

    deinit {
        unbindFromMapView(mapView: mapView)
    }

    func clear() {
        unbindFromMapView(mapView: mapView)

        for item in (graphicControllers.values) {
            item.graphicController.isVisible = initialValues[objectIdentifierFor(item.graphicController)]!
        }

        initialValues.removeAll()
        graphicControllers.removeAll()
    }


    func containsGraphicController(graphicController: BaseGraphicController) -> Bool {
        let id = objectIdentifierFor(graphicController)
        return graphicControllers[id] != nil
    }

    func updateInitialVisibility(graphicController: BaseGraphicController,
                                 initValue: Bool) {
        if !containsGraphicController(graphicController: graphicController) {
            return
        }
        let id = objectIdentifierFor(graphicController)
        initialValues[id] = initValue
    }

    func invalidateAll(){
        for item in (graphicControllers.values) {
            handleGraphicsFilterZoom(graphicControllerInfo: item, currentZoom: mapScale)
        }
    }

    func invalidate(graphicController: BaseGraphicController) {
        let id = objectIdentifierFor(graphicController)

        guard let graphicControllerInfo = graphicControllers[id] else {
            return
        }
        handleGraphicsFilterZoom(graphicControllerInfo: graphicControllerInfo, currentZoom: mapScale)
    }

    func addGraphicsController(graphicController: BaseGraphicController,
                               visibilityFilter: SymbolVisibilityFilter,
                               initValue: Bool) {

        let id = objectIdentifierFor(graphicController)

        initialValues[id] = initValue

        let graphicControllerInfo = graphicControllers[id] ?? GraphicControllerInfo(graphicController: graphicController, visibilityFilter: visibilityFilter)

        handleGraphicsFilterZoom(graphicControllerInfo: graphicControllerInfo, currentZoom: mapScale)

        if let temp = graphicControllers[id] {
            if temp.visibilityFilter == visibilityFilter {
                return
            }
        }

        graphicControllers[id] = graphicControllerInfo

        handleRegistrationToScaleChanged()
    }

    func removeGraphicsController(graphicController: BaseGraphicController) {
        let id = objectIdentifierFor(graphicController)

        guard let graphicControllerInfo = graphicControllers.removeValue(forKey: id) else {
            return
        }

        graphicControllerInfo.graphicController.isVisible = initialValues[id]!
        handleRegistrationToScaleChanged()
    }


    private func mapScaleChanged() {
        guard let currentZoom = mapView?.mapScale else {
            return
        }
        mapScale = currentZoom
        for item in (graphicControllers.values) {
            handleGraphicsFilterZoom(graphicControllerInfo: item, currentZoom: mapScale)
        }
    }

    private func handleGraphicsFilterZoom(graphicControllerInfo: GraphicControllerInfo,
                                          currentZoom: Double) {
        if currentZoom.isNaN {
            return
        }

        let visibilityFilter = graphicControllerInfo.visibilityFilter
        let graphicController = graphicControllerInfo.graphicController
        if currentZoom < visibilityFilter.minZoom && currentZoom > visibilityFilter.maxZoom {
            graphicController.isVisible = initialValues[objectIdentifierFor(graphicController)]!
        } else {
            graphicController.isVisible = false
        }
    }

    private func bindToMapView(mapView: MapView?) {
        scaleObservation = mapView?.observe(\.mapScale, options: .new) { [weak self] _,
                                                                                     _ in
            self?.mapScaleChanged()
        }
    }

    private func unbindFromMapView(mapView: MapView?) {
        // invalidate observations and set to nil
        scaleObservation?.invalidate()
        scaleObservation = nil
    }

    private func handleRegistrationToScaleChanged() {
        if graphicControllers.count > 0 && scaleObservation == nil {
            bindToMapView(mapView: mapView)
        } else if graphicControllers.count == 0 && scaleObservation != nil {
            unbindFromMapView(mapView: mapView)
        }
    }

    // Returns a unique UINT for each object. Used because GraphicController is not hashable
    // and we need to use it as the key in our dictionary of legendInfo arrays.
    private func objectIdentifierFor(_ obj: AnyObject) -> UInt {
        UInt(bitPattern: ObjectIdentifier(obj))
    }
}

fileprivate struct GraphicControllerInfo {
    let graphicController: BaseGraphicController
    let visibilityFilter: SymbolVisibilityFilter
}

