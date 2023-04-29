package com.valentingrigorean.arcgis_maps_flutter.layers

import com.esri.arcgisruntime.layers.Layer
import com.esri.arcgisruntime.mapping.ArcGISMap
import com.esri.arcgisruntime.util.ListChangedEvent
import com.esri.arcgisruntime.util.ListChangedListener
import io.flutter.plugin.common.MethodChannel

class LayersChangedController(channel: MethodChannel) : MapChangeAware,
    ArcGISMap.BasemapChangedListener {
    private val operationalLayersChanged: LayerChangeListener
    private val baseLayersChanged: LayerChangeListener
    private val referenceLayerChanged: LayerChangeListener
    private var map: ArcGISMap? = null
    private var isObserving = false
    private var trackLayersChange = false

    init {
        operationalLayersChanged =
            LayerChangeListener(channel, LayersController.LayerType.OPERATIONAL)
        baseLayersChanged = LayerChangeListener(channel, LayersController.LayerType.BASE)
        referenceLayerChanged = LayerChangeListener(channel, LayersController.LayerType.REFERENCE)
    }

    fun setTrackLayersChange(`val`: Boolean) {
        if (trackLayersChange == `val`) {
            return
        }
        trackLayersChange = `val`
        if (trackLayersChange) {
            addObservers()
        } else {
            removeObservers()
        }
    }

    override fun onMapChange(map: ArcGISMap?) {
        removeObservers()
        this.map = map
        if (trackLayersChange) {
            addObservers()
        }
    }

    override fun basemapChanged(basemapChangedEvent: ArcGISMap.BasemapChangedEvent) {
        if (basemapChangedEvent.oldBasemap != null) {
            val basemap = basemapChangedEvent.oldBasemap
            if (basemap != null) {
                basemap.baseLayers.removeListChangedListener(baseLayersChanged)
                basemap.referenceLayers.removeListChangedListener(referenceLayerChanged)
            }
        }
        if (isObserving) {
            val basemap = map!!.basemap
            if (basemap != null) {
                basemap.baseLayers.addListChangedListener(baseLayersChanged)
                basemap.referenceLayers.addListChangedListener(referenceLayerChanged)
            }
        }
    }

    private fun addObservers() {
        if (map == null) {
            return
        }
        if (isObserving) {
            removeObservers()
        }
        map!!.operationalLayers.addListChangedListener(operationalLayersChanged)
        val basemap = map!!.basemap
        if (basemap != null) {
            basemap.baseLayers.addListChangedListener(baseLayersChanged)
            basemap.referenceLayers.addListChangedListener(referenceLayerChanged)
        }
        isObserving = true
    }

    private fun removeObservers() {
        if (map == null) {
            return
        }
        if (isObserving) {
            map!!.operationalLayers.removeListChangedListener(operationalLayersChanged)
            val basemap = map!!.basemap
            if (basemap != null) {
                basemap.baseLayers.removeListChangedListener(baseLayersChanged)
                basemap.referenceLayers.removeListChangedListener(referenceLayerChanged)
            }
            isObserving = false
        }
    }

    private inner class LayerChangeListener(
        private val channel: MethodChannel,
        private val layerType: LayersController.LayerType
    ) : ListChangedListener<Layer?> {
        override fun listChanged(listChangedEvent: ListChangedEvent<Layer?>) {
            val data = HashMap<String, Any>(3)
            data["layerType"] = layerType.ordinal
            data["layerChangeType"] =
                if (listChangedEvent.action == ListChangedEvent.Action.ADDED) 0 else 1
            channel.invokeMethod("map#onLayersChanged", data)
        }
    }
}