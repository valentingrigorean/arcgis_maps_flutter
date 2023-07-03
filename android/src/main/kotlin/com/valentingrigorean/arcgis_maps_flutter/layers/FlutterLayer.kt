package com.valentingrigorean.arcgis_maps_flutter.layers

import android.util.Log
import com.arcgismaps.data.Geodatabase
import com.arcgismaps.data.ServiceFeatureTable
import com.arcgismaps.mapping.PortalItem
import com.arcgismaps.mapping.layers.ArcGISMapImageLayer
import com.arcgismaps.mapping.layers.ArcGISTiledLayer
import com.arcgismaps.mapping.layers.ArcGISVectorTiledLayer
import com.arcgismaps.mapping.layers.FeatureLayer
import com.arcgismaps.mapping.layers.GroupLayer
import com.arcgismaps.mapping.layers.GroupVisibilityMode
import com.arcgismaps.mapping.layers.Layer
import com.arcgismaps.mapping.layers.TileCache
import com.arcgismaps.mapping.layers.WmsLayer
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.layers.toGroupVisibilityMode
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toPortalItemOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterLong
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeObjectStorage
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.Objects

private class GroupLayerOptions(data: Map<*, *>) {
    val layers: List<FlutterLayer>
    val visibilityMode: GroupVisibilityMode
    val showChildrenInLegend: Boolean

    init {
        showChildrenInLegend = data["showChildrenInLegend"] as Boolean
        visibilityMode = (data["visibilityMode"] as Int).toGroupVisibilityMode()
        layers = (data["layers"] as List<*>).map { FlutterLayer(it as Map<*, *>) }
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as GroupLayerOptions

        if (layers != other.layers) return false
        if (visibilityMode != other.visibilityMode) return false
        if (showChildrenInLegend != other.showChildrenInLegend) return false

        return true
    }

    override fun hashCode(): Int {
        var result = layers.hashCode()
        result = 31 * result + visibilityMode.hashCode()
        result = 31 * result + showChildrenInLegend.hashCode()
        return result
    }
}

class FlutterLayer(private val data: Map<*, *>) {
    val layerId: String = data["layerId"] as String
    private val layerType: String? = data["layerType"] as String?
    private var url: String? = null
    private val isVisible: Boolean
    private val opacity: Float
    private var groupLayerOptions: GroupLayerOptions? = null
    private var portalItem: PortalItem? = null
    private var tileCache: TileCache? = null
    private var portalItemLayerId: Long = -1

    init {
        if (data.containsKey("url")) {
            url = data["url"] as String?
            portalItem = null
            tileCache = null
        } else if (data.containsKey("portalItem")) {
            url = null
            portalItem = data["portalItem"]?.toPortalItemOrNull()
            tileCache = null
        } else if (data.containsKey("tileCache")) {
            url = null
            portalItem = null
            tileCache = NativeObjectStorage.getNativeObjectOrConvert(
                data["tileCache"]!!
            ) { obj ->
                val tileCacheData = obj as Map<*, *>
                val url = tileCacheData["url"] as String
                TileCache(url)
            }
        } else {
            url = null
            portalItem = null
            tileCache = null
        }
        isVisible = data["isVisible"] as Boolean
        opacity = (data["opacity"] as Double).toFloat()
        when (layerType) {
            "GroupLayer" -> {
                groupLayerOptions = GroupLayerOptions(data)
            }

            "FeatureLayer" -> {
                portalItemLayerId = when (val item = data["portalItemLayerId"]) {
                    is Long -> item
                    is Int -> item.toLong()
                    else -> -1
                }
            }
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    fun createLayer(): Layer {
        val layer: Layer
        when (layerType) {
            "GeodatabaseLayer" -> {
                val groupLayer = GroupLayer()
                val geodatabase = Geodatabase(url!!)
                GlobalScope.launch {
                    geodatabase.load().onSuccess {
                        val featureLayersIds = (data["featureLayersIds"] as List<Any>?)?.map { id -> id.toFlutterLong()
                        }?.filter { id -> id != -1L } ?: emptyList()
                        for (table in geodatabase.featureTables) {
                            if (featureLayersIds.isEmpty()) {
                                groupLayer.layers.add(FeatureLayer.createWithFeatureTable(table))
                            } else {
                                for (featureLayerId in featureLayersIds) {
                                    if (table.serviceLayerId == featureLayerId) {
                                        groupLayer.layers.add(
                                            FeatureLayer.createWithFeatureTable(
                                                table
                                            )
                                        )
                                    }
                                }
                            }
                        }
                    }.onFailure {
                        Log.w("GeodatabaseLayer", "createLayer: ", it)
                    }
                }
                layer = groupLayer
            }

            "VectorTileLayer" -> {
                val vectorTiledLayer = ArcGISVectorTiledLayer(url!!)
                layer = vectorTiledLayer
            }

            "FeatureLayer" -> {
                layer = if (url != null) {
                    val serviceFeatureTable = ServiceFeatureTable(url!!)
                    FeatureLayer.createWithFeatureTable(serviceFeatureTable)
                } else {
                    FeatureLayer.createWithItemAndLayerId(portalItem!!, portalItemLayerId)
                }
            }

            "TiledLayer" -> {
                val tiledLayer =
                    if (tileCache != null) ArcGISTiledLayer(tileCache!!) else ArcGISTiledLayer(url!!)
                layer = tiledLayer
            }

            "WmsLayer" -> {
                val layersNames = data["layersName"] as Collection<String>
                val wmsLayer = WmsLayer(url!!, layersNames)
                layer = wmsLayer
            }

            "MapImageLayer" -> {
                val mapImageLayer = ArcGISMapImageLayer(url!!)
                layer = mapImageLayer
            }

            "GroupLayer" -> {
                val groupLayer = GroupLayer(groupLayerOptions!!.layers.map { it.createLayer() })
                groupLayer.visibilityMode = groupLayerOptions!!.visibilityMode
                groupLayer.showChildrenInLegend = groupLayerOptions!!.showChildrenInLegend
                layer = groupLayer
            }

            else -> throw UnsupportedOperationException("not implemented.")
        }
        layer.id = layerId
        layer.opacity = opacity
        layer.isVisible = isVisible
        return layer
    }


    override fun hashCode(): Int {
        return Objects.hash(layerId)
    }

    override fun equals(other: Any?): Boolean {
        if (other is FlutterLayer) {
            return layerId == other.layerId
        }
        return false
    }
}