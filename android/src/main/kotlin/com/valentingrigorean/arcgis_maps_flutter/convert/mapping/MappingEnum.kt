package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.BasemapStyle
import com.arcgismaps.mapping.ViewpointType

fun Int.toBasemapStyle(): BasemapStyle {
    return when (this) {
        0 -> BasemapStyle.ArcGISChartedTerritory
        1 -> BasemapStyle.ArcGISChartedTerritoryBase
        2 -> BasemapStyle.ArcGISColoredPencil
        3 -> BasemapStyle.ArcGISCommunity
        4 -> BasemapStyle.ArcGISDarkGray
        5 -> BasemapStyle.ArcGISDarkGrayBase
        6 -> BasemapStyle.ArcGISDarkGrayLabels
        7 -> BasemapStyle.ArcGISHillshadeDark
        8 -> BasemapStyle.ArcGISHillshadeLight
        9 -> BasemapStyle.ArcGISImagery
        10 -> BasemapStyle.ArcGISImageryLabels
        11 -> BasemapStyle.ArcGISImageryStandard
        12 -> BasemapStyle.ArcGISLightGray
        13 -> BasemapStyle.ArcGISLightGrayBase
        14 -> BasemapStyle.ArcGISLightGrayLabels
        15 -> BasemapStyle.ArcGISMidcentury
        16 -> BasemapStyle.ArcGISModernAntique
        17 -> BasemapStyle.ArcGISModernAntiqueBase
        18 -> BasemapStyle.ArcGISNavigation
        19 -> BasemapStyle.ArcGISNavigationNight
        20 -> BasemapStyle.ArcGISNewspaper
        21 -> BasemapStyle.ArcGISNova
        22 -> BasemapStyle.ArcGISOceans
        23 -> BasemapStyle.ArcGISOceansBase
        24 -> BasemapStyle.ArcGISOceansLabels
        25 -> BasemapStyle.ArcGISStreets
        26 -> BasemapStyle.ArcGISStreetsNight
        27 -> BasemapStyle.ArcGISStreetsRelief
        28 -> BasemapStyle.ArcGISStreetsReliefBase
        29 -> BasemapStyle.ArcGISTerrain
        30 -> BasemapStyle.ArcGISTerrainBase
        31 -> BasemapStyle.ArcGISTerrainDetail
        32 -> BasemapStyle.ArcGISTopographic
        33 -> BasemapStyle.ArcGISTopographicBase
        34 -> BasemapStyle.OsmDarkGray
        35 -> BasemapStyle.OsmDarkGrayBase
        36 -> BasemapStyle.OsmDarkGrayLabels
        37 -> BasemapStyle.OsmLightGray
        38 -> BasemapStyle.OsmLightGrayBase
        39 -> BasemapStyle.OsmLightGrayLabels
        40 -> BasemapStyle.OsmStandard
        41 -> BasemapStyle.OsmStandardRelief
        42 -> BasemapStyle.OsmStandardReliefBase
        43 -> BasemapStyle.OsmStreets
        44 -> BasemapStyle.OsmStreetsRelief
        45 -> BasemapStyle.OsmStreetsReliefBase
        else -> throw IllegalArgumentException("Invalid value: $this")
    }
}

fun ViewpointType.toFlutterValue() : Int{
    return when(this){
        ViewpointType.CenterAndScale -> 0
        ViewpointType.BoundingGeometry -> 1
    }
}

fun Int.toViewpointType() : ViewpointType{
    return when(this){
        0 -> ViewpointType.CenterAndScale
        1 -> ViewpointType.BoundingGeometry
        else -> throw IllegalArgumentException("Invalid value: $this")
    }
}
