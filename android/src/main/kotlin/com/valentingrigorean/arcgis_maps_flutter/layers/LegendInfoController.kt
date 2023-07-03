package com.valentingrigorean.arcgis_maps_flutter.layers

import android.content.Context
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValueAsync
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope

class LegendInfoController(
    private val context: Context,
    private val layersController: LayersController
) {
    suspend fun load(data: Map<*, *>): Result<Any?> = coroutineScope {
        val flutterLayer = FlutterLayer(data)
        val layer =
            layersController.getLayerByLayerId(flutterLayer.layerId) ?: flutterLayer.createLayer()
        layer.fetchLegendInfos().onSuccess { legendInfos ->
            try {
                val results = legendInfos.map { legendInfo ->
                    async {
                        val symbolImage = legendInfo.symbol?.createSwatch(context.resources.displayMetrics.density)
                        val pngBytes = symbolImage?.getOrNull()?.toFlutterValueAsync()
                        mapOf(
                            "name" to legendInfo.name,
                            "symbolImage" to pngBytes
                        )
                    }
                }.awaitAll()

                return@coroutineScope Result.success(mapOf(
                    "layerId" to layer.id,
                    "layerName" to layer.name,
                    "results" to results
                ))
            } catch (e: Exception) {
                return@coroutineScope Result.failure(e)
            }
        }.onFailure {
            return@coroutineScope Result.failure(it)
        }
        Result.success(null)
    }

}