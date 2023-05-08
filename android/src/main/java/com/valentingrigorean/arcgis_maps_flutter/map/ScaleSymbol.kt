package com.valentingrigorean.arcgis_maps_flutter.map

import com.arcgismaps.mapping.symbology.Symbol


class ScaleSymbol(val symbol: Symbol) : Symbol(
    symbol.internal
) {
    private val scaleHandles = ArrayList<SymbolScaleHandle>()

    init {
        populateDefaultSize(symbol)
    }

    fun setScale(scale: Float) {
        for (scaleHandle in scaleHandles) {
            scaleHandle.setScale(scale)
        }
    }

    @Throws(Throwable::class)
    protected fun finalize() {
        super.finalize()
        scaleHandles.clear()
    }

    private fun populateDefaultSize(symbol: Symbol) {
        if (symbol is CompositeSymbol) {
            val compositeSymbol = symbol
            if (compositeSymbol != null) {
                for (child in compositeSymbol.symbols) {
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

        init {
            if (symbol is PictureMarkerSymbol) {
                val pictureMarkerSymbol = symbol
                haveSize = true
                width = pictureMarkerSymbol.width
                height = pictureMarkerSymbol.height
            } else if (symbol is PictureFillSymbol) {
                val pictureFillSymbol = symbol
                haveSize = true
                width = pictureFillSymbol.width
                height = pictureFillSymbol.height
            } else {
                haveSize = false
                width = 0f
                height = 0f
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