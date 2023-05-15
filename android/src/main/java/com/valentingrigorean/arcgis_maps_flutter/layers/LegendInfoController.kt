package com.valentingrigorean.arcgis_maps_flutter.layers

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.util.Log
import com.esri.arcgisruntime.layers.FeatureLayer
import com.esri.arcgisruntime.layers.Layer
import com.esri.arcgisruntime.layers.LayerContent
import com.esri.arcgisruntime.layers.LegendInfo
import com.esri.arcgisruntime.loadable.LoadStatus
import com.valentingrigorean.arcgis_maps_flutter.ConvertUti
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import java.io.ByteArrayOutputStream

class LegendInfoController(
    private val context: Context,
    private val layersController: LayersController
) {
    private val TAG = "LegendInfoController"
    private val layersLegends: MutableMap<LayerContent?, List<LegendInfo>> = HashMap()
    private val legendResultsFlutter: MutableList<Any> = ArrayList()
    private var didSetResult = false
    private var legendInfoControllerResult: LegendInfoControllerResult? = null
    private val pendingLayersRequests = ArrayList<LayerContent?>()

    interface LegendInfoControllerResult {
        fun onResult(results: List<Any>?)
    }

    fun loadAsync(args: Any, legendInfoControllerResult: LegendInfoControllerResult) {
        if (didSetResult) {
            legendInfoControllerResult.onResult(legendResultsFlutter)
            return
        }
        this.legendInfoControllerResult = legendInfoControllerResult
        val data: Map<*, *> = ConvertUti.Companion.toMap(args)
        if (data == null || data.isEmpty()) {
            setResult()
            return
        }
        val flutterLayer = FlutterLayer(data)
        var loadedLayer = layersController.getLayerByLayerId(flutterLayer.layerId)
        if (loadedLayer == null) {
            Log.d(TAG, "loadAsync: " + flutterLayer.layerId + " not found. Creating a new layer.")
            loadedLayer = flutterLayer.createLayer()
        } else {
            Log.d(TAG, "loadAsync: " + flutterLayer.layerId + " found in map layers.")
        }
        val layer = loadedLayer
        val onDone = Runnable {
            Log.d(TAG, "loadAsync: " + layer!!.name + " status -> " + layer.loadStatus)
            if (layer.loadStatus != LoadStatus.LOADED) {
                setResult()
            } else if (!layer.canShowInLegend() && layer.subLayerContents.isEmpty()) {
                setResult()
            } else {
                loadSublayersOrLegendInfos(layer)
            }
        }
        if (loadedLayer is FeatureLayer) {
            val featureLayer = loadedLayer
            featureLayer.featureTable.addDoneLoadingListener {
                featureLayer.addDoneLoadingListener(onDone)
                featureLayer.loadAsync()
            }
        } else {
            layer!!.addDoneLoadingListener(onDone)
        }
        loadedLayer.loadAsync()
    }

    private fun loadIndividualLayer(layerContent: LayerContent) {
        if (layerContent is Layer) {
            val layer = layerContent
            val onDone = Runnable {
                Log.d(TAG, "loadIndividualLayer: " + layer.name + " status -> " + layer.loadStatus)
                loadSublayersOrLegendInfos(layer)
            }
            if (layer is FeatureLayer) {
                val featureLayer = layer
                featureLayer.featureTable.addDoneLoadingListener {
                    featureLayer.addDoneLoadingListener(onDone)
                    featureLayer.loadAsync()
                }
            } else {
                layer.addDoneLoadingListener(onDone)
            }
            layer.loadAsync()
        } else {
            loadSublayersOrLegendInfos(layerContent)
        }
    }

    private fun loadSublayersOrLegendInfos(layerContent: LayerContent?) {
        if (!layerContent!!.subLayerContents.isEmpty()) {
            pendingLayersRequests.add(layerContent)
            Log.d(
                TAG,
                "loadSublayersOrLegendInfos: " + layerContent.name + " loading sublayers -> " + layerContent.subLayerContents.size + " pendingRequest " + pendingLayersRequests.size
            )
            for (layer in layerContent.subLayerContents) {
                loadIndividualLayer(layer)
            }
            pendingLayersRequests.remove(layerContent)
        } else {
            val future = layerContent.fetchLegendInfosAsync()
            pendingLayersRequests.add(layerContent)
            Log.d(
                TAG,
                "loadSublayersOrLegendInfos: Loading legend for " + layerContent.name + " pendingRequest " + pendingLayersRequests.size
            )
            future.addDoneListener {
                pendingLayersRequests.remove(layerContent)
                Log.d(
                    TAG,
                    "loadSublayersOrLegendInfos: Finish loading legend for " + layerContent.name + " pendingRequest " + pendingLayersRequests.size
                )
                try {
                    val items = future.get()
                    layersLegends[layerContent] = items
                    if (pendingLayersRequests.size == 0) {
                        setResult()
                    }
                } catch (e: Exception) {
                    layersLegends[layerContent] = ArrayList(0)
                    e.printStackTrace()
                }
            }
        }
    }

    private fun addLegendInfoResultFlutterAndValidate(
        layerContent: LayerContent?,
        results: List<*>
    ) {
        val item: MutableMap<String, Any> = HashMap(2)
        item["layerName"] = layerContent!!.name
        item["results"] = results
        legendResultsFlutter.add(item)
        if (legendResultsFlutter.size == layersLegends.size) {
            Log.d(TAG, "onResult: " + legendResultsFlutter.size)
            legendInfoControllerResult!!.onResult(legendResultsFlutter)
        }
    }

    private fun createLegendFlutter(layerContent: LayerContent?, legendInfos: List<LegendInfo>) {
        val results = ArrayList<Map<*, *>>(legendInfos.size)
        if (legendInfos.isEmpty()) {
            addLegendInfoResultFlutterAndValidate(layerContent, results)
            return
        }
        for (legendInfo in legendInfos) {
            val item: MutableMap<String, Any> = HashMap(2)
            item["name"] = legendInfo.name
            if (legendInfo.symbol == null) {
                results.add(item)
                if (validateLayerResults(legendInfos, results)) {
                    addLegendInfoResultFlutterAndValidate(layerContent, results)
                }
            } else {
                run {
                    val future = legendInfo.symbol.createSwatchAsync(
                        context, Color.TRANSPARENT
                    )
                    future.addDoneListener {
                        try {
                            val bitmap = future.get()
                            val stream = ByteArrayOutputStream()
                            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                            item["symbolImage"] = stream.toByteArray()
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                        results.add(item)
                        if (validateLayerResults(legendInfos, results)) {
                            addLegendInfoResultFlutterAndValidate(layerContent, results)
                        }
                    }
                }
            }
        }
    }

    private fun setResult() {
        if (didSetResult) return
        didSetResult = true
        if (layersLegends.isEmpty()) {
            val items = ArrayList<Any>(0)
            legendInfoControllerResult!!.onResult(items)
            return
        }
        layersLegends.forEach { (k: LayerContent?, v: List<LegendInfo>) ->
            createLegendFlutter(
                k,
                v
            )
        }
    }

    companion object {
        private fun validateLayerResults(src: List<*>, dst: List<*>): Boolean {
            return src.size == dst.size
        }
    }
}