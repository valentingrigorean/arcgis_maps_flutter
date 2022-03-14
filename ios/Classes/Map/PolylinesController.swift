//
// Created by Valentin Grigorean on 28.04.2021.
//

import Foundation
import ArcGIS

class PolylinesController: NSObject, SymbolsController {

    private let workerQueue: DispatchQueue

    private var polylineIdToController = Dictionary<String, PolylineController>()

    private let graphicsOverlays: AGSGraphicsOverlay

    private let methodChannel: FlutterMethodChannel

    var selectionPropertiesHandler: SelectionPropertiesHandler?

    var symbolVisibilityFilterController: SymbolVisibilityFilterController?

    init(methodChannel: FlutterMethodChannel,
         graphicsOverlays: AGSGraphicsOverlay,
         workerQueue: DispatchQueue) {
        self.methodChannel = methodChannel
        self.graphicsOverlays = graphicsOverlays
        self.workerQueue = workerQueue
    }

    func addPolylines(polylinesToAdd: [Dictionary<String, Any>]) {
        workerQueue.async { [self] in
            for polyline in polylinesToAdd {
                let polylineId = polyline["polylineId"] as! String
                let controller = PolylineController(polylineId: polylineId)
                polylineIdToController[polylineId] = controller
                updatePolyline(data: polyline, controller: controller)
                controller.add(graphicsOverlay: graphicsOverlays)
            }
        }

    }

    func changePolylines(polylinesToChange: [Dictionary<String, Any>]) {
        workerQueue.async { [self] in
            for polyline in polylinesToChange {
                let polylineId = polyline["polylineId"] as! String
                guard let controller = polylineIdToController[polylineId] else {
                    continue
                }
                updatePolyline(data: polyline, controller: controller)
            }
        }
    }

    func removePolylines(polylineIdsToRemove: [String]) {
        workerQueue.async { [self] in
            for polylineId in polylineIdsToRemove {
                guard let controller = polylineIdToController[polylineId] else {
                    continue
                }
                controller.remove(graphicsOverlay: graphicsOverlays)
                polylineIdToController.removeValue(forKey: polylineId)
            }
        }
    }

    private func updatePolyline(data: Dictionary<String, Any>,
                                controller: PolylineController) {
        updateController(controller: controller, data: data)

        if let color = UIColor(data: data["color"]) {
            controller.setColor(color: color)
        }

        if let styleIndex = data["style"] as? Int {
            if let style = AGSSimpleLineSymbolStyle(rawValue: styleIndex) {
                controller.setStyle(style: style)
            }
        }

        if let pointsData = data["points"] as? [Dictionary<String, Any>] {
            var points: [AGSPoint] = []
            for data in pointsData {
                points.append(AGSPoint(data: data))
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

    func didHandleGraphic(graphic: AGSGraphic) -> Bool {
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