package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.graphics.Color
import com.arcgismaps.mapping.symbology.SimpleLineSymbol
import com.arcgismaps.mapping.symbology.SimpleLineSymbolStyle
import com.arcgismaps.mapping.view.Graphic


class PolylineController(polylineId: String?) : BaseGraphicController(), PolylineControllerSink {
    protected override val graphic: Graphic = Graphic()
    private val polylineSymbol: SimpleLineSymbol =
        SimpleLineSymbol(SimpleLineSymbolStyle.Solid, com.arcgismaps.Color(Color.BLACK), 10f)

    init {
        graphic.symbol = polylineSymbol
        graphic.attributes["polylineId"] = polylineId
    }

    override fun setColor(color: Int) {
        polylineSymbol.color = com.arcgismaps.Color(color)
    }

    override fun setWidth(width: Float) {
        polylineSymbol.width = width
    }

    override fun setStyle(style: SimpleLineSymbolStyle) {
        polylineSymbol.style = style
    }

    override fun setAntialias(antialias: Boolean) {
        polylineSymbol.antiAlias = antialias
    }
}