package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.graphics.Color
import com.arcgismaps.geometry.Polyline
import com.arcgismaps.mapping.symbology.SimpleFillSymbol
import com.arcgismaps.mapping.symbology.SimpleFillSymbolStyle
import com.arcgismaps.mapping.symbology.SimpleLineSymbol
import com.arcgismaps.mapping.symbology.SimpleLineSymbolStyle
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.toSimpleLineSymbolStyle
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toArcGISMapOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColor
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColorOrNull
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilterController


class PolygonController(polygonId: String) : BaseGraphicController(), PolygonControllerSink {
    private val polygonSymbol: SimpleFillSymbol
    private val polygonStrokeSymbol: SimpleLineSymbol =
        SimpleLineSymbol(SimpleLineSymbolStyle.Solid, Color.BLACK.toArcgisColor(), 10f)

    init {
        polygonSymbol =
            SimpleFillSymbol(
                SimpleFillSymbolStyle.Solid,
                Color.BLACK.toArcgisColor(),
                polygonStrokeSymbol
            )
        graphic.symbol = polygonSymbol
        graphic.attributes["polygonId"] = polygonId
    }

    override var fillColor: com.arcgismaps.Color
        get() = polygonSymbol.color
        set(value) {
            polygonSymbol.color = value
        }
    override var strokeColor: com.arcgismaps.Color
        get() = polygonStrokeSymbol.color
        set(value) {
            polygonStrokeSymbol.color = value
        }
    override var strokeWidth: Float
        get() = polygonStrokeSymbol.width
        set(value) {
            polygonStrokeSymbol.width = value
        }
    override var strokeStyle: SimpleLineSymbolStyle
        get() = polygonStrokeSymbol.style
        set(value) {
            polygonStrokeSymbol.style = value
        }

    override fun interpretGraphicController(
        data: Map<*, *>,
        symbolVisibilityFilterController: SymbolVisibilityFilterController?
    ) {
        super.interpretGraphicController(data, symbolVisibilityFilterController)
        val fillColor = data["fillColor"]?.toArcgisColorOrNull()
        if (fillColor != null) {
            this.fillColor = fillColor
        }
        val strokeColor = data["strokeColor"]?.toArcgisColorOrNull()
        if (strokeColor != null) {
            this.strokeColor = strokeColor
        }
        val strokeWidth = data["strokeWidth"] as Double?
        if (strokeWidth != null) {
            this.strokeWidth = strokeWidth.toFloat()
        }
        val strokeStyle = (data["strokeStyle"] as Int?)?.toSimpleLineSymbolStyle()
        if (strokeStyle != null) {
            this.strokeStyle = strokeStyle
        }
        val spatialReference = data["spatialReference"]?.toSpatialReferenceOrNull()
        val pointsRaw = (data["points"] as? List<*>)?.map { it!!.toPointOrNull()!! }
        if (pointsRaw != null) {
            geometry = Polyline(pointsRaw, spatialReference)
        }
    }
}