package com.valentingrigorean.arcgis_maps_flutter.layers

import android.net.Uri
import com.arcgismaps.arcgisservices.TileKey
import com.arcgismaps.geometry.Envelope
import com.arcgismaps.mapping.layers.ServiceImageTiledLayer
import com.arcgismaps.mapping.layers.TileInfo
import com.esri.arcgisruntime.data.TileKey

class FlutterServiceImageTiledLayer(
    tileInfo: TileInfo,
    fullExtent: Envelope,
    private val urlTemplate: String,
    private val subdomains: List<String?>?,
    private val additionalOptions: Map<String?, String?>?
) : ServiceImageTiledLayer(tileInfo, fullExtent) {
    override fun getTileUrl(tileKey: TileKey): String {
        val url = urlTemplate.replace("{z}", tileKey.level.toString())
            .replace("{x}", tileKey.column.toString())
            .replace("{y}", tileKey.row.toString())
        if (subdomains!!.size == 0 || !url.contains("{s}")) {
            return createUrl(url)!!
        }
        val subdomain = tileKey.level + tileKey.row + tileKey.column
        return createUrl(url.replace("{s}", subdomains[subdomain % subdomains.size]!!))!!
    }

    override fun getUri(): String {
        return null
    }

    private fun createUrl(url: String): String? {
        if (additionalOptions!!.size == 0) {
            return url
        }
        val builder = Uri.parse(url).buildUpon()
        additionalOptions.forEach { (key: String?, value: String?) ->
            builder.appendQueryParameter(
                key,
                value
            )
        }
        return builder.build().path
    }
}