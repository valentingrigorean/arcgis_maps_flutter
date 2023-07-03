//
// Created by Valentin Grigorean on 25.03.2021.
//

import Foundation
import ArcGIS

extension TileInfo {
    func isEqualTo(_ other: TileInfo) -> Bool {
        // Implement your comparison logic here.
        // For example:
        dpi == other.dpi &&
                format == other.format &&
                levelsOfDetail == other.levelsOfDetail &&
                origin == other.origin &&
                spatialReference == other.spatialReference &&
                tileHeight == other.tileHeight &&
                tileWidth == other.tileWidth
    }

    var hashValue: Int {
        var hasher = Hasher()
        hasher.combine(dpi)
        hasher.combine(format)
        hasher.combine(levelsOfDetail)
        hasher.combine(origin)
        hasher.combine(spatialReference)
        hasher.combine(tileHeight)
        hasher.combine(tileWidth)
        return hasher.finalize()
    }
}

struct ServiceImageTiledLayerOptions: Hashable, Equatable {


    let tileInfo: TileInfo
    let fullExtent: Envelope

    let urlTemplate: String
    let subdomains: [String]

    let additionalOptions: Dictionary<String, String>

    static func ==(lhs: ServiceImageTiledLayerOptions, rhs: ServiceImageTiledLayerOptions) -> Bool {
        lhs.tileInfo.isEqualTo(rhs.tileInfo) &&
                lhs.fullExtent == rhs.fullExtent &&
                lhs.urlTemplate == rhs.urlTemplate &&
                lhs.subdomains == rhs.subdomains &&
                lhs.additionalOptions == rhs.additionalOptions
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(tileInfo.hashValue)
        hasher.combine(fullExtent.hashValue)
        hasher.combine(urlTemplate)
        hasher.combine(subdomains)
        hasher.combine(additionalOptions)
    }
}

struct GroupLayerOptions: Hashable, Equatable {
    let showChildrenInLegend: Bool
    let visibilityMode: GroupLayer.VisibilityMode
    let layers: [FlutterLayer]
}

extension GroupLayer.VisibilityMode{
    init(_ flutterValue:Int){
        switch flutterValue {
        case 0:
            self = .independent
        case 1:
            self = .inherited
        case 2:
            self = .exclusive
        default:
            fatalError("VisibilityMode not supported")
        }
    }
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
            portalItem = PortalItem(data: portalItemData)
        } else if let tileCache = data["tileCache"] as? Dictionary<String, Any> {
            url = nil
            portalItem = nil
            self.tileCache = TileCache.createFlutter(data: tileCache)
        } else {
            url = nil
            portalItem = nil
            tileCache = nil
        }

        isVisible = data["isVisible"] as! Bool
        opacity = Float(data["opacity"] as! Double)

        layersName = data["layersName"] as? [String]

        switch (layerType) {
        case "ServiceImageTiledLayer":
            serviceImageTiledLayerOptions = ServiceImageTiledLayerOptions(
                    tileInfo: TileInfo(data: data["tileInfo"] as! Dictionary<String, Any>),
                    fullExtent: Envelope(data: data["fullExtent"] as! Dictionary<String, Any>),
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
                    visibilityMode: GroupLayer.VisibilityMode(data["visibilityMode"] as! Int),
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
    let tileCache: TileCache?
    let layersName: [String]?

    let featureLayersIds: [Int]?

    let serviceImageTiledLayerOptions: ServiceImageTiledLayerOptions?
    let groupLayerOptions: GroupLayerOptions?

    let portalItem: PortalItem?
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

    func createNativeLayer()  ->  Layer {
        switch layerType {
        case "GeodatabaseLayer":
            let layer = GroupLayer()
            let geodatabase = Geodatabase(fileURL: url!)
            Task {
                do {
                    try await geodatabase.load()
                    geodatabase.featureTables.forEach { table in
                        guard let featureLayersIds = featureLayersIds else {
                            let featureLayer = FeatureLayer(featureTable: table)
                            layer.addLayer(featureLayer)
                            return
                        }
                        if featureLayersIds.contains(table.serviceLayerID)  {
                            let featureLayer = FeatureLayer(featureTable: table)
                            layer.addLayer(featureLayer)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            setupDefaultParams(layer: layer)
            return layer
        case "VectorTileLayer":
            let layer = ArcGISVectorTiledLayer(url: url!)
            setupDefaultParams(layer: layer)
            return layer
        case "FeatureLayer":
            let featureLayer: FeatureLayer
            if let url = url {
                let featureTable = ServiceFeatureTable(url: url)
                featureLayer = FeatureLayer(featureTable: featureTable)
            } else {
                featureLayer = FeatureLayer(featureServiceItem: portalItem!, layerID: portalItemLayerId!)
            }
            setupDefaultParams(layer: featureLayer)
            return featureLayer
        case "TiledLayer":
            let layer: ArcGISTiledLayer
            if let tileCache = tileCache {
                layer = ArcGISTiledLayer(tileCache: tileCache)
            } else {
                layer = ArcGISTiledLayer(url: url!)
            }
            setupDefaultParams(layer: layer)
            return layer
        case "MapImageLayer":
            let mapImageLayer = ArcGISMapImageLayer(url: url!)
            setupDefaultParams(layer: mapImageLayer)
            return mapImageLayer
        case "WmsLayer":
            let wmsLayer = WMSLayer(url: url!, layerNames: layersName!)
            setupDefaultParams(layer: wmsLayer)
            return wmsLayer
        case "GroupLayer":
            let groupLayer = GroupLayer(layers: groupLayerOptions!.layers.map {
                $0.createNativeLayer()
            })
            groupLayer.showsChildrenInLegend = groupLayerOptions!.showChildrenInLegend
            groupLayer.visibilityMode = groupLayerOptions!.visibilityMode
            setupDefaultParams(layer: groupLayer)
            return groupLayer
        default:
            fatalError("Not implemented.")
        }
    }

    private func setupDefaultParams(layer: Layer) {
        layer.id = Layer.ID(rawValue: layerId)
        layer.opacity = opacity
        layer.isVisible = isVisible
    }
}
