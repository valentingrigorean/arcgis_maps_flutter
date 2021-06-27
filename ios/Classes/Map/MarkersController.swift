//
// Created by Valentin Grigorean on 29.03.2021.
//

import Foundation
import ArcGIS

class MarkersController: NSObject {
    private var markerIdToController = Dictionary<String, MarkerController>()
    private let graphicsOverlays: AGSGraphicsOverlay
    private let selectionPropertiesHandler: SelectionPropertiesHandler

    private var selectedMarker: MarkerController?

    private let methodChannel: FlutterMethodChannel

    init(methodChannel: FlutterMethodChannel,
         graphicsOverlays: AGSGraphicsOverlay,
         selectionPropertiesHandler: SelectionPropertiesHandler
    ) {
        self.methodChannel = methodChannel
        self.graphicsOverlays = graphicsOverlays
        self.selectionPropertiesHandler = selectionPropertiesHandler
    }

    func addMarkers(markersToAdd: [Dictionary<String, Any>]) {
        for marker in markersToAdd {
            let markerId = marker["markerId"] as! String
            let controller = MarkerController(markerId: markerId, selectionPropertiesHandler: selectionPropertiesHandler)
            markerIdToController[markerId] = controller
            updateMarker(data: marker, controller: controller)
            controller.add(graphicsOverlay: graphicsOverlays)
        }
    }

    func changeMarkers(markersToChange: [Dictionary<String, Any>]) {
        for marker in markersToChange {
            let markerId = marker["markerId"] as! String
            guard let controller = markerIdToController[markerId] else {
                continue
            }
            updateMarker(data: marker, controller: controller)
        }
    }

    func removeMarkers(markerIdsToRemove: [String]) {
        for markerId in markerIdsToRemove {
            guard let controller = markerIdToController[markerId] else {
                continue
            }
            controller.remove(graphicsOverlay: graphicsOverlays)
            markerIdToController.removeValue(forKey: markerId)
        }
    }

    func clearSelectedMarker() {
        guard let selectedMarker = selectedMarker else {
            return
        }
        selectedMarker.isSelected = false
    }

    private func updateMarker(data: Dictionary<String, Any>,
                              controller: MarkerController) {

        if let consumeTapEvents = data["consumeTapEvents"] as? Bool {
            controller.consumeTapEvents = consumeTapEvents
        }

        if let position = data["position"] as? Dictionary<String, Any> {
            controller.geometry = AGSPoint(data: position)
        }

        if let icon = data["icon"] as? Dictionary<String, Any> {
            controller.setIcon(bitmapDescription: BitmapDescriptor(data: icon))
        }

        controller.setIconOffset(offsetX: CGFloat(data["iconOffsetX"] as! Double), offsetY: CGFloat(data["iconOffsetY"] as! Double))

        if let backgroundImage = data["backgroundImage"] as? Dictionary<String, Any> {
            controller.setBackground(bitmapDescription: BitmapDescriptor(data: backgroundImage))
        }

        if let opacity = data["opacity"] as? Double {
            controller.setOpacity(opacity: Float(opacity))
        }

        if let visible = data["visible"] as? Bool {
            controller.isVisible = visible
        }

        if let zIndex = data["zIndex"] as? Int {
            controller.zIndex = zIndex
        }
    }
}

extension MarkersController: MapGraphicTouchDelegate {

    func canConsumeTaps() -> Bool {
        for (_, controller) in markerIdToController {
            if controller.consumeTapEvents {
                return true
            }
        }
        return false
    }

    func didHandleGraphic(graphic: AGSGraphic) -> Bool {
        guard let markerId = graphic.attributes["markerId"] as? String else {
            return false
        }
        if let currentMarker = markerIdToController[markerId] {
            guard currentMarker.consumeTapEvents else {
                return false
            }
            let prevMarker = selectedMarker
            if prevMarker != nil {
                prevMarker?.isSelected = false
            }
            selectedMarker = currentMarker
            currentMarker.isSelected = true
        }
        methodChannel.invokeMethod("marker#onTap", arguments: ["markerId": markerId])
        return true
    }
}
