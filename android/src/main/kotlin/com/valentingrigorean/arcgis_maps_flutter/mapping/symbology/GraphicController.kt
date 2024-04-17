package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import com.arcgismaps.geometry.Geometry
import com.arcgismaps.mapping.symbology.Symbol
import com.arcgismaps.mapping.view.Graphic
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.map.toSymbolVisibilityFilterOrNull

class GraphicController(graphicId: String) : GraphicControllerSink {
    override val graphic = Graphic()

    init {
        graphic.attributes["graphicId"] = graphicId
    }

    override var geometry: Geometry?
        get() = graphic.geometry
        set(value) {
            graphic.geometry = value
        }
    override var symbol: Symbol?
        get() = graphic.symbol
        set(value) {
            graphic.symbol = value
        }

    override var zIndex: Int
        get() = graphic.zIndex
        set(value) {
            graphic.zIndex = value
        }

    override var isVisible: Boolean
        get() = graphic.isVisible
        set(visible) {
            graphic.isVisible = visible
        }


    override var isSelected: Boolean
        get() = graphic.isSelected
        set(selected) {
            graphic.isSelected = selected
        }


    override fun interpretGraphicController(
        data: Map<*, *>,
    ) {
        val isVisible = data["isVisible"] as Boolean?
        if (isVisible != null) {
            this.isVisible = isVisible
        }
        val zIndex = data["zIndex"] as Int?
        if (zIndex != null) {
            this.zIndex = zIndex
        }
        val geometry = data["geometry"] as Map<*, *>?
        if (geometry != null) {
            this.geometry = geometry.toGeometryOrNull()
        }
        val symbol = data["symbol"] as Map<*, *>?
        if (symbol != null) {
            this.symbol = SymbolParser.parseSymbol(symbol)
        }
    }
}