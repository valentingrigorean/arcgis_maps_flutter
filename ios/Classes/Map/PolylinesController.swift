//
// Created by Valentin Grigorean on 28.04.2021.
//

import Foundation
import ArcGIS

class PolylinesController: NSObject, SymbolsController {

    private var polylineIdToController = Dictionary<String, PolylineController>()

    private let graphicsOverlays: GraphicsOverlay

    private let methodChannel: FlutterMethodChannel

    var selectionPropertiesHandler: SelectionPropertiesHandler?

    var symbolVisibilityFilterController: SymbolVisibilityFilterController?

    init(methodChannel: FlutterMethodChannel,
         graphicsOverlays: GraphicsOverlay) {
        self.methodChannel = methodChannel
        self.graphicsOverlays = graphicsOverlays
    }

    func addPolylines(polylinesToAdd: [Dictionary<String, Any>]) {
        for polyline in polylinesToAdd {
            let polylineId = polyline["polylineId"] as! String
            let controller = PolylineController(polylineId: polylineId)
            polylineIdToController[polylineId] = controller
            updatePolyline(data: polyline, controller: controller)
            controller.add(graphicsOverlay: graphicsOverlays)
        }
    }

    func changePolylines(polylinesToChange: [Dictionary<String, Any>]) {
        for polyline in polylinesToChange {
            let polylineId = polyline["polylineId"] as! String
            guard let controller = polylineIdToController[polylineId] else {
                continue
            }
            updatePolyline(data: polyline, controller: controller)
        }
    }

    func removePolylines(polylineIdsToRemove: [String]) {
        for polylineId in polylineIdsToRemove {
            guard let controller = polylineIdToController[polylineId] else {
                continue
            }
            controller.remove(graphicsOverlay: graphicsOverlays)
            polylineIdToController.removeValue(forKey: polylineId)
        }
    }

    private func updatePolyline(data: Dictionary<String, Any>,
                                controller: PolylineController) {
        updateController(controller: controller, data: data)

        if let color = UIColor(data: data["color"]) {
            controller.setColor(color: color)
        }

        if let styleIndex = data["style"] as? Int {
            controller.setStyle(style:  SimpleLineSymbol.Style(styleIndex))
        }

        if let pointsData = data["points"] as? [Dictionary<String, Any>] {
            var points: [Point] = []
            for data in pointsData {
                points.append(Point(data: data))
            }
            controller.setPoints(points: points)
        }

        if let width = data["width"] as? Double {
            controller.setWidth(width: CGFloat(width))
        }

        if let antialias = data["antialias"] as? Bool {
            controller.setAntialias(antialias: antialias)
        }
    }
}

extension PolylinesController: MapGraphicTouchDelegate {

    func canConsumeTaps() -> Bool {
        for (_, controller) in polylineIdToController {
            if controller.consumeTapEvents {
                return true
            }
        }
        return false
    }

    func didHandleGraphic(graphic: Graphic) -> Bool {
        guard let polylineId = graphic.attributes["polylineId"] as? String else {
            return false
        }
        if let currentPolyline = polylineIdToController[polylineId] {
            guard currentPolyline.consumeTapEvents else {
                return false
            }
            methodChannel.invokeMethod("polyline#onTap", arguments: ["polylineId": polylineId])
        }
        return true
    }
}
