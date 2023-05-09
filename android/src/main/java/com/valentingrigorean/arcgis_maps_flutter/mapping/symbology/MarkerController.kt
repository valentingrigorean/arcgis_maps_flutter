package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.content.Context
import com.arcgismaps.mapping.symbology.CompositeSymbol
import com.arcgismaps.mapping.symbology.MarkerSymbol
import com.arcgismaps.mapping.symbology.PictureMarkerSymbol
import com.arcgismaps.mapping.symbology.Symbol
import com.arcgismaps.mapping.symbology.SymbolAngleAlignment

class MarkerController(val context: Context, markerId: String) : BaseGraphicController(),
    MarkerControllerSink {
    private val marker = CompositeSymbol()
    private var icon: BitmapDescriptor? = null
    private var iconScaleSymbolController: ScaleSymbolController? = null
    private var background: BitmapDescriptor? = null
    private var backgroundScaleSymbolController: ScaleSymbolController? = null
    private var opacity = 1f
    private var angle = 0.0f
    private var iconOffsetX = 0f
    private var iconOffsetY = 0f

    private var selectedScale = 1.4f

    override var isSelected: Boolean
        get() = this.isSelected
        set(value) {
            this.isSelected = value
            handleScaleChange()
        }

    init {
        graphic.symbol = marker
        graphic.attributes["markerId"] = markerId
    }

    override fun setSelectedScale(selectedScale: Float) {
        this.selectedScale = selectedScale
        handleScaleChange()
    }

    override fun setIcon(bitmapDescriptor: BitmapDescriptor?) {
        if (bitmapDescriptor === icon) {
            return
        }
        if (iconScaleSymbolController != null) {
            marker.symbols.remove(iconScaleSymbolController!!.symbol)
        }
        icon = bitmapDescriptor
        iconScaleSymbolController = bitmapDescriptor?.let {
            ScaleSymbolController(createSymbol(it))
        }
        handleScaleChange()
    }

    override fun setBackground(bitmapDescriptor: BitmapDescriptor?) {
        if (bitmapDescriptor === background) {
            return
        }
        if (backgroundScaleSymbolController != null) {
            marker.symbols.remove(backgroundScaleSymbolController!!.symbol)
        }
        background = bitmapDescriptor
        backgroundScaleSymbolController = bitmapDescriptor?.let {
            ScaleSymbolController(createSymbol(it))
        }

        handleScaleChange()
    }

    override fun setIconOffset(offsetX: Float, offsetY: Float) {
        if (offsetX == iconOffsetX && offsetY == iconOffsetY) {
            return
        }
        iconOffsetX = offsetX
        iconOffsetY = offsetY
        if (iconScaleSymbolController != null) {
            offsetSymbol(iconScaleSymbolController!!.symbol, offsetX, offsetY)
        }
    }

    override fun setOpacity(opacity: Float) {
        if (this.opacity == opacity) {
            return
        }
        this.opacity = opacity
        for (symbol in marker.symbols) {
            setOpacity(symbol, opacity)
        }
    }

    override fun setAngle(angle: Float) {
        if (this.angle == angle) {
            return
        }
        this.angle = angle
        for (symbol in marker.symbols) {
            setAngle(symbol, angle)
        }
    }


    private fun createSymbol(bitmapDescriptor: BitmapDescriptor): Symbol {
        val symbol = bitmapDescriptor.createSymbol()
        setOpacity(symbol, opacity)
        setAngle(symbol, angle)
        marker.symbols.add(symbol)
        return symbol
    }

    private fun handleScaleChange() {
        val scale = if (isSelected) selectedScale else 1f
        if (backgroundScaleSymbolController != null) {
            backgroundScaleSymbolController!!.scale = scale
        }
        if (iconScaleSymbolController != null) {
            iconScaleSymbolController!!.scale = scale
        }
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