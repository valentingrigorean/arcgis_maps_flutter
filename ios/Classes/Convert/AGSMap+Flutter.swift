//
// Created by Valentin Grigorean on 24.03.2021.
//

import Foundation
import ArcGIS

extension AGSMap {
    convenience init(data: Dictionary<String, Any>) {
        if let baseMap = data["baseMap"] as? String {
            self.init(basemap: AGSMap.getBasemap(baseMap: baseMap))
            return
        }

        if let basemapTypeOptions = data["basemapTypeOptions"] as? Dictionary<String, Any> {
            let basemapType = AGSMap.getBasemapType(basemapType: basemapTypeOptions["basemapType"] as! String)
            self.init(basemapType: basemapType, latitude: basemapTypeOptions["latitude"] as! Double, longitude: basemapTypeOptions["longitude"] as! Double, levelOfDetail: basemapTypeOptions["levelOfDetail"] as! Int)
            return
        }

        if let baseLayer = data["baseLayer"] as? Dictionary<String, Any> {
            let flutterLayer = FlutterLayer(data: baseLayer)
            self.init(basemap: AGSBasemap(baseLayer: flutterLayer.createNativeLayer()))
            return
        }

        if let rawPortalItem = data["portalItem"] as? Dictionary<String, Any> {
            let portalItem = AGSPortalItem(data: rawPortalItem)
            self.init(item: portalItem)
            return
        }

        self.init()
    }


    private static func getBasemapType(basemapType: String) -> AGSBasemapType {
        switch basemapType {
        case "imagery":
            return .imagery
        case "imageryWithLabels":
            return .imageryWithLabels
        case "streets":
            return .streets
        case "topographic":
            return .topographic
        case "terrainWithLabels":
            return .terrainWithLabels
        case "lightGrayCanvas":
            return .lightGrayCanvas
        case "nationalGeographic":
            return .nationalGeographic
        case "oceans":
            return .oceans
        case "openStreetMap":
            return .openStreetMap
        case "imageryWithLabelsVector":
            return .imageryWithLabelsVector
        case "streetsVector":
            return .streetsVector
        case "topographicVector":
            return .topographicVector
        case "terrainWithLabelsVector":
            return .terrainWithLabelsVector
        case "lightGrayCanvasVector":
            return .lightGrayCanvasVector
        case "navigationVector":
            return .navigationVector
        case "streetsNightVector":
            return .streetsNightVector
        case "streetsWithReliefVector":
            return .streetsWithReliefVector
        case "darkGrayCanvasVector":
            return .darkGrayCanvasVector
        default:
            fatalError("Not implemented.")
        }
    }


    private static func getBasemap(baseMap: String) -> AGSBasemap {
        switch baseMap {
        case "streets":
            return AGSBasemap.streets()
        case "topographic":
            return AGSBasemap.topographic()
        case "imagery":
            return AGSBasemap.imagery()
        case "darkGrayCanvasVector":
            return AGSBasemap.darkGrayCanvasVector()
        case "imageryWithLabelsVector":
            return AGSBasemap.imageryWithLabelsVector()
        case "lightGrayCanvasVector":
            return AGSBasemap.lightGrayCanvasVector()
        case "navigationVector":
            return AGSBasemap.navigationVector()
        case "openStreetMap":
            return AGSBasemap.openStreetMap()
        case "streetsNightVector":
            return AGSBasemap.streetsNightVector()
        case "streetsVector":
            return AGSBasemap.streetsVector()
        case "streetsWithReliefVector":
            return AGSBasemap.streetsWithReliefVector()
        case "terrainWithLabelsVector":
            return AGSBasemap.terrainWithLabelsVector()
        case "topographicVector":
            return AGSBasemap.topographicVector()
        case "lightGrayCanvas":
            return AGSBasemap.lightGrayCanvas()
        case "oceans":
            return AGSBasemap.oceans()
        case "nationalGeographic":
            return AGSBasemap.nationalGeographic()
        case "imageryWithLabels":
            return AGSBasemap.imageryWithLabels()
        case "terrainWithLabels":
            return AGSBasemap.terrainWithLabels()
        default:
            fatalError("Not implemented.")
        }
    }
}
