package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.content.Context
import com.arcgismaps.mapping.symbology.CompositeSymbol
import com.arcgismaps.mapping.symbology.PictureMarkerSymbol
import com.arcgismaps.mapping.symbology.SimpleFillSymbol
import com.arcgismaps.mapping.symbology.SimpleLineSymbol
import com.arcgismaps.mapping.symbology.SimpleMarkerSymbol
import com.arcgismaps.mapping.symbology.Symbol
import com.arcgismaps.mapping.symbology.TextSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.interpretPictureMarkerSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.interpretSimpleFillSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.interpretSimpleLineSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.interpretSimpleMarkerSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.interpretTextSymbol
import com.valentingrigorean.arcgis_maps_flutter.convert.toBitmapDrawable
import com.valentingrigorean.arcgis_maps_flutter.utils.createDrawableBitmap

object SymbolFactory {
    fun createSymbol(context: Context, data: Any?): Symbol? {
        if (data !is Map<*, *>) {
            return null
        }
        return when (data["type"] as String) {
            "simple-line" -> SimpleLineSymbol().apply {
                interpretSimpleLineSymbol(data)
            }

            "simple-fill" -> SimpleFillSymbol().apply {
                interpretSimpleFillSymbol(data)
            }

            "simple-marker" -> SimpleMarkerSymbol().apply {
                interpretSimpleMarkerSymbol(data)
            }

            "picture-marker" -> createPictureMarkerSymbol(context, data)
            "text" -> TextSymbol().apply {
                interpretTextSymbol(data)
            }

            "composite" -> CompositeSymbol().apply {
                data["symbols"]?.let {
                    val symbolsRaw = it as List<*>
                    for (symbolRaw in symbolsRaw) {
                        val symbol = createSymbol(context, symbolRaw)
                        if (symbol != null) {
                            symbols.add(symbol)
                        }
                    }
                }
            }

            else -> null
        }
    }


    private fun createPictureMarkerSymbol(context: Context, data: Map<*, *>): PictureMarkerSymbol {
        val symbol: PictureMarkerSymbol = if (data.containsKey("url")) {
            PictureMarkerSymbol(data["url"] as String)
        } else if (data.containsKey("resource")) {
            val resourceName = data["resource"] as String
            val tintColor = data["tintColor"] as Int?
            val bitmap = context.createDrawableBitmap(resourceName, tintColor)
            bitmap?.let { PictureMarkerSymbol.createWithImage(it) } ?: PictureMarkerSymbol()
        } else if (data.containsKey("fromBytes")) {
            val bytes = data["fromBytes"] as ByteArray
            PictureMarkerSymbol.createWithImage(bytes.toBitmapDrawable(context))
        } else {
            PictureMarkerSymbol()
        }
        symbol.interpretPictureMarkerSymbol(data)
        return symbol
    }
}