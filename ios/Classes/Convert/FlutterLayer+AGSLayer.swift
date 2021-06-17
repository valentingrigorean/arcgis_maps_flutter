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
            return layer
        case "FeatureLayer":
            let featureTable = AGSServiceFeatureTable(url: url!)
            featureTable.credential = credential
            return AGSFeatureLayer(featureTable: featureTable)
        case "TiledLayer":
            let layer = AGSArcGISTiledLayer(url: url!)
            layer.credential = credential
            return layer
        default:
            fatalError("Not implemented.")
        }

    }
}