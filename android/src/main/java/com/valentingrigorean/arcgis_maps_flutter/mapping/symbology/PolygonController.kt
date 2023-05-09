package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.graphics.Color
import com.arcgismaps.mapping.symbology.SimpleFillSymbol
import com.arcgismaps.mapping.symbology.SimpleFillSymbolStyle
import com.arcgismaps.mapping.symbology.SimpleLineSymbol
import com.arcgismaps.mapping.symbology.SimpleLineSymbolStyle
import com.arcgismaps.mapping.view.Graphic
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColor


class PolygonController(polygonId: String?) : BaseGraphicController(), PolygonControllerSink {
    protected override val graphic: Graphic
    private val polygonSymbol: SimpleFillSymbol
    private val polygonStrokeSymbol: SimpleLineSymbol =
        SimpleLineSymbol(SimpleLineSymbolStyle.Solid, Color.BLACK.toArcgisColor(), 10f)

    init {
        polygonSymbol =
            SimpleFillSymbol(SimpleFillSymbolStyle.Solid, Color.BLACK.toArcgisColor(), polygonStrokeSymbol)
        graphic = Graphic()
        graphic.symbol = polygonSymbol
        graphic.attributes["polygonId"] = polygonId
    }

    override fun setFillColor(color: Int) {
        polygonSymbol.color = com.arcgismaps.Color(color)
    }

    override fun setStrokeColor(color: Int) {
        polygonStrokeSymbol.color = com.arcgismaps.Color(color)
    }

    override fun setStrokeWidth(width: Float) {
        polygonStrokeSymbol.width = width
    }

    override fun setStrokeStyle(style: SimpleLineSymbolStyle) {
        polygonStrokeSymbol.style = style
    }
}