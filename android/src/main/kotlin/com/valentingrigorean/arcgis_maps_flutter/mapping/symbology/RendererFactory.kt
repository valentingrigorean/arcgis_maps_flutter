package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.app.Application
import android.content.Context
import com.arcgismaps.mapping.symbology.Renderer
import com.arcgismaps.mapping.symbology.UniqueValue
import com.arcgismaps.mapping.symbology.UniqueValueRenderer

object RendererFactory {

    fun createRenderer(context: Context,data: Map<*, *>): Renderer? {
        return when (data["type"] as String) {
            "unique-value" -> parseUniqueValueRenderer(context, data)
            else -> null
        }
    }


    private fun  parseUniqueValueRenderer(context: Context, data: Map<*, *>): UniqueValueRenderer {
        val fieldsNames = data["fieldsNames"] as List<String>
        val uniqueValuesRaw = data["uniqueValues"] as List<Map<*, *>>
        val uniqueValues = uniqueValuesRaw.map {
            val description = it["description"] as String
            val label = it["label"] as String
            val symbol = SymbolFactory.createSymbol(context, it["symbol"])
            val values = it["values"] as List<Any>
            UniqueValue(description, label, symbol, values)
        }
        val defaultLabel = data["defaultLabel"] as String
        val defaultSymbol = SymbolFactory.createSymbol(context, data["defaultSymbol"])

        return UniqueValueRenderer(fieldsNames, uniqueValues, defaultLabel, defaultSymbol)
    }
}