package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.Basemap
import com.valentingrigorean.arcgis_maps_flutter.layers.FlutterLayer

fun Any.toBasemapOrNull(): Basemap? {
    val data = this as Map<*, *>? ?: return null
    val basemapStyle = (data["basemapStyle"] as Int?)?.toBasemapStyle()
    if (basemapStyle != null) {
        return Basemap(basemapStyle)
    }
    val portalItem = data["portalItem"]?.toPortalItemOrNull()
    if (portalItem != null) {
        return Basemap(portalItem)
    }
    val baseLayer = data["baseLayer"] as Map<*, *>?
    if (baseLayer != null) {
        val flutterLayer = FlutterLayer(baseLayer)
        val nativeLayer = flutterLayer.createLayer()
        return Basemap(nativeLayer)
    }
    val baseLayers = data["baseLayers"] as List<Map<*, *>>?
    val referenceLayers = data["referenceLayers"] as List<Map<*, *>>?
    if (baseLayers != null && referenceLayers != null) {
        val nativeBaseLayers = baseLayers.map { FlutterLayer(it).createLayer() }
        val nativeReferenceLayers = referenceLayers.map { FlutterLayer(it).createLayer() }
        return Basemap(nativeBaseLayers, nativeReferenceLayers)
    }
    val uri = data["uri"] as String?
    if (uri != null) {
        return Basemap(uri)
    }
    return null
}