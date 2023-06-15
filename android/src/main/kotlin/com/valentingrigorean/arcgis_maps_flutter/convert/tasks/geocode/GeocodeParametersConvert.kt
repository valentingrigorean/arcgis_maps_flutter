package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geocode

import com.arcgismaps.tasks.geocode.GeocodeParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toPointOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull

fun Any.toGeocodeParametersOrNull(): GeocodeParameters? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    if (data.isEmpty()) {
        return null
    }
    val geocodeParameters = GeocodeParameters()
    val resultAttributeNames = data["resultAttributeNames"] as List<String>?
    if (resultAttributeNames != null) {
        for (attr in resultAttributeNames) {
            geocodeParameters.resultAttributeNames.add(attr)
        }
    }
    val categories = data["categories"] as List<String>?
    if (categories != null) {
        for (attr in categories) {
            geocodeParameters.categories.add(attr)
        }
    }
    val countryCode = data["countryCode"] as String?
    if (countryCode != null) {
        geocodeParameters.countryCode = countryCode
    }
    geocodeParameters.forStorage = data["forStorage"] as Boolean
    geocodeParameters.maxResults = data["maxResults"] as Int
    geocodeParameters.minScore = data["minScore"] as Double
    val outputLanguageCode = data["outputLanguageCode"] as String?
    if (outputLanguageCode != null) {
        geocodeParameters.outputLanguageCode = outputLanguageCode
    }
    val outputSpatialReference = data["outputSpatialReference"] as Map<*, *>
    geocodeParameters.outputSpatialReference = outputSpatialReference.toSpatialReferenceOrNull()
    val preferredSearchLocation = data["preferredSearchLocation"]
    if (preferredSearchLocation != null) {
        geocodeParameters.preferredSearchLocation = preferredSearchLocation.toPointOrNull()
    }
    val searchArea = data["searchArea"]
    if (searchArea != null) {
        geocodeParameters.searchArea = searchArea.toGeometryOrNull()
    }
    return geocodeParameters
}
