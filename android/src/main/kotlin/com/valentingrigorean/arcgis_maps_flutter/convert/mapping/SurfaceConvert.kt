package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.Surface


fun Any.toSurfaceOrNull(o: Any): Surface? {
    return null
//    val data =  this as? Map<*, *> ?: return null
//    val alpha = data["alpha"] as Float
//    val isEnabled =  data["isEnabled"] as Boolean
//    var elevationSources: List<ElevationSource?>? = null
//    if (data.containsKey("elevationSources")) {
//        elevationSources = Convert.toElevationSourceList(
//            data["elevationSources"] as List<*>?
//        )
//    }
//    val surface: Surface
//    surface = if (elevationSources != null) {
//        Surface(elevationSources)
//    } else {
//        Surface()
//    }
//    surface.isEnabled = isEnabled
//    surface.opacity = alpha
//    if (data.containsKey("elevationExaggeration")) {
//        surface.elevationExaggeration = toFloat(
//            data["elevationExaggeration"]
//        )
//    }
//    return surface
}