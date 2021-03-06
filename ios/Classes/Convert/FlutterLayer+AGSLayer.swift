//
// Created by Valentin Grigorean on 25.03.2021.
//

import Foundation
import ArcGIS

extension FlutterLayer {
    func createNativeLayer() -> AGSLayer {
        switch layerType {
        case "VectorTileLayer":
            let layer = AGSArcGISVectorTiledLayer(url: url!)
            layer.credential = credential
            setupDefaultParams(layer: layer)
            return layer
        case "FeatureLayer":
            let featureTable = AGSServiceFeatureTable(url: url!)
            featureTable.credential = credential
            let featureLayer = AGSFeatureLayer(featureTable: featureTable)
            setupDefaultParams(layer: featureLayer)
            return featureLayer
        case "TiledLayer":
            let layer = AGSArcGISTiledLayer(url: url!)
            layer.credential = credential
            setupDefaultParams(layer: layer)
            return layer
        case "ArcGISMapImageLayer":
            let mapImageLayer = AGSArcGISMapImageLayer(url: url!)
            mapImageLayer.credential = credential
            setupDefaultParams(layer: mapImageLayer)
            return mapImageLayer
        case "WmsLayer":
            let wmsLayer = AGSWMSLayer(url: url!, layerNames: layersName!)
            wmsLayer.credential = credential
            setupDefaultParams(layer: wmsLayer)
            return wmsLayer
        default:
            fatalError("Not implemented.")
        }
    }

    func setupDefaultParams(layer: AGSLayer) {
        layer.opacity = opacity
        layer.isVisible = isVisible
    }
}