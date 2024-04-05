package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.content.Context
import com.arcgismaps.mapping.symbology.CompositeSymbol
import com.arcgismaps.mapping.symbology.MarkerSymbol
import com.arcgismaps.mapping.symbology.PictureMarkerSymbol
import com.arcgismaps.mapping.symbology.Symbol
import com.arcgismaps.mapping.symbology.SymbolAngleAlignment
import com.arcgismaps.mapping.symbology.TextSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.interpretTextSymbol
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilterController

class MarkerController(val context: Context, markerId: String) : BaseGraphicController(),
    MarkerControllerSink {
    private val marker = CompositeSymbol()
    private var iconSymbol: Symbol? = null
    private var backgroundSymbol: Symbol? = null
    private var textSymbol: TextSymbol? = null

    private var iconOffsetX = 0f
    private var iconOffsetY = 0f


    init {
        graphic.symbol = marker
        graphic.attributes["markerId"] = markerId
    }

    override var isSelected: Boolean = false
        set(value) {
            if (field == value) {
                return
            }
            field = value
        }

    override var background: BitmapDescriptor? = null
        set(value) {
            if (field == value) {
                return
            }
            field = value
            if (backgroundSymbol != null) {
                marker.symbols.remove(backgroundSymbol)
            }
            backgroundSymbol = value?.let {
                createSymbol(it,0)
            }
        }

    override var icon: BitmapDescriptor? = null
        set(value) {
            if (field == value) {
                return
            }
            field = value
            if (iconSymbol != null) {
                marker.symbols.remove(iconSymbol)
            }
            iconSymbol = value?.let {
                createSymbol(it,1)
            }
        }


    override var opacity: Float = 1f
        set(value) {
            if (field == value) {
                return
            }
            field = value
            for (symbol in marker.symbols) {
                setOpacity(symbol, value)
            }
        }

    override var angle: Float = 0f
        set(value) {
            if (field == value) {
                return
            }
            field = value
            for (symbol in marker.symbols) {
                setAngle(symbol, value)
            }
        }


    override fun interpretGraphicController(
        data: Map<*, *>,
        symbolVisibilityFilterController: SymbolVisibilityFilterController?
    ) {
        super.interpretGraphicController(data, symbolVisibilityFilterController)
        this.geometry = data["position"]?.toGeometryOrNull()
        val backgroundImage = data["backgroundImage"]
        if (backgroundImage != null) {
            this.background = BitmapDescriptorFactory.fromRawData(context, backgroundImage)
        }
        val icon = data["icon"]
        if (icon != null) {
            this.icon = BitmapDescriptorFactory.fromRawData(context, icon)
        }
        setIconOffset(
            (data["iconOffsetX"] as Double).toFloat(),
            (data["iconOffsetY"] as Double).toFloat()
        )
        val opacity = data["opacity"] as Double?
        if (opacity != null) {
            this.opacity = opacity.toFloat()
        }
        val angle = data["angle"] as Double?
        if (angle != null) {
            this.angle = angle.toFloat()
        }

        val textSymbolData = data["textSymbol"] as Map<*, *>?
        if (textSymbolData != null) {
            if (textSymbol == null) {
                textSymbol = TextSymbol()
                marker.symbols.add(textSymbol!!)
            }
            textSymbol?.interpretTextSymbol(textSymbolData)
        }else {
            if (textSymbol != null) {
                marker.symbols.remove(textSymbol!!)
                textSymbol = null
            }
        }
    }


    override fun setIconOffset(offsetX: Float, offsetY: Float) {
        if (offsetX == iconOffsetX && offsetY == iconOffsetY) {
            return
        }
        iconOffsetX = offsetX
        iconOffsetY = offsetY
        if (iconSymbol != null) {
            offsetSymbol(iconSymbol, offsetX, offsetY)
        }
    }

    private fun createSymbol(bitmapDescriptor: BitmapDescriptor,index:Int): Symbol {
        val symbol = bitmapDescriptor.createSymbol()
        setOpacity(symbol, opacity)
        setAngle(symbol, angle)
        if(index in 0 until marker.symbols.size) {
            marker.symbols.add(index, symbol)
        } else {
            marker.symbols.add(symbol)
        }
        return symbol
    }


    private fun offsetSymbol(symbol: Symbol?, offsetX: Float, offsetY: Float) {
        if (symbol is PictureMarkerSymbol) {
            symbol.offsetX = offsetX
            symbol.offsetY = offsetY
        }
    }

    private fun setOpacity(symbol: Symbol, opacity: Float) {
        if (symbol is PictureMarkerSymbol) {
            symbol.opacity = opacity
        }
    }

    private fun setAngle(symbol: Symbol, angle: Float) {
        if (symbol is MarkerSymbol) {
            symbol.angle = angle
            symbol.angleAlignment = if (angle.compareTo(0f) == 0
            ) SymbolAngleAlignment.Screen else SymbolAngleAlignment.Map
        }
    }
}