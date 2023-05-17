package com.valentingrigorean.arcgis_maps_flutter.layers
import com.arcgismaps.mapping.ArcGISMap
import io.flutter.plugin.common.MethodChannel

class LayersChangedController(channel: MethodChannel) : MapChangeAware{

    private var map: ArcGISMap? = null
    private var isObserving = false
    private var trackLayersChange = false

    init {

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

    private fun addObservers() {
        if (map == null) {
            return
        }
        if (isObserving) {
            removeObservers()
        }

        isObserving = true
    }

    private fun removeObservers() {
        if (map == null) {
            return
        }
        if (isObserving) {
            isObserving = false
        }
    }
}