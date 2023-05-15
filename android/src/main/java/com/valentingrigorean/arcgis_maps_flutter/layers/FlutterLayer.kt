package com.valentingrigorean.arcgis_maps_flutter.layers

import android.util.Log
import com.arcgismaps.io.RemoteResource
import com.arcgismaps.mapping.PortalItem
import com.arcgismaps.mapping.layers.GroupLayer
import com.arcgismaps.mapping.layers.Layer
import com.arcgismaps.mapping.layers.TileCache
import com.arcgismaps.mapping.layers.WmsLayer
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeObjectStorage
import java.util.Objects
import java.util.function.Function
import java.util.stream.Collectors

class FlutterLayer(private val data: Map<*, *>) {
    val layerId: String = data["layerId"] as String
    private val layerType: String? = data["layerType"] as String?
    private var url: String? = null
    private val isVisible: Boolean
    private val opacity: Float
    private var serviceImageTiledLayerOptions: ServiceImageTiledLayerOptions? = null
    private var groupLayerOptions: GroupLayerOptions? = null
    private var portalItem: PortalItem? = null
    private var tileCache: TileCache? = null
    private var portalItemLayerId: Long = 0

    init {
        if (data.containsKey("url")) {
            url = data["url"] as String?
            portalItem = null
            tileCache = null
        } else if (data.containsKey("portalItem")) {
            url = null
            portalItem = ConvertUti.Companion.toPortalItem(
                data["portalItem"]
            )
            tileCache = null
        } else if (data.containsKey("tileCache")) {
            url = null
            portalItem = null
            tileCache = NativeObjectStorage.Companion.getNativeObjectOrConvert<TileCache>(
                data["tileCache"],
                Function<Any?, TileCache> { o: Any -> ConvertUti.Companion.toTileCache(o) })
        } else {
            url = null
            portalItem = null
            tileCache = null
        }
        isVisible = ConvertUti.Companion.toBoolean(data["isVisible"]!!)
        opacity = ConvertUti.Companion.toFloat(data["opacity"])
        when (layerType) {
            "ServiceImageTiledLayer" -> {
                serviceImageTiledLayerOptions = ConvertUti.Companion.toServiceImageTiledLayerOptions(
                    data
                )
                groupLayerOptions = null
                portalItemLayerId = -1
            }

            "GroupLayer" -> {
                groupLayerOptions = GroupLayerOptions(data)
                serviceImageTiledLayerOptions = null
                portalItemLayerId = -1
            }

            "FeatureLayer" -> {
                portalItemLayerId = if (data.containsKey("portalItemLayerId")) {
                    ConvertUti.Companion.toLong(
                        data["portalItemLayerId"]
                    )
                } else {
                    -1
                }
                serviceImageTiledLayerOptions = null
                groupLayerOptions = null
            }

            else -> {
                serviceImageTiledLayerOptions = null
                groupLayerOptions = null
                portalItemLayerId = -1
            }
        }
    }

