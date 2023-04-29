package com.valentingrigorean.arcgis_maps_flutter.tasks.geocode

import com.esri.arcgisruntime.tasks.geocode.GeocodeParameters
import com.esri.arcgisruntime.tasks.geocode.GeocodeResult
import com.esri.arcgisruntime.tasks.geocode.LocatorAttribute
import com.esri.arcgisruntime.tasks.geocode.LocatorInfo
import com.esri.arcgisruntime.tasks.geocode.ReverseGeocodeParameters
import com.esri.arcgisruntime.tasks.geocode.SuggestParameters
import com.esri.arcgisruntime.tasks.geocode.SuggestResult
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap

object ConvertLocatorTask : Convert() {
    fun toGeocodeParameters(json: Any): GeocodeParameters? {
        val data: Map<*, *> = Convert.Companion.toMap(json)
        if (data == null || data.size == 0) {
            return null
        }
        val geocodeParameters = GeocodeParameters()
        val resultAttributeNames = data["resultAttributeNames"]
        if (resultAttributeNames != null) {
            for (attr in Convert.Companion.toList(resultAttributeNames)) {
                geocodeParameters.resultAttributeNames.add(attr.toString())
            }
        }
        val categories = data["categories"]
        if (categories != null) {
            for (attr in Convert.Companion.toList(categories)) {
                geocodeParameters.categories.add(attr.toString())
            }
        }
        val countryCode = data["countryCode"]
        if (countryCode != null) {
            geocodeParameters.countryCode = countryCode.toString()
        }
        geocodeParameters.isForStorage = Convert.Companion.toBoolean(
            data["forStorage"]!!
        )
        geocodeParameters.maxResults = Convert.Companion.toInt(
            data["maxResults"]
        )
        geocodeParameters.minScore = Convert.Companion.toDouble(
            data["minScore"]
        )
        val outputLanguageCode = data["outputLanguageCode"]
        if (outputLanguageCode != null) {
            geocodeParameters.outputLanguageCode = outputLanguageCode.toString()
        }
        geocodeParameters.outputSpatialReference = Convert.Companion.toSpatialReference(
            data["outputSpatialReference"]
        )
        val preferredSearchLocation = data["preferredSearchLocation"]
        if (preferredSearchLocation != null) {
            geocodeParameters.preferredSearchLocation =
                Convert.Companion.toPoint(preferredSearchLocation)
        }
        val searchArea = data["searchArea"]
        if (searchArea != null) {
            geocodeParameters.searchArea = Convert.Companion.toGeometry(searchArea)
        }
        return geocodeParameters
    }

    fun geocodeResultsToJson(results: List<GeocodeResult>): Any {
        val jsonResults: MutableList<Any> = ArrayList(results.size)
        for (result in results) {
            jsonResults.add(Convert.Companion.geocodeResultToJson(result))
        }
        return jsonResults
    }

    fun toReverseGeocodeParameters(json: Any): ReverseGeocodeParameters {
        val data: Map<*, *> = Convert.Companion.toMap(json)
        val reverseGeocodeParameters = ReverseGeocodeParameters()
        val resultAttributeNames = data["resultAttributeNames"]
        if (resultAttributeNames != null) {
            for (attr in Convert.Companion.toList(resultAttributeNames)) {
                reverseGeocodeParameters.resultAttributeNames.add(attr.toString())
            }
        }
        val categories = data["featureTypes"]
        if (categories != null) {
            for (attr in Convert.Companion.toList(categories)) {
                reverseGeocodeParameters.featureTypes.add(attr.toString())
            }
        }
        reverseGeocodeParameters.isForStorage = Convert.Companion.toBoolean(
            data["forStorage"]!!
        )
        reverseGeocodeParameters.maxDistance = Convert.Companion.toDouble(
            data["maxDistance"]
        )
        reverseGeocodeParameters.outputSpatialReference = Convert.Companion.toSpatialReference(
            data["outputSpatialReference"]
        )
        reverseGeocodeParameters.outputLanguageCode = data["outputLanguageCode"].toString()
        return reverseGeocodeParameters
    }

    fun toSuggestParameters(parameters: Any): SuggestParameters {
        val data: Map<*, *> = Convert.Companion.toMap(parameters)
        val suggestParameters = SuggestParameters()
        val categories = data["categories"]
        if (categories != null) {
            for (attr in Convert.Companion.toList(categories)) {
                suggestParameters.categories.add(attr.toString())
            }
        }
        suggestParameters.countryCode = data["countryCode"].toString()
        suggestParameters.countryCode = data["countryCode"].toString()
        suggestParameters.maxResults = Convert.Companion.toInt(
            data["maxResults"]
        )
        val preferredSearchLocation = data["preferredSearchLocation"]
        if (preferredSearchLocation != null) {
            suggestParameters.preferredSearchLocation =
                Convert.Companion.toPoint(preferredSearchLocation)
        }
        val searchArea = data["searchArea"]
        if (searchArea != null) {
            suggestParameters.searchArea = Convert.Companion.toGeometry(searchArea)
        }
        return suggestParameters
    }

    fun locatorInfoToJson(locatorInfo: LocatorInfo): Any {
        val data: MutableMap<String, Any> = HashMap()
        data["name"] = locatorInfo.name
        data["description"] = locatorInfo.description
        data["intersectionResultAttributes"] =
            locatorAttributesToJson(locatorInfo.intersectionResultAttributes)
        if (locatorInfo.properties != null) {
            data["properties"] = locatorInfo.properties
        }
        data["resultAttributes"] = locatorAttributesToJson(locatorInfo.resultAttributes)
        data["searchAttributes"] =
            locatorAttributesToJson(locatorInfo.searchAttributes)
        if (locatorInfo.spatialReference != null) {
            data["spatialReference"] = Convert.Companion.spatialReferenceToJson(
                locatorInfo.spatialReference
            )
        }
        data["supportsPOI"] = locatorInfo.isSupportsPoi
        data["supportsAddresses"] = locatorInfo.isSupportsAddresses
        data["supportsIntersections"] = locatorInfo.isSupportsIntersections
        data["supportsSuggestions"] = locatorInfo.isSupportsSuggestions
        data["version"] = locatorInfo.version
        return data
    }

    fun suggestResultsToJson(
        results: List<SuggestResult>,
        tagProvider: ISuggestResultTagProvider
    ): Any {
        val jsonResults: MutableList<Any> = ArrayList(results.size)
        for (result in results) {
            jsonResults.add(suggestResultToJson(result, tagProvider))
        }
        return jsonResults
    }

    private fun suggestResultToJson(
        result: SuggestResult,
        tagProvider: ISuggestResultTagProvider
    ): Any {
        val data: MutableMap<String, Any> = HashMap(3)
        data["label"] = result.label
        data["isCollection"] = result.isCollection
        data["suggestResultId"] = tagProvider.getTag(result)
        return data
    }

    private fun locatorAttributesToJson(attributes: List<LocatorAttribute>): List<Any> {
        val data = ArrayList<Any>(attributes.size)
        for (attribute in attributes) {
            data.add(locatorAttributeToJson(attribute))
        }
        return data
    }

    private fun locatorAttributeToJson(attribute: LocatorAttribute): Any {
        val data: MutableMap<String, Any> = HashMap(3)
        data["name"] = attribute.name
        data["displayName"] = attribute.displayName
        data["required"] = attribute.isRequired
        data["type"] = attribute.type.ordinal
        return data
    }

    interface ISuggestResultTagProvider {
        fun getTag(suggestResult: SuggestResult?): String
    }
}