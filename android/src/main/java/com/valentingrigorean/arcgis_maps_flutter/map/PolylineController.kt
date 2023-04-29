package com.valentingrigorean.arcgis_maps_flutter.map

import android.graphics.Color
import com.esri.arcgisruntime.mapping.view.Graphic
import com.esri.arcgisruntime.symbology.SimpleLineSymbol

class PolylineController(polylineId: String?) : BaseGraphicController(), PolylineControllerSink {
    protected override val graphic: Graphic
    private val polylineSymbol: SimpleLineSymbol

    init {
        polylineSymbol = SimpleLineSymbol(SimpleLineSymbol.Style.SOLID, Color.BLACK, 10f)
        graphic = Graphic()
        graphic.symbol = polylineSymbol
        graphic.attributes["polylineId"] = polylineId
    }

    override fun setColor(color: Int) {
        polylineSymbol.color = color
    }

    override fun setWidth(width: Float) {
        polylineSymbol.width = width
    }

    override fun setStyle(style: SimpleLineSymbol.Style?) {
        polylineSymbol.style = style
    }

    override fun setAntialias(antialias: Boolean) {
        polylineSymbol.isAntiAlias = antialias
    }
}