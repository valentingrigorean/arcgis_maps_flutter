package com.valentingrigorean.arcgis_maps_flutter.layers

import com.arcgismaps.arcgisservices.TimeAware
import com.arcgismaps.mapping.layers.Layer
import com.esri.arcgisruntime.arcgisservices.TimeAware
import com.esri.arcgisruntime.layers.Layer
import com.esri.arcgisruntime.mapping.ArcGISMap
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.utils.StringUtils
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import io.flutter.plugin.common.MethodChannel

class LayersController(private val methodChannel: MethodChannel) : MapChangeAware {
    enum class LayerType {
        OPERATIONAL, BASE, REFERENCE
    }

    private val operationalLayers: MutableSet<FlutterLayer> = HashSet()
    private val baseLayers: MutableSet<FlutterLayer> = HashSet()
    private val referenceLayers: MutableSet<FlutterLayer> = HashSet()
    private val flutterOperationalLayersMap: MutableMap<String?, Layer> = HashMap()
    private val flutterBaseLayersMap: MutableMap<String?, Layer> = HashMap()
    private val flutterReferenceLayersMap: MutableMap<String?, Layer> = HashMap()
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
        if (mapData == null || mapData.size == 0) {
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
        val data: Map<*, *> = Convert.Companion.toMap(arguments)
            ?: return
        val layerId = data["layerId"] as String? ?: return
        val layer = getLayerByLayerId(layerId)
        if (layer is TimeAware) {
            val timeAware = layer as TimeAware
            timeAware.timeOffset =
                Convert.Companion.toTimeValue(data["timeValue"])
        }
    }

    private fun addLayers(args: Any, layerType: LayerType) {
        val layersArgs = args as Collection<Map<*, *>>
        if (layersArgs == null || layersArgs.size == 0) {
            return
        }
        val flutterMap: Map<String?, Layer?> = getFlutterMap(layerType)
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
        if (layersArgs == null || layersArgs.size == 0) {
            return
        }
        val flutterMap: Map<String?, Layer?> = getFlutterMap(layerType)
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
        if (ids.size == 0) return
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
        if (layers.size == 0) return
        if (map == null) {
            return
        }
        val flutterMap = getFlutterMap(layerType)
        for (layer in layers) {
            val nativeLayer = layer.createLayer()
            flutterMap[layer.layerId] = nativeLayer
            nativeLayer!!.addDoneLoadingListener {
                if (flutterMap.containsKey(layer.layerId)) {
                    val args: MutableMap<String, Any?> = HashMap(1)
                    args["layerId"] = layer.layerId
                    methodChannel.invokeMethod("layer#loaded", args)
                }
            }
            when (layerType) {
                LayerType.OPERATIONAL -> map!!.operationalLayers.add(nativeLayer)
                LayerType.BASE -> map!!.basemap.baseLayers.add(nativeLayer)
                LayerType.REFERENCE -> map!!.basemap.referenceLayers.add(nativeLayer)
            }
        }
    }

    private fun removeLayersFromMap(layers: Collection<FlutterLayer>, layerType: LayerType) {
        if (layers.size == 0) return
        val nativeLayersToRemove = ArrayList<Layer?>()
        val flutterMap = getFlutterMap(layerType)
        val flutterLayer = getFlutterLayerSet(layerType)
        for (layer in layers) {
            val nativeLayer = flutterMap[layer.layerId]
            flutterMap.remove(layer.layerId)
            flutterLayer.remove(layer)
            nativeLayersToRemove.add(nativeLayer)
        }
        if (map == null) {
            return
        }
        when (layerType) {
            LayerType.OPERATIONAL -> map!!.operationalLayers.removeAll(nativeLayersToRemove)
            LayerType.BASE -> map!!.basemap.baseLayers.removeAll(nativeLayersToRemove)
            LayerType.REFERENCE -> map!!.basemap.referenceLayers.removeAll(nativeLayersToRemove)
        }
    }

    private fun getObjectName(layerType: LayerType): String {
        return when (layerType) {
            LayerType.OPERATIONAL -> "operationalLayer"
            LayerType.BASE -> "baseLayer"
            LayerType.REFERENCE -> "referenceLayer"
            else -> throw UnsupportedOperationException()
        }
    }

    private fun getFlutterLayerSet(layerType: LayerType): MutableSet<FlutterLayer> {
        return when (layerType) {
            LayerType.OPERATIONAL -> operationalLayers
            LayerType.BASE -> baseLayers
            LayerType.REFERENCE -> referenceLayers
            else -> throw UnsupportedOperationException()
        }
    }

    private fun getFlutterMap(layerType: LayerType): MutableMap<String?, Layer?> {
        return when (layerType) {
            LayerType.OPERATIONAL -> flutterOperationalLayersMap
            LayerType.BASE -> flutterBaseLayersMap
            LayerType.REFERENCE -> flutterReferenceLayersMap
            else -> throw UnsupportedOperationException()
        }
    }

    private fun clearMap() {
        val operationalLayersNative: Collection<Layer?> = flutterOperationalLayersMap.values
        val baseLayersNative: Collection<Layer?> = flutterBaseLayersMap.values
        val referenceLayersNative: Collection<Layer?> = flutterReferenceLayersMap.values
        flutterOperationalLayersMap.clear()
        flutterBaseLayersMap.clear()
        flutterReferenceLayersMap.clear()
        if (map == null) {
            return
        }
        map!!.operationalLayers.removeAll(operationalLayersNative)
        map!!.basemap.baseLayers.removeAll(baseLayersNative)
        map!!.basemap.referenceLayers.removeAll(referenceLayersNative)
    }

    companion object {
        private fun findLayerIdByLayer(layer: Layer, data: Map<String?, Layer?>): String? {
            for ((key, value) in data) {
                if (value === layer) {
                    return key
                }
            }
            return null
        }
    }
}