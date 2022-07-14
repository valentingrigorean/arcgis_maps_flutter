package com.valentingrigorean.arcgis_maps_flutter.layer_content

import com.esri.arcgisruntime.layers.ArcGISMapImageLayer
import com.esri.arcgisruntime.layers.ArcGISMapImageSublayer
import com.valentingrigorean.arcgis_maps_flutter.layers.LayersController
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

object LayerContentHelper {
    private val secondaryLayers: MutableMap<String, List<SecondaryLayer>> = mutableMapOf()

    fun requireLayers(
        call: MethodCall,
        result: MethodChannel.Result,
        layersController: LayersController
    ) {
        val layerId = call.argument<String?>("layerId")
        if (layerId == null) {
            result.success(emptyList<Map<String, Any>>())
        } else {
            val layer = layersController.getLayerByLayerId(layerId)
            if (layer is ArcGISMapImageLayer) {
                if (secondaryLayers.containsKey(layerId)) {
                    sendLayersBack(result, secondaryLayers[layerId].orEmpty())
                } else {
                    loadSecondaryLayer(result, layerId, layer)
                }
            } else {
                result.success(emptyList<Map<String, Any>>())
            }
        }
    }

    private fun loadSecondaryLayer(
        result: MethodChannel.Result,
        layerId: String,
        layer: ArcGISMapImageLayer
    ) {
        val layerContents: MutableList<SecondaryLayer> = mutableListOf()
        layer.subLayerContents.forEach { firstLayer ->
            firstLayer.subLayerContents.forEach { secondaryLayer ->
                if (secondaryLayer is ArcGISMapImageSublayer) {
                    layerContents.add(
                        SecondaryLayer(
                            id = UUID.randomUUID().toString(),
                            layerContent = secondaryLayer
                        )
                    )
                }
            }
        }
        secondaryLayers[layerId] = layerContents
        sendLayersBack(result, layerContents)
    }

    private fun sendLayersBack(
        result: MethodChannel.Result,
        layers: List<SecondaryLayer>,
    ) {
        val tmp: MutableList<Map<String, Any>> = mutableListOf()
        layers.forEach { item ->
            tmp.add(
                mapOf<String, Any>(
                    "id" to item.id,
                    "name" to item.layerContent.name,
                    "visible" to item.layerContent.isVisible
                )
            )
        }
        result.success(tmp)
    }

    fun updateLayerVisibility(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        val layerId = call.argument<String?>("layerId")
        val id = call.argument<String?>("id")
        val foundLayer = secondaryLayers[layerId]
        if (foundLayer == null) {
            result.success(false)
        } else {
            val visible = call.argument<Boolean?>("visible")
            if (visible != null) {
                foundLayer.firstOrNull {
                    it.id == id
                }?.let {
                    it.layerContent.isVisible = visible
                }
            }

            result.success(true)
        }

    }
}
