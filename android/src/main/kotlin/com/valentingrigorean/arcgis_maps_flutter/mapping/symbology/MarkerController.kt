package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.content.Context
import com.arcgismaps.mapping.symbology.CompositeSymbol
import com.arcgismaps.mapping.symbology.MarkerSymbol
import com.arcgismaps.mapping.symbology.PictureMarkerSymbol
import com.arcgismaps.mapping.symbology.Symbol
import com.arcgismaps.mapping.symbology.SymbolAngleAlignment
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.map.SymbolVisibilityFilterController

class MarkerController(val context: Context, markerId: String) : BaseGraphicController(),
    MarkerControllerSink {
    private val marker = CompositeSymbol()
    private var iconScaleSymbolController: ScaleSymbolController? = null
    private var backgroundScaleSymbolController: ScaleSymbolController? = null

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
            handleScaleChange()
        }

    override var selectedScale: Float = 1f
        set(value) {
            field = value
            handleScaleChange()
        }
    override var icon: BitmapDescriptor? = null
        get() = field
        set(value) {
            if (field == value) {
                return
            }
            field = value
            if (iconScaleSymbolController != null) {
                marker.symbols.remove(iconScaleSymbolController!!.symbol)
            }
            iconScaleSymbolController = value?.let {
                ScaleSymbolController(createSymbol(it))
            }
            handleScaleChange()
        }
    override var background: BitmapDescriptor? = null
        set(value) {
            if (field == value) {
                return
            }
            field = value
            if (backgroundScaleSymbolController != null) {
                marker.symbols.remove(backgroundScaleSymbolController!!.symbol)
            }
            backgroundScaleSymbolController = value?.let {
                ScaleSymbolController(createSymbol(it))
            }
            handleScaleChange()
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
        get() = field
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
        this.geometry  = data["position"]?.toGeometryOrNull()
        val icon = data["icon"]
        if (icon != null) {
            this.icon = BitmapDescriptorFactory.fromRawData(context, icon)
        }
        val backgroundImage = data["backgroundImage"]
        if (backgroundImage != null) {
            this.background = BitmapDescriptorFactory.fromRawData(context, backgroundImage)

        }
        setIconOffset((data["iconOffsetX"] as Double).toFloat(), (data["iconOffsetY"] as Double).toFloat())
        val opacity = data["opacity"] as Double?
        if (opacity != null) {
            this.opacity = opacity.toFloat()
        }
        val angle = data["angle"] as Double?
        if (angle != null) {
            this.angle = angle.toFloat()
        }
        val selectedScale = data["selectedScale"] as Double?
        if (selectedScale != null) {
            this.selectedScale = selectedScale.toFloat()
        }
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