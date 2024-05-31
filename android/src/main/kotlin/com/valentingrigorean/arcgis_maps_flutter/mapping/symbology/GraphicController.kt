package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.content.Context
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilterController

class GraphicController(private val context: Context, id: String) : BaseGraphicController() {

    init {
        graphic.attributes["graphicId"] = id
    }

    override var isSelected: Boolean
        get() = graphic.isSelected
        set(selected) {
            graphic.isSelected = selected
        }

    override fun interpretGraphicController(
        data: Map<*, *>,
        symbolVisibilityFilterController: SymbolVisibilityFilterController?
    ) {
        super.interpretGraphicController(data, symbolVisibilityFilterController)

        data["geometry"]?.toGeometryOrNull()?.let {
            geometry = it
        }

        data["symbol"]?.let {
            graphic.symbol = SymbolFactory.createSymbol(context, it)
        }

        data["isSelected"]?.let {
            isSelected = it as Boolean
        }
    }
}