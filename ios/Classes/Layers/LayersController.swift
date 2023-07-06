//
// Created by Valentin Grigorean on 24.03.2021.
//

import Foundation
import ArcGIS

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

    class SharedSet<T: Hashable> {
        var set = Set<T>()

        func insert(_ element: T) {
            set.insert(element)
        }

    }

    private let taskManager = TaskManager()

    private var operationalLayers = SharedSet<FlutterLayer>()
    private var baseLayers = SharedSet<FlutterLayer>()
    private var referenceLayers = SharedSet<FlutterLayer>()

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

        addLayersToMap(layers: Array(operationalLayers.set), layerType: .operational)
        addLayersToMap(layers: Array(baseLayers.set), layerType: .base)
        addLayersToMap(layers: Array(referenceLayers.set), layerType: .reference)
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
        guard let dict = args as? Dictionary<String, Any> else {
            return
        }

        for layerType in LayerType.allCases {
            updateFromData(data: dict, layerType: layerType)
        }
    }

    func setTimeOffset(arguments: Any?) {
        guard let data = arguments as? Dictionary<String, Any> else {
            return
        }

        guard let layerId = data["layerId"] as? String else {
            return
        }

        guard var layer = getLayerByLayerId(layerId) as? TimeAware else {
            return
        }

        guard let timeValue = data["timeValue"] as? Dictionary<String, Any> else {
            layer.timeOffset = nil
            return
        }
        layer.timeOffset = TimeValue(data: timeValue)
    }


    private func addLayers(args: Any,
                           layerType: LayerType) {

        guard let layersArgs = args as? [Dictionary<String, Any>] else {
            return
        }

        let flutterMap = getFlutterMap(layerType: layerType)
        let flutterLayers = getFlutterLayerSet(layerType: layerType)

        var layersToAdd = [FlutterLayer]()

        for layer in layersArgs {
            let layerId = layer["layerId"] as! String

            if flutterMap[layerId] != nil {
                continue
            }

            let flutterLayer = FlutterLayer(data: layer)
            layersToAdd.append(flutterLayer)
            flutterLayers.insert(flutterLayer)
        }

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

        removeLayersFromMap(layers: layersToRemove, layerType: layerType)
    }

    private func clearMap() {

        let operationalLayersNative = flutterOperationalLayersMap.values
        let baseLayersNative = flutterBaseLayersMap.values
        let referenceLayersNative = flutterReferenceLayersMap.values

        flutterOperationalLayersMap.removeAll()
        flutterBaseLayersMap.removeAll()
        flutterReferenceLayersMap.removeAll()

        guard let map = map else {
            return
        }

        map.addOperationalLayers(operationalLayersNative)
        map.basemap?.addBaseLayers(baseLayersNative)
        map.basemap?.addReferenceLayers(referenceLayersNative)
    }

    private func addLayersToMap(layers: [FlutterLayer],
                                layerType: LayerType) {
        guard let map = map else {
            return
        }

        let flutterMap = getFlutterMap(layerType: layerType)


        for layer in layers {
            let nativeLayer = layer.createNativeLayer()

            if flutterMap[layer.layerId] == nil {
                flutterMap[layer.layerId] = nativeLayer
            }

            taskManager.createTask {
                var args = [String: Any]()
                args["layerId"] = layer.layerId
                do {
                    try await nativeLayer.load()
                } catch (let error) {
                    args["error"] = error.toJSONFlutter(withStackTrace: false)
                }
                self.methodChannel.invokeMethod("layer#loaded", arguments: args)
            }

            switch layerType {

            case .operational:
                map.addOperationalLayer(nativeLayer)
                break
            case .base:
                map.basemap?.addBaseLayer(nativeLayer)
                break
            case .reference:
                map.basemap?.addReferenceLayer(nativeLayer)
                break
            }
        }
    }

    private func removeLayersFromMap(layers: [FlutterLayer],
                                     layerType: LayerType) {

        var nativeLayersToRemove = [Layer]()
        let flutterMap = getFlutterMap(layerType: layerType)
        let flutterLayer = getFlutterLayerSet(layerType: layerType)

        for layer in layers {
            let nativeLayer = flutterMap[layer.layerId]!
            flutterMap.removeValue(forKey: layer.layerId)
            flutterLayer.set.remove(layer)
            nativeLayersToRemove.append(nativeLayer)
        }

        guard let map = map else {
            return
        }

        for layer in nativeLayersToRemove {
            switch layerType {
            case .operational:
                map.removeOperationalLayer(layer)
                break
            case .base:
                map.basemap?.removeBaseLayer(layer)
                break
            case .reference:
                map.basemap?.removeReferenceLayer(layer)
                break
            }
        }
    }

    private func updateFromData(data: Dictionary<String, Any>,
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
        let layers = getFlutterLayerSet(layerType: layerType).set
        for layerId in args {
            let layer = layers.first {
                $0.layerId == layerId
            }

            if layer != nil {
                layersToRemove.append(layer!)
            }
        }

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

    private func getFlutterLayerSet(layerType: LayerType) -> SharedSet<FlutterLayer> {
        switch layerType {

        case .operational:
            return operationalLayers
        case .base:
            return baseLayers
        case .reference:
            return referenceLayers
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