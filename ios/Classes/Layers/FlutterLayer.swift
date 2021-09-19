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
        if let url = data["url"] as? String {
            self.url = URL(string: url)
            portalItem = nil
        } else if let portalItemData = data["portalItem"] as? Dictionary<String, Any>{
            url = nil
            portalItem = AGSPortalItem(data: portalItemData)
        }else{
            url = nil
            portalItem = nil
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
    let layersName: [String]?

    let credential: AGSCredential?

    let serviceImageTiledLayerOptions: ServiceImageTiledLayerOptions?
    let groupLayerOptions: GroupLayerOptions?

    let portalItem: AGSPortalItem?
    let portalItemLayerId: Int?

    var hashValue: Int {
        layerId.hashValue
    }
}
