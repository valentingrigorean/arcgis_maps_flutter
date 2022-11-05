//
// Created by Valentin Grigorean on 25.03.2021.
//

import Foundation
import ArcGIS

struct ServiceImageTiledLayerOptions: Hashable, Equatable {
    let tileInfo: AGSTileInfo
    let fullExtent: AGSEnvelope

    let urlTemplate: String
    let subdomains: [String]

    let additionalOptions: Dictionary<String, String>
}

struct GroupLayerOptions: Hashable, Equatable {
    let showChildrenInLegend: Bool
    let visibilityMode: AGSGroupVisibilityMode
    let layers: [FlutterLayer]
}


struct FlutterLayer: Hashable, Equatable {

    init(data: Dictionary<String, Any>) {
        layerId = data["layerId"] as! String
        layerType = data["layerType"] as! String
        featureLayersIds = data["featureLayersIds"] as? [Int]
        if let url = data["url"] as? String {
            self.url = URL(string: url)
            portalItem = nil
            tileCache = nil
        } else if let portalItemData = data["portalItem"] as? Dictionary<String, Any> {
            url = nil
            tileCache = nil
            portalItem = AGSPortalItem(data: portalItemData)
        } else if let tileCache = data["tileCache"] as? Dictionary<String, Any> {
            url = nil
            portalItem = nil
            self.tileCache = AGSTileCache.createFlutter(data: tileCache)
        } else {
            url = nil
            portalItem = nil
            tileCache = nil
        }

        isVisible = data["isVisible"] as! Bool
        opacity = Float(data["opacity"] as! Double)

        if let credential = data["credential"] as? Dictionary<String, Any> {
            self.credential = AGSCredential(data: credential)
        } else {
            credential = nil
        }

        layersName = data["layersName"] as? [String]

        switch (layerType) {
        case "ServiceImageTiledLayer":
            serviceImageTiledLayerOptions = ServiceImageTiledLayerOptions(
                    tileInfo: AGSTileInfo(data: data["tileInfo"] as! Dictionary<String, Any>),
                    fullExtent: AGSEnvelope(data: data["fullExtent"] as! Dictionary<String, Any>),
                    urlTemplate: data["url"] as! String,
                    subdomains: data["subdomains"] as! [String],
                    additionalOptions: data["additionalOptions"] as! Dictionary<String, String>
            )
            groupLayerOptions = nil
            portalItemLayerId = nil
            break
        case "GroupLayer":
            groupLayerOptions = GroupLayerOptions(
                    showChildrenInLegend: data["showChildrenInLegend"] as! Bool,
                    visibilityMode: AGSGroupVisibilityMode(rawValue: data["visibilityMode"] as! Int) ?? .independent,
                    layers: (data["layers"] as! [Any]).map {
                        FlutterLayer(data: $0 as! Dictionary<String, Any>)
                    })
            serviceImageTiledLayerOptions = nil
            portalItemLayerId = nil
            break
        case "FeatureLayer":
            portalItemLayerId = data["portalItemLayerId"] as? Int
            serviceImageTiledLayerOptions = nil
            groupLayerOptions = nil
            break
        default:
            serviceImageTiledLayerOptions = nil
            groupLayerOptions = nil
            portalItemLayerId = nil
            break
        }
    }

    let layerId: String
    let layerType: String
    let opacity: Float
    let isVisible: Bool
    let url: URL?
    let tileCache: AGSTileCache?
    let layersName: [String]?

    let featureLayersIds: [Int]?

    let credential: AGSCredential?

    let serviceImageTiledLayerOptions: ServiceImageTiledLayerOptions?
    let groupLayerOptions: GroupLayerOptions?

    let portalItem: AGSPortalItem?
    let portalItemLayerId: Int?

    func hash(into hasher: inout Hasher) {
        hasher.combine(layerId)
    }

    static func ==(lhs: FlutterLayer, rhs: FlutterLayer) -> Bool {
        if lhs.layerId != rhs.layerId {
            return false
        }
        return true
    }

    func createNativeLayer() -> AGSLayer {
        switch layerType {
        case "GeodatabaseLayer":
            let layer = AGSGroupLayer()
            let geodatabase = AGSGeodatabase(fileURL: url!)
            geodatabase.load { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    geodatabase.geodatabaseFeatureTables.forEach { table in
                        guard let featureLayersIds = featureLayersIds else {
                            let featureLayer = AGSFeatureLayer(featureTable: table)
                            layer.layers.add(featureLayer)
                            return
                        }
                        if featureLayersIds.contains(table.serviceLayerID)  {
                            let featureLayer = AGSFeatureLayer(featureTable: table)
                            layer.layers.add(featureLayer)
                        }
                    }
                }
            }
            setupDefaultParams(layer: layer)
            return layer
        case "VectorTileLayer":
            let layer = AGSArcGISVectorTiledLayer(url: url!)
            layer.credential = credential
            setupDefaultParams(layer: layer)
            return layer
        case "FeatureLayer":
            let featureLayer: AGSFeatureLayer
            if let url = url {
                let featureTable = AGSServiceFeatureTable(url: url)
                featureTable.credential = credential
                featureLayer = AGSFeatureLayer(featureTable: featureTable)
            } else {
                featureLayer = AGSFeatureLayer(item: portalItem!, layerID: portalItemLayerId!)
            }
            setupDefaultParams(layer: featureLayer)
            return featureLayer
        case "TiledLayer":
            let layer: AGSArcGISTiledLayer
            if let tileCache = tileCache {
                layer = AGSArcGISTiledLayer(tileCache: tileCache)
            } else {
                layer = AGSArcGISTiledLayer(url: url!)
            }
            layer.credential = credential
            setupDefaultParams(layer: layer)
            return layer
        case "MapImageLayer":
            let mapImageLayer = AGSArcGISMapImageLayer(url: url!)
            mapImageLayer.credential = credential
            setupDefaultParams(layer: mapImageLayer)
            return mapImageLayer
        case "WmsLayer":
            let wmsLayer = AGSWMSLayer(url: url!, layerNames: layersName!)
            wmsLayer.credential = credential
            setupDefaultParams(layer: wmsLayer)
            return wmsLayer
        case "ServiceImageTiledLayer":
            let layer = FlutterServiceImageTiledLayer(
                    tileInfo: serviceImageTiledLayerOptions!.tileInfo,
                    fullExtent: serviceImageTiledLayerOptions!.fullExtent,
                    urlTemplate: serviceImageTiledLayerOptions!.urlTemplate,
                    subdomains: serviceImageTiledLayerOptions!.subdomains,
                    additionalOptions: serviceImageTiledLayerOptions!.additionalOptions)
            setupDefaultParams(layer: layer)
            return layer
        case "GroupLayer":
            let groupLayer = AGSGroupLayer(childLayers: groupLayerOptions!.layers.map {
                $0.createNativeLayer()
            })
            groupLayer.showChildrenInLegend = groupLayerOptions!.showChildrenInLegend
            groupLayer.visibilityMode = groupLayerOptions!.visibilityMode
            setupDefaultParams(layer: groupLayer)
            return groupLayer
        default:
            fatalError("Not implemented.")
        }
    }

    private func setupDefaultParams(layer: AGSLayer) {
        layer.opacity = opacity
        layer.isVisible = isVisible
    }
}
