//
// Created by Valentin Grigorean on 14.07.2021.
//

import Foundation
import ArcGIS

public typealias LegendInfoControllerResult = ([Any]) -> Void

class LegendInfoController {

    private let layersController: LayersController
    private let result : LegendInfoControllerResult
    private var layersLegend = Dictionary<LayerWrapper, [AGSLegendInfo]>()

    private var legendResultsFlutter: [Any] = []

    private var didSetResult = false

    private var pendingRequest = 0

    init(layersController: LayersController,
         result: @escaping LegendInfoControllerResult) {
        self.layersController = layersController
        self.result = result
    }

    func loadAsync(args: Any?) {
        if didSetResult {
            return
        }

        guard let data = args as? Dictionary<String, Any> else {
            return
        }

        let flutterLayer = FlutterLayer(data: data)

        var loadedLayer = layersController.getLayerByLayerId(layerId: flutterLayer.layerId)
        if loadedLayer == nil {
            loadedLayer = flutterLayer.createNativeLayer()
        }

        loadIndividualLayer(loadedLayer!)

        loadedLayer?.load { [weak self]error in
            guard let self = self else {
                return
            }

            if error != nil {
                self.setResult()
            } else if loadedLayer!.showInLegend == false && loadedLayer!.subLayerContents.isEmpty {
                self.setResult()
            }
        }
    }

    // load an individual layer as AGSLayerContent
    private func loadIndividualLayer(_ layerContent: AGSLayerContent) {
        if let layer = layerContent as? AGSLayer {
            // we have an AGSLayer, so make sure it's loaded
            layer.load { [weak self] (_) in
                self?.loadSublayersOrLegendInfos(layerContent)
            }
        } else {
            loadSublayersOrLegendInfos(layerContent)
        }
    }

    private func loadSublayersOrLegendInfos(_ layerContent: AGSLayerContent) {

        // if we have sublayer contents, load those as well
        if !layerContent.subLayerContents.isEmpty {
            pendingRequest += 1
            layerContent.subLayerContents.forEach {
                loadIndividualLayer($0)
            }
            pendingRequest -= 1
        } else {
            // fetch the legend infos
            pendingRequest += 1
            layerContent.fetchLegendInfos { [weak self] (legendInfos,
                                                         _) in
                // handle legendInfos
                guard let self = self else {
                    return
                }

                self.pendingRequest -= 1
                self.layersLegend[LayerWrapper(layer: layerContent)] = legendInfos ?? []

                if self.pendingRequest == 0 {
                    self.setResult()
                }
            }
        }
    }

    private func addLegendInfoResultFlutterAndValidate(layerContent: AGSLayerContent,
                                                       results: [Any]) {

        legendResultsFlutter.append(["layerName": layerContent.name, "results": results])
        if legendResultsFlutter.count == layersLegend.count {
            result(legendResultsFlutter)
        }
    }


    private func setResult() {
        if didSetResult {
            return
        }

        didSetResult = true
        if layersLegend.isEmpty {
            result([])
            return
        }

        for (k, v) in layersLegend {
            var results = Array<Any>()
            for legendInfo in v {
                var item = Dictionary<String, Any>()
                item["name"] = legendInfo.name

                if legendInfo.symbol == nil {
                    results.append(item)

                    if results.count == v.count {
                        addLegendInfoResultFlutterAndValidate(layerContent: k.layer, results: results)
                    }
                } else {
                    legendInfo.symbol?.createSwatch { [weak self] (image,
                                                                   _) in
                        if image != nil {
                            item["symbolImage"] = image!.jpegData(compressionQuality: 1.0)
                        }
                        results.append(item)

                        if results.count == v.count {
                            self?.addLegendInfoResultFlutterAndValidate(layerContent: k.layer, results: results)
                        }
                    }
                }
            }
        }
    }


}

fileprivate struct LayerWrapper: Hashable {

    let layer: AGSLayerContent

    func hash(into hasher: inout Hasher) {
        hasher.combine(LayerWrapper.objectIdentifierFor(layer))
    }

    static func ==(lhs: LayerWrapper,
                   rhs: LayerWrapper) -> Bool {
        lhs.layer === rhs.layer
    }

    private static func objectIdentifierFor(_ obj: AnyObject) -> UInt {
        UInt(bitPattern: ObjectIdentifier(obj))
    }
}