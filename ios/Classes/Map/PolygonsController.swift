//
// Created by Valentin Grigorean on 15.04.2021.
//

import Foundation
import ArcGIS

class PolygonsController: NSObject {
    private var polygonIdToController = Dictionary<String, PolygonController>()

    private let graphicsOverlays: AGSGraphicsOverlay

    private let methodChannel: FlutterMethodChannel

    init(methodChannel: FlutterMethodChannel,
         graphicsOverlays: AGSGraphicsOverlay) {
        self.methodChannel = methodChannel
        self.graphicsOverlays = graphicsOverlays
    }

    func addPolygons(polygonsToAdd: [Dictionary<String, Any>]) {
        for polygon in polygonsToAdd {
            let polygonId = polygon["polygonId"] as! String
            let controller = PolygonController(graphicsOverlay: graphicsOverlays, polygonId: polygonId)
            polygonIdToController[polygonId] = controller
            updatePolygon(data: polygon, controller: controller)
            controller.add()
        }
    }

    func changePolygons(polygonsToChange: [Dictionary<String, Any>]) {
        for polygon in polygonsToChange {
            let polygonId = polygon["polygonId"] as! String
            guard let controller = polygonIdToController[polygonId] else {
                continue
            }
            updatePolygon(data: polygon, controller: controller)
        }
    }

    func removePolygons(polygonIdsToRemove: [String]) {
        for polygonId in polygonIdsToRemove {
            guard let controller = polygonIdToController[polygonId] else {
                continue
            }
            controller.remove()
            polygonIdToController.removeValue(forKey: polygonId)
        }
    }

    private func updatePolygon(data: Dictionary<String, Any>,
                               controller: PolygonController) {
        if let consumeTapEvents = data["consumeTapEvents"] as? Bool {
            controller.consumeTabEvent = consumeTapEvents
        }

        if let visible = data["visible"] as? Bool {
            controller.setVisible(visible: visible)
        }

        if let fillColor = UIColor(data: data["fillColor"]) {
            controller.setFillColor(fillColor: fillColor)
        }

        if let strokeColor = UIColor(data: data["strokeColor"]) {
            controller.setStrokeColor(strokeColor: strokeColor)
        }

        if let strokeWidth = data["strokeWidth"] as? Double {
            controller.setStrokeWidth(width: CGFloat(strokeWidth))
        }

        if let zIndex = data["zIndex"] as? Int {
            controller.setZIndex(zIndex: zIndex)
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