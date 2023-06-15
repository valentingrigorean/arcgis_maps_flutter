package com.valentingrigorean.arcgis_maps_flutter.convert.arcgisservices

import com.arcgismaps.arcgisservices.TimeAware
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.toFlutterJson

fun TimeAware.toFlutterJson(layerId: String?): Any {
    val data = HashMap<String, Any>(6)

    if (layerId != null)
        data["layerId"] = layerId

    if (fullTimeExtent.value != null)
        data["fullTimeExtent"] = fullTimeExtent.value!!.toFlutterJson()

    data["supportsTimeFiltering"] = supportsTimeFiltering
    data["isTimeFilteringEnabled"] = isTimeFilteringEnabled
    if (timeOffset != null)
        data["timeOffset"] = timeOffset!!.toFlutterJson()
    if(timeInterval != null)
        data["timeInterval"] = timeInterval!!.toFlutterJson()
    return data
}