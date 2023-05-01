package com.valentingrigorean.arcgis_maps_flutter.map

import android.graphics.Color
import com.esri.arcgisruntime.mapping.view.Graphic
import com.esri.arcgisruntime.symbology.SimpleFillSymbol
import com.esri.arcgisruntime.symbology.SimpleLineSymbol

class PolygonController(polygonId: String?) : BaseGraphicController(), PolygonControllerSink {
    protected override val graphic: Graphic
    private val polygonSymbol: SimpleFillSymbol
    private val polygonStrokeSymbol: SimpleLineSymbol

    init {
        polygonStrokeSymbol = SimpleLineSymbol(SimpleLineSymbol.Style.SOLID, Color.BLACK, 10f)
        polygonSymbol =
            SimpleFillSymbol(SimpleFillSymbol.Style.SOLID, Color.BLACK, polygonStrokeSymbol)
        graphic = Graphic()
        graphic.symbol = polygonSymbol
        graphic.attributes["polygonId"] = polygonId
    }

    override fun setFillColor(color: Int) {
        polygonSymbol.color = color
    }

    override fun setStrokeColor(color: Int) {
        polygonStrokeSymbol.color = color
    }

    override fun setStrokeWidth(width: Float) {
        polygonStrokeSymbol.width = width
    }

    override fun setStrokeStyle(style: SimpleLineSymbol.Style?) {
        polygonStrokeSymbol.style = style
    }
}