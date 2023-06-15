package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode

import com.arcgismaps.tasks.geocode.SuggestParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull

fun Any.toSuggestParametersOrNull(): SuggestParameters? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val suggestParameters = SuggestParameters()
    val categories = data["categories"] as List<String>?
    if (categories != null) {
        for (attr in categories) {
            suggestParameters.categories.add(attr)
        }
    }
    suggestParameters.countryCode = data["countryCode"].toString()
    suggestParameters.countryCode = data["countryCode"].toString()
    suggestParameters.maxResults = data["maxResults"] as Int
    suggestParameters.preferredSearchLocation = data["preferredSearchLocation"]?.toPointOrNull()
    suggestParameters.searchArea = data["searchArea"]?.toGeometryOrNull()
    return suggestParameters
}