package com.valentingrigorean.arcgis_maps_flutter.layers

import com.arcgismaps.arcgisservices.TimeAware
import com.arcgismaps.mapping.ArcGISMap
import com.arcgismaps.mapping.layers.Layer
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toTimeValueOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.map.MapChangeAware
import com.valentingrigorean.arcgis_maps_flutter.utils.StringUtils
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

class LayersController(
    private val methodChannel: MethodChannel,
    private val scope: CoroutineScope,
) : MapChangeAware {
    enum class LayerType {
        OPERATIONAL, BASE, REFERENCE
    }

    private val operationalLayers: MutableSet<FlutterLayer> = LinkedHashSet()
    private val baseLayers: MutableSet<FlutterLayer> = LinkedHashSet()
    private val referenceLayers: MutableSet<FlutterLayer> = LinkedHashSet()
    private val flutterOperationalLayersMap: MutableMap<String, Layer> = HashMap()
    private val flutterBaseLayersMap: MutableMap<String, Layer> = HashMap()
    private val flutterReferenceLayersMap: MutableMap<String, Layer> = HashMap()
    private var map: ArcGISMap? = null
    override fun onMapChange(map: ArcGISMap?) {
        clearMap()
        this.map = map
        addLayersToMap(operationalLayers, LayerType.OPERATIONAL)
        addLayersToMap(baseLayers, LayerType.BASE)
        addLayersToMap(referenceLayers, LayerType.REFERENCE)
    }

    fun getLayerByLayerId(id: String?): Layer? {
        if (flutterOperationalLayersMap.containsKey(id)) {
            return flutterOperationalLayersMap[id]
        }
        if (flutterBaseLayersMap.containsKey(id)) {
            return flutterBaseLayersMap[id]
        }
        return if (flutterReferenceLayersMap.containsKey(id)) {
            flutterReferenceLayersMap[id]
        } else null
    }

    fun getLayerIdByLayer(layer: Layer): String? {
        var layerId = findLayerIdByLayer(layer, flutterOperationalLayersMap)
        if (layerId != null) {
            return layerId
        }
        layerId = findLayerIdByLayer(layer, flutterBaseLayersMap)
        if (layerId != null) {
            return layerId
        }
        layerId = findLayerIdByLayer(layer, flutterReferenceLayersMap)
        return layerId
    }

    fun updateFromArgs(args: Any?) {
        val mapData = args as Map<*, *>?
        if (mapData == null || mapData.isEmpty()) {
            return
        }
        for (layerType in LayerType.values()) {
            val objectName = getObjectName(layerType)
            val layersToAdd = mapData[objectName + "sToAdd"]
            layersToAdd?.let { addLayers(it, layerType) }
            val layersToUpdate = mapData[objectName + "sToChange"]
            if (layersToUpdate != null) {
                removeLayers(layersToUpdate, layerType)
                addLayers(layersToUpdate, layerType)
            }
            val layersToRemove = mapData[objectName + "IdsToRemove"]
            if (layersToRemove != null) {
                removeLayersById(layersToRemove as Collection<String>, layerType)
            }
        }
    }

    fun setTimeOffset(arguments: Any) {
        val data = arguments as Map<*, *>? ?: return
        val layerId = data["layerId"] as String? ?: return
        val layer = getLayerByLayerId(layerId)
        if (layer is TimeAware) {
            val timeAware = layer as TimeAware
            timeAware.timeOffset = data["timeValue"]?.toTimeValueOrNull()
        }
    }

    private fun addLayers(args: Any, layerType: LayerType) {
        val layersArgs = args as Collection<Map<*, *>>
        if (layersArgs == null || layersArgs.isEmpty()) {
            return
        }
        val flutterMap = getFlutterMap(layerType)
        val flutterLayers = getFlutterLayerSet(layerType)
        val layersToAdd = ArrayList<FlutterLayer>()
        for (layer in layersArgs) {
            val layerId = layer["layerId"] as String?
            if (flutterMap.containsKey(layerId)) {
                continue
            }
            val flutterLayer = FlutterLayer(layer)
            layersToAdd.add(flutterLayer)
            flutterLayers.add(flutterLayer)
        }
        addLayersToMap(layersToAdd, layerType)
    }

    private fun removeLayers(args: Any, layerType: LayerType) {
        val layersArgs = args as Collection<Map<*, *>>
        if (layersArgs == null || layersArgs.isEmpty()) {
            return
        }
        val flutterMap = getFlutterMap(layerType)
        val layersToRemove = ArrayList<FlutterLayer>()
        for (layer in layersArgs) {
            val layerId = layer["layerId"] as String?
            if (layerId == null || !flutterMap.containsKey(layerId)) {
                continue
            }
            val flutterLayer = FlutterLayer(layer)
            layersToRemove.add(flutterLayer)
        }
        removeLayersFromMap(layersToRemove, layerType)
    }

    private fun removeLayersById(ids: Collection<String>, layerType: LayerType) {
        if (ids.isEmpty()) return
        val layersToRemove = ArrayList<FlutterLayer>()
        val layers: Set<FlutterLayer> = getFlutterLayerSet(layerType)
        for (id in ids) {
            val flutterLayer =
                layers.stream().filter { e: FlutterLayer -> StringUtils.areEqual(e.layerId, id) }
                    .findFirst()
            if (flutterLayer.isPresent) {
                layersToRemove.add(flutterLayer.get())
            }
        }
        removeLayersFromMap(layersToRemove, layerType)
    }

    private fun addLayersToMap(layers: Collection<FlutterLayer>, layerType: LayerType) {
        if (layers.isEmpty()) return
        val map = this.map ?: return
        val flutterMap = getFlutterMap(layerType)
        for (layer in layers) {
            val nativeLayer = flutterMap[layer.layerId] ?: layer.createLayer()
            flutterMap[layer.layerId] = nativeLayer
            scope.launch {
                nativeLayer.load()
                    .onSuccess {
                        if (flutterMap.containsKey(layer.layerId)) {
                            val args: MutableMap<String, Any?> = HashMap(1)
                            args["layerId"] = layer.layerId
                            methodChannel.invokeMethod("layer#loaded", args)
                        }
                    }
                    .onFailure {
                        if (flutterMap.containsKey(layer.layerId)) {
                            val args: MutableMap<String, Any?> = HashMap(2)
                            args["layerId"] = layer.layerId
                            args["error"] = it.toFlutterJson(withStackTrace = false, addFlutterFlag = false)
                            methodChannel.invokeMethod("layer#loaded", args)
                        }
                }
            }
            when (layerType) {
                LayerType.OPERATIONAL -> map.operationalLayers.add(nativeLayer)
                LayerType.BASE -> map.basemap.value?.baseLayers?.add(nativeLayer)
                LayerType.REFERENCE -> map.basemap.value?.referenceLayers?.add(nativeLayer)
            }
        }
    }

    private fun removeLayersFromMap(layers: Collection<FlutterLayer>, layerType: LayerType) {
        if (layers.isEmpty()) return

        val nativeLayersToRemove = HashSet<Layer>()
        val flutterMap = getFlutterMap(layerType)
        val flutterLayer = getFlutterLayerSet(layerType)
        for (layer in layers) {
            val nativeLayer = flutterMap[layer.layerId]!!
            flutterMap.remove(layer.layerId)
            flutterLayer.remove(layer)
            nativeLayersToRemove.add(nativeLayer)
        }
        val map = this.map ?: return
        when (layerType) {
            LayerType.OPERATIONAL -> map.operationalLayers.removeAll(nativeLayersToRemove)
            LayerType.BASE -> map.basemap.value?.baseLayers?.removeAll(nativeLayersToRemove)
            LayerType.REFERENCE -> map.basemap.value?.referenceLayers?.removeAll(nativeLayersToRemove)
        }
    }

    private fun clearMap() {
        val operationalLayersNative = flutterOperationalLayersMap.values
        val baseLayersNative = flutterBaseLayersMap.values
        val referenceLayersNative = flutterReferenceLayersMap.values
        val map = this.map ?: return
        map.operationalLayers.removeAll(operationalLayersNative)
        map.basemap.value?.baseLayers?.removeAll(baseLayersNative)
        map.basemap.value?.referenceLayers?.removeAll(referenceLayersNative)
    }


    private fun getObjectName(layerType: LayerType): String {
        return when (layerType) {
            LayerType.OPERATIONAL -> "operationalLayer"
            LayerType.BASE -> "baseLayer"
            LayerType.REFERENCE -> "referenceLayer"
        }
    }

    private fun getFlutterLayerSet(layerType: LayerType): MutableSet<FlutterLayer> {
        return when (layerType) {
            LayerType.OPERATIONAL -> operationalLayers
            LayerType.BASE -> baseLayers
            LayerType.REFERENCE -> referenceLayers
        }
    }

    private fun getFlutterMap(layerType: LayerType): MutableMap<String, Layer> {
        return when (layerType) {
            LayerType.OPERATIONAL -> flutterOperationalLayersMap
            LayerType.BASE -> flutterBaseLayersMap
            LayerType.REFERENCE -> flutterReferenceLayersMap
        }
    }


    companion object {
        private fun findLayerIdByLayer(layer: Layer, data: Map<String, Layer>): String? {
            for ((key, value) in data) {
                if (value === layer) {
                    return key
                }
            }
            return null
        }
    }
}