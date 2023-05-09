package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.content.Context
import com.arcgismaps.mapping.symbology.CompositeSymbol
import com.arcgismaps.mapping.view.Graphic
import com.esri.arcgisruntime.symbology.MarkerSymbol
import com.esri.arcgisruntime.symbology.PictureMarkerSymbol
import com.esri.arcgisruntime.symbology.Symbol
import com.valentingrigorean.arcgis_maps_flutter.map.ScaleSymbol
import com.valentingrigorean.arcgis_maps_flutter.mapping.symbology.BitmapDescriptor.BitmapDescriptorListener

class MarkerController(val context: Context, markerId: String?) : BaseGraphicController(),
    MarkerControllerSink {
    private val marker = CompositeSymbol()
    protected override val graphic: Graphic = Graphic()
    private var icon: BitmapDescriptor? = null
    private var iconSymbol: ScaleSymbol? = null
    private var background: BitmapDescriptor? = null
    private var backgroundSymbol: ScaleSymbol? = null
    private var opacity = 1f
    private var angle = 0.0f
    private var iconOffsetX = 0f
    private var iconOffsetY = 0f
    private override var isSelected = false
    private var selectedScale = 1.4f

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
        if (iconSymbol != null) {
            marker.symbols.remove(iconSymbol)
        }
        icon = bitmapDescriptor
        bitmapDescriptor!!.createSymbolAsync(object : BitmapDescriptorListener {
            override fun onLoaded(symbol: Symbol) {
                iconSymbol = ScaleSymbol(symbol)
                setOpacity(iconSymbol, opacity)
                setAngle(iconSymbol, angle)
                offsetSymbol(iconSymbol, iconOffsetX, iconOffsetY)
                marker.symbols.add(iconSymbol)
                handleScaleChange()
            }

            override fun onFailed() {}
        })
    }

    override fun setBackground(bitmapDescriptor: BitmapDescriptor?) {
        if (bitmapDescriptor === background) {
            return
        }
        if (backgroundSymbol != null) {
            marker.symbols.remove(backgroundSymbol)
        }
        background = bitmapDescriptor
        bitmapDescriptor!!.createSymbolAsync(object : BitmapDescriptorListener {
            override fun onLoaded(symbol: Symbol) {
                backgroundSymbol = ScaleSymbol(symbol)
                setOpacity(backgroundSymbol, opacity)
                setAngle(backgroundSymbol, angle)
                marker.symbols.add(0, backgroundSymbol)
                handleScaleChange()
            }

            override fun onFailed() {}
        })
    }

    override fun setIconOffset(offsetX: Float, offsetY: Float) {
        if (offsetX == iconOffsetX && offsetY == iconOffsetY) {
            return
        }
        iconOffsetX = offsetX
        iconOffsetY = offsetY
        if (iconSymbol != null) {
            offsetSymbol(iconSymbol.getSymbol(), offsetX, offsetY)
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

    override fun setSelected(selected: Boolean) {
        if (selected == isSelected) return
        isSelected = selected
        handleScaleChange()
    }

    private fun handleScaleChange() {
        val scale = if (isSelected) selectedScale else 1f
        if (backgroundSymbol != null) {
            backgroundSymbol!!.setScale(scale)
        }
        if (iconSymbol != null) {
            iconSymbol!!.setScale(scale)
        }
    }

    companion object {
        private fun offsetSymbol(symbol: Symbol?, offsetX: Float, offsetY: Float) {
            if (symbol is PictureMarkerSymbol) {
                val pictureMarkerSymbol = symbol
                pictureMarkerSymbol.offsetX = offsetX
                pictureMarkerSymbol.offsetY = offsetY
            }
            if (symbol is ScaleSymbol) {
                offsetSymbol(symbol.symbol, offsetX, offsetY)
            }
        }

        private fun setOpacity(symbol: Symbol?, opacity: Float) {
            if (symbol is PictureMarkerSymbol) {
                symbol.opacity = opacity
            }
            if (symbol is ScaleSymbol) {
                setOpacity(symbol.symbol, opacity)
            }
        }

        private fun setAngle(symbol: Symbol?, angle: Float) {
            if (symbol is MarkerSymbol) {
                symbol.angle = angle
                symbol.angleAlignment = if (java.lang.Float.compare(
                        angle,
                        0f
                    ) == 0
                ) MarkerSymbol.AngleAlignment.SCREEN else MarkerSymbol.AngleAlignment.MAP
            }
            if (symbol is ScaleSymbol) {
                setAngle(symbol.symbol, angle)
            }
        }
    }
}