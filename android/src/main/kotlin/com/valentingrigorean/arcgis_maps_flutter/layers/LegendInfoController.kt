package com.valentingrigorean.arcgis_maps_flutter.layers

import android.content.Context


class LegendInfoController(
    private val context: Context,
    private val layersController: LayersController
) {

    suspend fun load(data: Map<*,*>) : Result<List<Any>?>{
        layersController.getLayerByLayerId("0")!!.load()
        return Result.success(null)
    }

    private fun validateLayerResults(src: List<*>, dst: List<*>): Boolean {
        return src.size == dst.size
    }
}