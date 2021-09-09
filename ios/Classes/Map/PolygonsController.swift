//
// Created by Valentin Grigorean on 15.04.2021.
//

import Foundation
import ArcGIS

class PolygonsController: NSObject, SymbolsController {

    private let workerQueue: DispatchQueue

    private var polygonIdToController = Dictionary<String, PolygonController>()

    private let graphicsOverlays: AGSGraphicsOverlay

    private let methodChannel: FlutterMethodChannel

    var selectionPropertiesHandler: SelectionPropertiesHandler?

    var symbolVisibilityFilterController: SymbolVisibilityFilterController?

    init(methodChannel: FlutterMethodChannel,
         graphicsOverlays: AGSGraphicsOverlay,
         workerQueue: DispatchQueue
    ) {
        self.methodChannel = methodChannel
        self.graphicsOverlays = graphicsOverlays
        self.workerQueue = workerQueue
    }

    func addPolygons(polygonsToAdd: [Dictionary<String, Any>]) {
        workerQueue.async { [self] in
            for polygon in polygonsToAdd {
                let polygonId = polygon["polygonId"] as! String
                let controller = PolygonController(graphicsOverlay: graphicsOverlays, polygonId: polygonId)
                polygonIdToController[polygonId] = controller
                updatePolygon(data: polygon, controller: controller)
                controller.add()
            }
        }
    }

    func changePolygons(polygonsToChange: [Dictionary<String, Any>]) {
        workerQueue.async { [self] in
            for polygon in polygonsToChange {
                let polygonId = polygon["polygonId"] as! String
                guard let controller = polygonIdToController[polygonId] else {
                    continue
                }
                updatePolygon(data: polygon, controller: controller)
            }
        }
    }

    func removePolygons(polygonIdsToRemove: [String]) {
        workerQueue.async { [self] in
            for polygonId in polygonIdsToRemove {
                guard let controller = polygonIdToController[polygonId] else {
                    continue
                }
                symbolVisibilityFilterController?.removeGraphicsController(graphicController: controller)
                controller.remove()
                polygonIdToController.removeValue(forKey: polygonId)
            }
        }
    }

    private func updatePolygon(data: Dictionary<String, Any>,
                               controller: PolygonController) {

        updateController(controller: controller, data: data)

        if let fillColor = UIColor(data: data["fillColor"]) {
            controller.setFillColor(fillColor: fillColor)
        }

        if let strokeColor = UIColor(data: data["strokeColor"]) {
            controller.setStrokeColor(strokeColor: strokeColor)
        }

        if let strokeWidth = data["strokeWidth"] as? Double {
            controller.setStrokeWidth(width: CGFloat(strokeWidth))
        }

        if let pointsData = data["points"] as? [Dictionary<String, Any>] {
            var points: [AGSPoint] = []
            for data in pointsData {
                points.append(AGSPoint(data: data))
            }
            controller.setPoints(points: points)
        }
    }
}

extension PolygonsController: MapGraphicTouchDelegate {

    func canConsumeTaps() -> Bool {
        for (_, controller) in polygonIdToController {
            if controller.consumeTabEvent {
                return true
            }
        }
        return false
    }

    func didHandleGraphic(graphic: AGSGraphic) -> Bool {
        guard let polygonId = graphic.attributes["polygonId"] as? String else {
            return false
        }
        if let currentPolygon = polygonIdToController[polygonId] {
            guard currentPolygon.consumeTabEvent else {
                return false
            }
            methodChannel.invokeMethod("polygon#onTap", arguments: ["polygonId": polygonId])
        }
        return true
    }
}