    fun createLayer(): Layer {
        val layer: Layer
        var remoteResource: RemoteResource? = null
        when (layerType) {
            "GeodatabaseLayer" -> {
                val groupLayer = GroupLayer()
                val geodatabase = Geodatabase(url)
                geodatabase.loadAsync()
                geodatabase.addDoneLoadingListener {
                    if (geodatabase.loadStatus == LoadStatus.LOADED) {
                        val featureLayersIdsRaw = data["featureLayersIds"]
                        val featureLayersIds: IntArray = ConvertUti.Companion.toIntArray(
                            featureLayersIdsRaw ?: ArrayList<Int>()
                        )
                        for (table in geodatabase.geodatabaseFeatureTables) {
                            if (featureLayersIds.size == 0) {
                                groupLayer.layers.add(FeatureLayer(table))
                            } else {
                                for (featureLayerId in featureLayersIds) {
                                    if (table.serviceLayerId == featureLayerId.toLong()) {
                                        groupLayer.layers.add(FeatureLayer(table))
                                    }
                                }
                            }
                        }
                    } else if (geodatabase.loadStatus == LoadStatus.FAILED_TO_LOAD) {
                        Log.w("GeodatabaseLayer", "createLayer: " + geodatabase.loadError.message)
                        if (geodatabase.loadError.cause != null) {
                            Log.w(
                                "GeodatabaseLayer",
                                "createLayer: " + geodatabase.loadError.cause!!.message
                            )
                        }
                    }
                }
                layer = groupLayer
            }

            "VectorTileLayer" -> {
                val vectorTiledLayer = ArcGISVectorTiledLayer(url)
                layer = vectorTiledLayer
                remoteResource = vectorTiledLayer
            }

            "FeatureLayer" -> {
                if (url != null) {
                    val serviceFeatureTable = ServiceFeatureTable(url)
                    remoteResource = serviceFeatureTable
                    layer = FeatureLayer(serviceFeatureTable)
                } else {
                    layer = FeatureLayer(portalItem, portalItemLayerId)
                }
            }

            "TiledLayer" -> {
                val tiledLayer =
                    if (tileCache != null) ArcGISTiledLayer(tileCache) else ArcGISTiledLayer(url)
                remoteResource = tiledLayer
                layer = tiledLayer
            }

            "WmsLayer" -> {
                val layersNames = data["layersName"] as Collection<String>?
                val wmsLayer = WmsLayer(url, layersNames)
                remoteResource = wmsLayer
                layer = wmsLayer
            }

            "MapImageLayer" -> {
                val mapImageLayer = ArcGISMapImageLayer(url)
                remoteResource = mapImageLayer
                layer = mapImageLayer
            }

            "ServiceImageTiledLayer" -> {
                layer = FlutterServiceImageTiledLayer(
                    serviceImageTiledLayerOptions!!.tileInfo,
                    serviceImageTiledLayerOptions!!.fullExtent,
                    serviceImageTiledLayerOptions!!.urlTemplate,
                    serviceImageTiledLayerOptions!!.subdomains,
                    serviceImageTiledLayerOptions!!.additionalOptions
                )
            }

            "GroupLayer" -> {
                val groupLayer = GroupLayer(
                    groupLayerOptions!!.layers.stream().map { e: FlutterLayer -> e.createLayer() }
                        .collect(Collectors.toList()))
                groupLayer.visibilityMode = groupLayerOptions!!.visibilityMode
                groupLayer.isShowChildrenInLegend = groupLayerOptions!!.showChildrenInLegend
                layer = groupLayer
            }

            else -> throw UnsupportedOperationException("not implemented.")
        }
        if (credential != null && remoteResource != null) {
            remoteResource.credential = credential
        }
        layer.opacity = opacity
        layer.isVisible = isVisible
        return layer
    }

    override fun equals(o: Any?): Boolean {
        if (this === o) return true
        if (o == null || javaClass != o.javaClass) return false
        val that = o as FlutterLayer
        return isVisible == that.isVisible && java.lang.Float.compare(
            that.opacity,
            opacity
        ) == 0 && portalItemLayerId == that.portalItemLayerId && layerId == that.layerId && layerType == that.layerType && url == that.url && credential == that.credential && serviceImageTiledLayerOptions == that.serviceImageTiledLayerOptions && groupLayerOptions == that.groupLayerOptions && portalItem == that.portalItem
    }

    override fun hashCode(): Int {
        return Objects.hash(layerId)
    }

    class ServiceImageTiledLayerOptions(
        val tileInfo: TileInfo, val fullExtent: Envelope, val urlTemplate: String,
        val subdomains: List<String?>?, val additionalOptions: Map<String?, String?>?
    ) {
        override fun equals(o: Any?): Boolean {
            if (this === o) return true
            if (o == null || javaClass != o.javaClass) return false
            val that = o as ServiceImageTiledLayerOptions
            return tileInfo == that.tileInfo && fullExtent == that.fullExtent && urlTemplate == that.urlTemplate && subdomains == that.subdomains && additionalOptions == that.additionalOptions
        }

        override fun hashCode(): Int {
            return Objects.hash(tileInfo, fullExtent, urlTemplate, subdomains, additionalOptions)
        }
    }

    class GroupLayerOptions(data: Map<*, *>) {
        val layers: List<FlutterLayer>
        val visibilityMode: GroupVisibilityMode
        val showChildrenInLegend: Boolean

        init {
            showChildrenInLegend = ConvertUti.Companion.toBoolean(
                data["showChildrenInLegend"]!!
            )
            visibilityMode = GroupVisibilityMode.values()[ConvertUti.Companion.toInt(
                data["visibilityMode"]
            )]
            layers =
                ConvertUti.Companion.toList(data["layers"]!!).stream().map<FlutterLayer> { e: Any ->
                    FlutterLayer(
                        ConvertUti.Companion.toMap(e)
                    )
                }
                    .collect<List<FlutterLayer>, Any>(Collectors.toList<FlutterLayer>())
        }

        override fun equals(o: Any?): Boolean {
            if (this === o) return true
            if (o == null || javaClass != o.javaClass) return false
            val that = o as GroupLayerOptions
            return showChildrenInLegend == that.showChildrenInLegend && layers == that.layers && visibilityMode == that.visibilityMode
        }

        override fun hashCode(): Int {
            return Objects.hash(layers, visibilityMode, showChildrenInLegend)
        }
    }
}