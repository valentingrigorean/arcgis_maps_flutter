//
// Created by Valentin Grigorean on 28.04.2021.
//

import Foundation
import ArcGIS

class PolylinesController: NSObject {

    private let workerQueue: DispatchQueue


    private var polylineIdToController = Dictionary<String, PolylineController>()

    private let graphicsOverlays: AGSGraphicsOverlay

    private let methodChannel: FlutterMethodChannel

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
                let controller = PolylineController(graphicsOverlay: graphicsOverlays, polylineId: polylineId)
                polylineIdToController[polylineId] = controller
                updatePolyline(data: polyline, controller: controller)
                controller.add()
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
                controller.remove()
                polylineIdToController.removeValue(forKey: polylineId)
            }
        }
    }

    private func updatePolyline(data: Dictionary<String, Any>,
                                controller: PolylineController) {
        if let consumeTapEvents = data["consumeTapEvents"] as? Bool {
            controller.consumeTabEvent = consumeTapEvents
        }

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

        if let visible = data["visible"] as? Bool {
            controller.setVisible(visible: visible)
        }

        if let width = data["width"] as? Double {
            controller.setWidth(width: CGFloat(width))
        }

        if let zIndex = data["zIndex"] as? Int {
            controller.setZIndex(zIndex: zIndex)
        }

        if let antialias = data["antialias"] as? Bool {
            controller.setAntialias(antialias: antialias)
        }
    }
}

extension PolylinesController: MapGraphicTouchDelegate {

    func canConsumeTaps() -> Bool {
        for (_, controller) in polylineIdToController {
            if controller.consumeTabEvent {
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
            guard currentPolyline.consumeTabEvent else {
                return false
            }
            methodChannel.invokeMethod("polyline#onTap", arguments: ["polylineId": polylineId])
        }
        return true
    }
}