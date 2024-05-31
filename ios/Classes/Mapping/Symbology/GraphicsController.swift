//
// Created by Valentin Grigorean on 29.05.2024.
//

import Foundation
import ArcGIS

class GraphicsController : NSObject, SymbolsController{
    private var graphicIdToController = Dictionary<String, GraphicMarkerController>()
    private let graphicsOverlay: GraphicsOverlay

    private let methodChannel: FlutterMethodChannel

    var selectionPropertiesHandler: SelectionPropertiesHandler?

    var symbolVisibilityFilterController: SymbolVisibilityFilterController?

    init(methodChannel: FlutterMethodChannel,
         graphicsOverlay: GraphicsOverlay
    ) {
        self.methodChannel = methodChannel
        self.graphicsOverlay = graphicsOverlay
    }

    func addGraphics(graphicsToAdd: [[String: Any]]) {
        for graphic in graphicsToAdd {
            let graphicId = graphic["graphicId"] as! String
            let controller = GraphicMarkerController(graphicId: graphicId)
            controller.selectionPropertiesHandler = selectionPropertiesHandler
            graphicIdToController[graphicId] = controller
            updateGraphic(data: graphic, controller: controller)
            controller.add(graphicsOverlay: graphicsOverlay)
                
        }
    }

    func changeGraphics(graphicsToChange: [[String: Any]]) {
        for graphic in graphicsToChange {
            let graphicId = graphic["graphicId"] as! String
            guard let controller = graphicIdToController[graphicId] else {
                continue
            }
            updateGraphic(data: graphic, controller: controller)
        }
    }

    func removeGraphics(graphicIdsToRemove: [String]) {
        for graphicId in graphicIdsToRemove {
            guard let controller = graphicIdToController[graphicId] else {
                continue
            }
            symbolVisibilityFilterController?.removeGraphicsController(graphicController: controller)
            controller.remove(graphicsOverlay: graphicsOverlay)
            graphicIdToController.removeValue(forKey: graphicId)
        }
    }

    

    private func updateGraphic(data: [String: Any], controller: GraphicMarkerController) {
        if let geometry = data["geometry"] as? [String: Any] {
            controller.geometry = Geometry.fromFlutter(data: geometry)
        }
        if let symbol = data["symbol"] as? [String:Any] {
            controller.symbol = SymbolFactory.createSymbol(data: symbol)
        }

        if let consumeTapEvents = data["consumeTapEvents"] as? Bool {
            controller.consumeTapEvents = consumeTapEvents
        }

        if let isSelected = data["isSelected"] as? Bool {
            controller.isSelected = isSelected
        }

        if let isVisible = data["isVisible"] as? Bool {
            controller.isVisible = isVisible
        }

        if let zIndex = data["zIndex"] as? Int {
            controller.zIndex = zIndex
        }
    }
}


extension GraphicsController: MapGraphicTouchDelegate {

    func canConsumeTaps() -> Bool {
        for (_, controller) in graphicIdToController {
            if controller.consumeTapEvents {
                return true
            }
        }
        return false
    }

    func didHandleGraphic(graphic: Graphic) -> Bool {
        guard let graphicId = graphic.attributes["graphicId"] as? String else {
            return false
        }
        if let currentMarker = graphicIdToController[graphicId] {
            guard currentMarker.consumeTapEvents else {
                return false
            }
        }
        methodChannel.invokeMethod("graphic#onTap", arguments: ["graphicId": graphicId])
        return true
    }
}
