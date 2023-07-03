//
// Created by Valentin Grigorean on 14.07.2021.
//

import Foundation
import ArcGIS

class LegendInfoController {

    private let layersController: LayersController

    init(layersController: LayersController) {
        self.layersController = layersController
    }

    func loadAsync(args: Any?) async -> Any {
        let flutterLayer = FlutterLayer(data: args as! [String: Any])
        let layer = layersController.getLayerByLayerId(flutterLayer.layerId) ?? flutterLayer.createNativeLayer()
        do {
            let legendInfos = try await layer.legendInfos

            let legendInfosFlutter = await legendInfos.asyncMap { legendInfo -> [String: Any?] in
                guard let symbol = legendInfo.symbol else {
                    return ["name": legendInfo.name]
                }

                do {
                    let image = try await symbol.makeSwatch(scale: UIScreen.main.scale)
                    let pngData = image.pngData()
                    return ["name": legendInfo.name, "symbolImage": pngData]
                } catch {
                    return ["name": legendInfo.name]
                }
            }

            return [
                "layerId": flutterLayer.layerId,
                "layerName": layer.name,
                "legendInfos": legendInfosFlutter
            ] as [String: Any]

        } catch {
            return FlutterError(code: "getLegendInfos", message: "Error getting legend infos for layerId:\(flutterLayer.layerId)", details: error.localizedDescription)
        }
    }
}