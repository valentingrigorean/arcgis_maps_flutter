package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode

import com.arcgismaps.tasks.geocode.ReverseGeocodeParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull

fun Any.toReverseGeocodeParametersOrNull(): ReverseGeocodeParameters? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val reverseGeocodeParameters = ReverseGeocodeParameters()
    val resultAttributeNames = data["resultAttributeNames"] as List<String>?
    if (resultAttributeNames != null) {
        for (attr in resultAttributeNames) {
            reverseGeocodeParameters.resultAttributeNames.add(attr)
        }
    }
    val categories = data["featureTypes"] as List<String>?
    if (categories != null) {
        for (attr in categories) {
            reverseGeocodeParameters.featureTypes.add(attr)
        }
    }
    reverseGeocodeParameters.forStorage = data["forStorage"] as Boolean
    reverseGeocodeParameters.maxDistance = data["maxDistance"] as Double
    reverseGeocodeParameters.outputSpatialReference =
        data["outputSpatialReference"]?.toSpatialReferenceOrNull()
    reverseGeocodeParameters.outputLanguageCode = data["outputLanguageCode"] as String
    return reverseGeocodeParameters
}
