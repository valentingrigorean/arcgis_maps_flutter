package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.arcgisservices.LabelingPlacement
import com.arcgismaps.mapping.labeling.ArcadeLabelExpression
import com.arcgismaps.mapping.labeling.LabelDefinition
import com.arcgismaps.mapping.labeling.LabelExpression
import com.arcgismaps.mapping.labeling.SimpleLabelExpression
import com.arcgismaps.mapping.symbology.TextSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.interpretTextSymbol

private fun String.toLabelingPlacement(): LabelingPlacement {
    return when (this) {
        "automatic" -> LabelingPlacement.Automatic
        "lineAboveAfter" -> LabelingPlacement.LineAboveAfter
        "lineAboveAlong" -> LabelingPlacement.LineAboveAlong
        "lineAboveBefore" -> LabelingPlacement.LineAboveBefore
        "lineAboveEnd" -> LabelingPlacement.LineAboveEnd
        "lineAboveStart" -> LabelingPlacement.LineAboveStart
        "lineBelowAfter" -> LabelingPlacement.LineBelowAfter
        "lineBelowAlong" -> LabelingPlacement.LineBelowAlong
        "lineBelowBefore" -> LabelingPlacement.LineBelowBefore
        "lineBelowEnd" -> LabelingPlacement.LineBelowEnd
        "lineBelowStart" -> LabelingPlacement.LineBelowStart
        "lineCenterAfter" -> LabelingPlacement.LineCenterAfter
        "lineCenterAlong" -> LabelingPlacement.LineCenterAlong
        "lineCenterBefore" -> LabelingPlacement.LineCenterBefore
        "lineCenterEnd" -> LabelingPlacement.LineCenterEnd
        "lineCenterStart" -> LabelingPlacement.LineCenterStart
        "pointAboveCenter" -> LabelingPlacement.PointAboveCenter
        "pointAboveLeft" -> LabelingPlacement.PointAboveLeft
        "pointAboveRight" -> LabelingPlacement.PointAboveRight
        "pointBelowCenter" -> LabelingPlacement.PointBelowCenter
        "pointBelowLeft" -> LabelingPlacement.PointBelowLeft
        "pointBelowRight" -> LabelingPlacement.PointBelowRight
        "pointCenterCenter" -> LabelingPlacement.PointCenterCenter
        "pointCenterLeft" -> LabelingPlacement.PointCenterLeft
        "pointCenterRight" -> LabelingPlacement.PointCenterRight
        "polygonAlwaysHorizontal" -> LabelingPlacement.PolygonAlwaysHorizontal
        "unknown" -> LabelingPlacement.Unknown
        else -> throw IllegalArgumentException("Unknown LabelingPlacement $this")
    }
}

fun Any.toLabelDefinitionOrNull(): LabelDefinition? {
    val data = this as Map<*, *>? ?: return null
    val labelExpression = data["labelExpression"] as Map<*, *>
    val textSymbol = data["textSymbol"]?.let {
        TextSymbol().apply { interpretTextSymbol(it as Map<*, *>) }
    }
    val labelDefinition = LabelDefinition(parseLabelExpression(labelExpression), textSymbol)
    data["labelPlacement"]?.let {
        labelDefinition.placement = (it as String).toLabelingPlacement()
    }
    data["minScale"]?.let {
        labelDefinition.minScale = it as Double
    }
    data["maxScale"]?.let {
        labelDefinition.maxScale = it as Double
    }
    return labelDefinition
}


private fun parseLabelExpression(json: Map<*, *>): LabelExpression {
    return when (json["type"] as String) {
        "simple" -> SimpleLabelExpression(json["value"] as String)
        "arcade" -> ArcadeLabelExpression(json["value"] as String)
        else -> throw IllegalArgumentException("Unknown LabelExpression type ${json["type"]}")
    }
}