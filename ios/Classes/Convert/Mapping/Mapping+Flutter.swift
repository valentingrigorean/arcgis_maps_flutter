//
// Created by Valentin Grigorean on 26.06.2023.
//

import Foundation
import ArcGIS

extension Basemap.Style{
    init(_ flutterValue:Int){
        switch flutterValue {
        case 0:
            return .arcGISChartedTerritory
        case 1:
            return .arcGISChartedTerritoryBase
        case 2:
            return .arcGISColoredPencil
        case 3:
            return .arcGISCommunity
        case 4:
            return .arcGISDarkGray
        case 5:
            return .arcGISDarkGrayBase
        case 6:
            return .arcGISDarkGrayLabels
        case 7:
            return .arcGISHillshadeDark
        case 8:
            return .arcGISHillshadeLight
        case 9:
            return .arcGISImagery
        case 10:
            return .arcGISImageryLabels
        case 11:
            return .arcGISImageryStandard
        case 12:
            return .arcGISLightGray
        case 13:
            return .arcGISLightGrayBase
        case 14:
            return .arcGISLightGrayLabels
        case 15:
            return .arcGISMidcentury
        case 16:
            return .arcGISModernAntique
        case 17:
            return .arcGISModernAntiqueBase
        case 18:
            return .arcGISNavigation
        case 19:
            return .arcGISNavigationNight
        case 20:
            return .arcGISNewspaper
        case 21:
            return .arcGISNova
        case 22:
            return .arcGISOceans
        case 23:
            return .arcGISOceansBase
        case 24:
            return .arcGISOceansLabels
        case 25:
            return .arcGISStreets
        case 26:
            return .arcGISStreetsNight
        case 27:
            return .arcGISStreetsRelief
        case 28:
            return .arcGISStreetsReliefBase
        case 29:
            return .arcGISTerrain
        case 30:
            return .arcGISTerrainBase
        case 31:
            return .arcGISTerrainDetail
        case 32:
            return .arcGISTopographic
        case 33:
            return .arcGISTopographicBase
        case 34:
            return .osmDarkGray
        case 35:
            return .osmDarkGrayBase
        case 36:
            return .osmDarkGrayLabels
        case 37:
            return .osmLightGray
        case 38:
            return .osmLightGrayBase
        case 39:
            return .osmLightGrayLabels
        case 40:
            return .osmStandard
        case 41:
            return .osmStandardRelief
        case 42:
            return .osmStandardReliefBase
        case 43:
            return .osmStreets
        case 44:
            return .osmStreetsRelief
        case 45:
            return .osmStreetsReliefBase
        default:
            fatalError("Invalid value: \(self)")
        }
    }
}