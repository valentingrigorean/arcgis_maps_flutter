package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.graphics.drawable.BitmapDrawable
import com.arcgismaps.mapping.symbology.CompositeSymbol
import com.arcgismaps.mapping.symbology.PictureFillSymbol
import com.arcgismaps.mapping.symbology.PictureMarkerSymbol
import com.arcgismaps.mapping.symbology.Symbol


class ScaleSymbolController(val symbol: Symbol) {
    private val scaleHandles = ArrayList<SymbolScaleHandle>()

    init {
        populateDefaultSize(symbol)
    }

    var scale = 1f
        set(value) {
            if (value == field) {
                return
            }
            field = value
            for (scaleHandle in scaleHandles) {
                scaleHandle.setScale(scale)
            }
        }

    private fun populateDefaultSize(symbol: Symbol) {
        if (symbol is CompositeSymbol) {
            if (symbol != null) {
                for (child in symbol.symbols) {
                    populateDefaultSize(child)
                }
            }
        } else {
            scaleHandles.add(SymbolScaleHandle(symbol))
        }
    }

    private inner class SymbolScaleHandle(private val symbol: Symbol) {
        private var width = 0f
        private var height = 0f
        private var haveSize = false
        private var scale = 1f
        private var originalImage: BitmapDrawable? = null

        init {
            when (symbol) {
                is PictureMarkerSymbol -> {
                    val pictureMarkerSymbol = symbol
                    haveSize = true
                    originalImage = pictureMarkerSymbol.image
                    width = pictureMarkerSymbol.width
                    height = pictureMarkerSymbol.height
                }

                is PictureFillSymbol -> {
                    val pictureFillSymbol = symbol
                    haveSize = true
                    originalImage = pictureFillSymbol.image
                    width = pictureFillSymbol.width
                    height = pictureFillSymbol.height
                }

                else -> {
                    haveSize = false
                    width = 0f
                    height = 0f
                }
            }
        }

        fun setScale(scale: Float) {
            if (!haveSize) {
                return
            }
            if (this.scale == scale) {
                return
            }
            this.scale = scale
            val newWidth = width * scale
            val newHeight = height * scale
            if (symbol is PictureMarkerSymbol) {
                val pictureMarkerSymbol = symbol
                pictureMarkerSymbol.width = newWidth
                pictureMarkerSymbol.height = newHeight
            } else if (symbol is PictureFillSymbol) {
                val pictureFillSymbol = symbol
                pictureFillSymbol.width = newWidth
                pictureFillSymbol.height = newHeight
            }
        }
    }
}