package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.exportvectortiles

import com.arcgismaps.tasks.exportvectortiles.EsriVectorTilesDownloadOption

fun EsriVectorTilesDownloadOption.toFlutterValue(): Int {
    return when (this) {
        EsriVectorTilesDownloadOption.UseOriginalService -> 0
        EsriVectorTilesDownloadOption.UseReducedFontsService -> 1
    }
}

fun Int.toEsriVectorTilesDownloadOption(): EsriVectorTilesDownloadOption {
    return when (this) {
        0 -> EsriVectorTilesDownloadOption.UseOriginalService
        1 -> EsriVectorTilesDownloadOption.UseReducedFontsService
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}