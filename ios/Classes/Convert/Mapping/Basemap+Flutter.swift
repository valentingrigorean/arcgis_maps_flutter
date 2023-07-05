//
// Created by Valentin Grigorean on 26.06.2023.
//

import Foundation
import ArcGIS

extension Basemap.Style {
    init(_ flutterValue: Int) {
        switch flutterValue {
        case 0:
            self = .arcGISChartedTerritory
        case 1:
            self = .arcGISChartedTerritoryBase
        case 2:
            self = .arcGISColoredPencil
        case 3:
            self = .arcGISCommunity
        case 4:
            self = .arcGISDarkGray
        case 5:
            self = .arcGISDarkGrayBase
        case 6:
            self = .arcGISDarkGrayLabels
        case 7:
            self = .arcGISHillshadeDark
        case 8:
            self = .arcGISHillshadeLight
        case 9:
            self = .arcGISImagery
        case 10:
            self = .arcGISImageryLabels
        case 11:
            self = .arcGISImageryStandard
        case 12:
            self = .arcGISLightGray
        case 13:
            self = .arcGISLightGrayBase
        case 14:
            self = .arcGISLightGrayLabels
        case 15:
            self = .arcGISMidcentury
        case 16:
            self = .arcGISModernAntique
        case 17:
            self = .arcGISModernAntiqueBase
        case 18:
            self = .arcGISNavigation
        case 19:
            self = .arcGISNavigationNight
        case 20:
            self = .arcGISNewspaper
        case 21:
            self = .arcGISNova
        case 22:
            self = .arcGISOceans
        case 23:
            self = .arcGISOceansBase
        case 24:
            self = .arcGISOceansLabels
        case 25:
            self = .arcGISStreets
        case 26:
            self = .arcGISStreetsNight
        case 27:
            self = .arcGISStreetsRelief
        case 28:
            self = .arcGISStreetsReliefBase
        case 29:
            self = .arcGISTerrain
        case 30:
            self = .arcGISTerrainBase
        case 31:
            self = .arcGISTerrainDetail
        case 32:
            self = .arcGISTopographic
        case 33:
            self = .arcGISTopographicBase
        case 34:
            self = .osmDarkGray
        case 35:
            self = .osmDarkGrayBase
        case 36:
            self = .osmDarkGrayLabels
        case 37:
            self = .osmLightGray
        case 38:
            self = .osmLightGrayBase
        case 39:
            self = .osmLightGrayLabels
        case 40:
            self = .osmStandard
        case 41:
            self = .osmStandardRelief
        case 42:
            self = .osmStandardReliefBase
        case 43:
            self = .osmStreets
        case 44:
            self = .osmStreetsRelief
        case 45:
            self = .osmStreetsReliefBase
        default:
            fatalError("Unknown basemap style \(flutterValue)")
        }
    }
}


extension Basemap {
    convenience init(data: Dictionary<String, Any>) {
        if let basemapStyle = data["basemapStyle"] as? Int {
            self.init(style: Basemap.Style(basemapStyle))
            return
        }

        if let portalItem = data["portalItem"] as? Dictionary<String, Any> {
            self.init(item: PortalItem(data: portalItem))
            return
        }

        if let baseLayer = data["baseLayer"] as? Dictionary<String, Any> {
            let flutterLayer = FlutterLayer(data: baseLayer)
            self.init(baseLayer: flutterLayer.createNativeLayer())
            return
        }

        if let uri = data["uri"] as? String {
            self.init(url: URL(string: uri)!)!
            return
        }

        let baseLayers = (data["baseLayers"] as? [Dictionary<String, Any>] ?? []).map { (baseLayer) -> Layer in
            let flutterLayer = FlutterLayer(data: baseLayer)
            return flutterLayer.createNativeLayer()
        }

        let referenceLayers = (data["referenceLayers"] as? [Dictionary<String, Any>] ?? []).map { (baseLayer) -> Layer in
            let flutterLayer = FlutterLayer(data: baseLayer)
            return flutterLayer.createNativeLayer()
        }

        self.init(baseLayers: baseLayers, referenceLayers: referenceLayers)
    }
}