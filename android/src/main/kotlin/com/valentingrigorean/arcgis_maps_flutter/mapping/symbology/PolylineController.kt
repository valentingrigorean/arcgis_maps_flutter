package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.graphics.Color
import com.arcgismaps.geometry.Polyline
import com.arcgismaps.geometry.PolylineBuilder
import com.arcgismaps.mapping.symbology.SimpleLineSymbol
import com.arcgismaps.mapping.symbology.SimpleLineSymbolStyle
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.toSimpleLineSymbolStyle
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColor
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColorOrNull
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilterController


class PolylineController(polylineId: String) : BaseGraphicController(), PolylineControllerSink {
    private val polylineSymbol: SimpleLineSymbol =
        SimpleLineSymbol(SimpleLineSymbolStyle.Solid, com.arcgismaps.Color(Color.BLACK), 10f)

    init {
        graphic.symbol = polylineSymbol
        graphic.attributes["polylineId"] = polylineId
    }

    override var color: com.arcgismaps.Color
        get() = polylineSymbol.color
        set(value) {
            polylineSymbol.color = value
        }
    override var width: Float
        get() = polylineSymbol.width
        set(value) {
            polylineSymbol.width = value
        }
    override var style: SimpleLineSymbolStyle
        get() = polylineSymbol.style
        set(value) {
            polylineSymbol.style = value
        }
    override var antialias: Boolean
        get() = polylineSymbol.antiAlias
        set(value) {
            polylineSymbol.antiAlias = value
        }

    override fun interpretGraphicController(
        data: Map<*, *>,
        symbolVisibilityFilterController: SymbolVisibilityFilterController?
    ) {
        super.interpretGraphicController(data, symbolVisibilityFilterController)
        val color = data["color"]?.toArcgisColorOrNull()
        if (color != null) {
            this.color = color
        }
        val width = data["width"] as Double?
        if (width != null) {
            this.width = width.toFloat()
        }

        val style = (data["style"] as Int?)?.toSimpleLineSymbolStyle()
        if (style != null) {
            this.style = style
        }
        val antialias = data["antialias"] as Boolean?
        if (antialias != null) {
            this.antialias = antialias
        }

        val spatialReference = data["spatialReference"]?.toSpatialReferenceOrNull()
        val pointsRaw = (data["points"] as? List<*>)?.map { it!!.toPointOrNull()!! }
        if (pointsRaw != null) {
            geometry = PolylineBuilder(pointsRaw, spatialReference).toGeometry()
        }
    }
}