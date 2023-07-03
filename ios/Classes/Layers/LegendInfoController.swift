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
            let results = try await layer.legendInfos

        } catch {
            return FlutterError(code: "getLegendInfos", message: "Error getting legend infos for layerId:\(flutterLayer.layerId)", details: error.localizedDescription)
        }
    }
}