//
// Created by Valentin Grigorean on 24.03.2021.
//

import Foundation
import ArcGIS
import Combine

enum LayerType: Int, CaseIterable {
    case operational = 0

    case base = 1

    case reference = 2
}

class LayersController {

    class SharedDictionary<K: Hashable, V> {
        var dict: Dictionary<K, V> = Dictionary()
        subscript(key: K) -> V? {
            get {
                dict[key]
            }
            set(newValue) {
                dict[key] = newValue
            }
        }

        var values: [V] {
            get {
                Array(dict.values)
            }
        }

        func removeAll() {
            dict.removeAll()
        }

        func removeValue(forKey: K) {
            dict.removeValue(forKey: forKey)
        }
    }

    private let taskManager = TaskManager()

    private var operationalLayers = [FlutterLayer]()
    private var baseLayers = [FlutterLayer]()
    private var referenceLayers = [FlutterLayer]()

    private var flutterOperationalLayersMap = SharedDictionary<String, Layer>()
    private var flutterBaseLayersMap = SharedDictionary<String, Layer>()
    private var flutterReferenceLayersMap = SharedDictionary<String, Layer>()


    private let methodChannel: FlutterMethodChannel

    private weak var map: Map?

    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }

    public func setMap(_ map: Map) {
        clearMap()
        self.map = map
        addLayersToMap(layers: operationalLayers, layerType: .operational)
        addLayersToMap(layers: baseLayers, layerType: .base)
        addLayersToMap(layers: referenceLayers, layerType: .reference)
    }

    public func getLayerByLayerId(_ layerId: String) -> Layer? {
        if let layer = flutterOperationalLayersMap[layerId] {
            return layer
        }
        if let layer = flutterBaseLayersMap[layerId] {
            return layer
        }
        if let layer = flutterReferenceLayersMap[layerId] {
            return layer
        }
        return nil
    }

    public func getLayerIdByLayer(layer: Layer) -> String? {

        if let layerId = LayersController.findLayerIdByLayer(layer: layer, data: flutterOperationalLayersMap) {
            return layerId
        }

        if let layerId = LayersController.findLayerIdByLayer(layer: layer, data: flutterBaseLayersMap) {
            return layerId
        }

        if let layerId = LayersController.findLayerIdByLayer(layer: layer, data: flutterReferenceLayersMap) {
            return layerId
        }

        return nil
    }


    public func updateFromArgs(args: Any) {
        guard let dict = args as? [String: Any] else {
            return
        }

        for layerType in LayerType.allCases {
            updateFromData(data: dict, layerType: layerType)
        }
    }

    func setTimeOffset(arguments: Any?) {
        guard let data = arguments as? [String: Any] else {
            return
        }

        guard let layerId = data["layerId"] as? String else {
            return
        }

        guard var layer = getLayerByLayerId(layerId) as? TimeAware else {
            return
        }

        guard let timeValue = data["timeValue"] as? [String: Any] else {
            layer.timeOffset = nil
            return
        }
        layer.timeOffset = TimeValue(data: timeValue)
    }


    private func addLayers(args: Any,
                           layerType: LayerType) {

        guard let layersArgs = args as? [[String: Any]] else {
            return
        }

        let flutterMap = getFlutterMap(layerType: layerType)
        let flutterLayers = getFlutterLayersArray(layerType: layerType)

        var layersToAdd = [FlutterLayer]()

        for layer in layersArgs {
            let layerId = layer["layerId"] as! String

            if flutterMap[layerId] != nil {
                continue
            }

            let flutterLayer = FlutterLayer(data: layer)
            layersToAdd.append(flutterLayer)
        }

        setFlutterLayersArray(layerType: layerType, layers: flutterLayers + layersToAdd)
        addLayersToMap(layers: layersToAdd, layerType: layerType)
    }

    private func removeLayers(args: Any,
                              layerType: LayerType) {
        guard let layersArgs = args as? [Dictionary<String, String>] else {
            return
        }

        var layersToRemove = [FlutterLayer]()

        let flutterMap = getFlutterMap(layerType: layerType)

        for layer in layersArgs {
            let layerId = layer["layerId"]!

            if flutterMap[layerId] == nil {
                continue
            }

            let flutterLayer = FlutterLayer(data: layer)
            layersToRemove.append(flutterLayer)
        }

        setFlutterLayersArray(layerType: layerType, layers: getFlutterLayersArray(layerType: layerType).filter { layer in
            !layersToRemove.contains {
                $0.layerId == layer.layerId
            }
        })

        removeLayersFromMap(layers: layersToRemove, layerType: layerType)
    }

    private func clearMap() {
        guard let map = map else {
            return
        }
        map.removeAllOperationalLayers()
        map.basemap?.removeAllBaseLayers()
        map.basemap?.removeAllReferenceLayers()
    }

    private func addLayersToMap(layers: [FlutterLayer],
                                layerType: LayerType) {
        guard let map = map else {
            return
        }

        let flutterMap = getFlutterMap(layerType: layerType)
        var operationLayers = [Layer]()
        var baseLayers = [Layer]()
        var referenceLayers = [Layer]()

        for layer in layers {
            let nativeLayer = flutterMap[layer.layerId] ?? layer.createNativeLayer()

            if flutterMap[layer.layerId] == nil {
                flutterMap[layer.layerId] = nativeLayer
            }

            taskManager.createTask {
                var args = [String: Any]()
                args["layerId"] = layer.layerId
                do {
                    try await nativeLayer.load()
                } catch (let error) {
                    args["error"] = error.toJSONFlutter(withStackTrace: false, addFlutterFlag: false)
                }
                self.methodChannel.invokeMethod("layer#loaded", arguments: args)
            }

            switch layerType {

            case .operational:
                operationLayers.append(nativeLayer)
                break
            case .base:
                baseLayers.append(nativeLayer)
                break
            case .reference:
                referenceLayers.append(nativeLayer)
                break
            }
        }

        map.addOperationalLayers(operationLayers)
        map.basemap?.addBaseLayers(baseLayers)
        map.basemap?.addReferenceLayers(referenceLayers)
    }

    private func removeLayersFromMap(layers: [FlutterLayer],
                                     layerType: LayerType) {

        var nativeLayersToRemove = [Layer]()
        let flutterMap = getFlutterMap(layerType: layerType)
        let flutterLayer = getFlutterLayersArray(layerType: layerType)

        for layer in layers {
            let nativeLayer = flutterMap[layer.layerId]!
            flutterMap.removeValue(forKey: layer.layerId)
            nativeLayersToRemove.append(nativeLayer)
        }

        setFlutterLayersArray(layerType: layerType, layers: flutterLayer.filter { layer in
            !layers.contains {
                $0.layerId == layer.layerId
            }
        })

        if nativeLayersToRemove.isEmpty {
            return
        }

        guard let map = map else {
            return
        }

        switch layerType {
        case .operational:
            map.removeOperationalLayers(nativeLayersToRemove)
            break
        case .base:
            map.basemap?.removeBaseLayers(nativeLayersToRemove)
            break
        case .reference:
            map.basemap?.removeReferenceLayers(nativeLayersToRemove)
            break
        }
    }

    private func updateFromData(data: [String: Any],
                                layerType: LayerType) {

        let objectName = getObjectName(layerType: layerType)

        if let layersToAdd = data["\(objectName)sToAdd"] {
            addLayers(args: layersToAdd, layerType: layerType)
        }

        if let layersToUpdate = data["\(objectName)sToChange"] {
            removeLayers(args: layersToUpdate, layerType: layerType)
            addLayers(args: layersToUpdate, layerType: layerType)
        }

        if let layersToRemove = data["\(objectName)IdsToRemove"] as? [String] {
            removeLayersById(args: layersToRemove, layerType: layerType)
        }
    }

    private func removeLayersById(args: [String],
                                  layerType: LayerType) {
        var layersToRemove = [FlutterLayer]()
        let layers = getFlutterLayersArray(layerType: layerType)
        for layerId in args {
            let layer = layers.first {
                $0.layerId == layerId
            }

            if layer != nil {
                layersToRemove.append(layer!)
            }
        }

        setFlutterLayersArray(layerType: layerType, layers: layers.filter { layer in
            !layersToRemove.contains {
                $0.layerId == layer.layerId
            }
        })

        removeLayersFromMap(layers: layersToRemove, layerType: layerType)
    }

    private func getObjectName(layerType: LayerType) -> String {
        switch layerType {
        case .operational:
            return "operationalLayer"
        case .base:
            return "baseLayer"
        case .reference:
            return "referenceLayer"
        }
    }

    private func getFlutterLayersArray(layerType: LayerType) -> [FlutterLayer] {
        switch layerType {
        case .operational:
            return operationalLayers
        case .base:
            return baseLayers
        case .reference:
            return referenceLayers
        }
    }

    private func setFlutterLayersArray(layerType: LayerType, layers: [FlutterLayer]) {
        switch layerType {
        case .operational:
            operationalLayers = layers
        case .base:
            baseLayers = layers
        case .reference:
            referenceLayers = layers
        }
    }

    private func getFlutterMap(layerType: LayerType) -> SharedDictionary<String, Layer> {
        switch layerType {
        case .operational:
            return flutterOperationalLayersMap
        case .base:
            return flutterBaseLayersMap
        case .reference:
            return flutterReferenceLayersMap
        }
    }


    private static func findLayerIdByLayer(layer: Layer,
                                           data: SharedDictionary<String, Layer>) -> String? {
        for (key, layer) in data.dict {
            if layer.id == layer.id {
                return key
            }
        }
        return nil
    }
}
