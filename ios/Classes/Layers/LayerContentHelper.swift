//
// Created by Mo on 2022/7/13.
//

import Foundation
import Flutter
import ArcGIS

class LayerContentHelper: NSObject {

    private static let instance: LayerContentHelper = LayerContentHelper()

    class func shareManager() -> LayerContentHelper {
        return instance;
    }

    private var secondaryLayers: Dictionary<String,
    [SecondaryLayer]> = Dictionary<String, [SecondaryLayer]>()

    func requireLayers(
            _ call: FlutterMethodCall,
            result: @escaping FlutterResult,
            layersController: LayersController
    ) -> Void {
        if let args = call.arguments as? Dictionary<String, Any> {
            if let layerId = args["layerId"] as? String {
                let foundLayer = layersController.getLayerByLayerId(layerId: layerId)
                if let fl = foundLayer as? AGSArcGISMapImageLayer {
                    if let foundLayerContents = secondaryLayers[layerId] {
                        sendLayersBack(result: result, layers: foundLayerContents)
                    } else {
                        loadSecondaryLayer(result: result, layerId: layerId, layer: fl)
                    }
                } else {
                    result(Dictionary<String, [SecondaryLayer]>())
                }
            } else {
                result(Dictionary<String, [SecondaryLayer]>())
            }
        } else {
            result(Dictionary<String, [SecondaryLayer]>())
        }
    }

    private func loadSecondaryLayer(result: @escaping FlutterResult, layerId: String, layer: AGSArcGISMapImageLayer) {
        var layerContents: [SecondaryLayer] = []
        for firstLayer in layer.subLayerContents {
            for secondLayer in firstLayer.subLayerContents {
                if (secondLayer is AGSArcGISMapImageSublayer) {
                    layerContents.append(SecondaryLayer(id: UUID().uuidString, layerContent: secondLayer))
                }
            }
        }
        secondaryLayers[layerId] = layerContents

        sendLayersBack(result: result, layers: layerContents)
    }

    private func sendLayersBack(result: @escaping FlutterResult, layers: [SecondaryLayer]) {
        var tmp: [Dictionary<String, Any>] = []
        layers.forEach { layer in
            tmp.append([
                "id": layer.id,
                "name": layer.layerContent.name,
                "visible": layer.layerContent.isVisible,
            ])
        }
        result(tmp)
    }

    func updateLayerVisibility(
            _ call: FlutterMethodCall,
            result: @escaping FlutterResult
    ) {
        if let args = call.arguments as? Dictionary<String, Any> {
            if let layerId = args["layerId"] as? String {
                let id = args["id"] as? String
                let foundLayer = secondaryLayers[layerId]
                let target = foundLayer?.first { layer in
                    return layer.id == id
                };
                if let visible = args["id"] as? Bool {
                    target?.layerContent.isVisible = visible
                    result(true)
                } else {
                    result(false)
                }
            } else {
                result(false)
            }
        } else {
            result(false)
        }

    }
}

private class SecondaryLayer {
    init(id: String, layerContent: AGSLayerContent) {
        self.id = id
        self.layerContent = layerContent
    }

    let id: String
    let layerContent: AGSLayerContent
}