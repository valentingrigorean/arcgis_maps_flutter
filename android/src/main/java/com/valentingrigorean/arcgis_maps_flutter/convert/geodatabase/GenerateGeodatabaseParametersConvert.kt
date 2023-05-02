package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.tasks.geodatabase.GenerateGeodatabaseParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull

fun GenerateGeodatabaseParameters.toFlutterJson(): Any {
    val data: MutableMap<String, Any> = HashMap(8)
    data["attachmentSyncDirection"] = attachmentSyncDirection.toFlutterValue()
    if (extent != null) {
        data["extent"] = extent!!.toFlutterJson()!!
    }
    data["layerOptions"] = layerOptions.map { it.toFlutterJson() }
    if (outSpatialReference != null) {
        data["outSpatialReference"] = outSpatialReference!!.toFlutterJson()
    }
    data["returnAttachments"] = returnAttachments
    data["shouldSyncContingentValues"] = syncContingentValues
    data["syncModel"] = syncModel.toFlutterValue()
    data["utilityNetworkSyncMode"] = utilityNetworkSyncMode.toFlutterValue()
    return data
}

fun Any.toGenerateGeodatabaseParametersOrNull(): GenerateGeodatabaseParameters? {
    val data = this as Map<*, *>? ?: return null
    val layerOptions =
        (data["layerOptions"] as List<Any>).map { it.toGenerateLayerOptionOrNull()!! }
    val parameters = GenerateGeodatabaseParameters()
    parameters.attachmentSyncDirection =
        (data["attachmentSyncDirection"] as Int).toAttachmentSyncDirection()
    parameters.extent = data["extent"]?.toGeometryOrNull()
    for (layerOption in layerOptions) {
        parameters.layerOptions.add(layerOption)
    }
    parameters.outSpatialReference = data["outSpatialReference"]?.toSpatialReferenceOrNull()
    parameters.returnAttachments = data["returnAttachments"] as Boolean
    parameters.syncContingentValues = data["shouldSyncContingentValues"] as Boolean
    parameters.syncModel = (data["syncModel"] as Int).toSyncModel()
    parameters.utilityNetworkSyncMode =
        (data["utilityNetworkSyncMode"] as Int).toUtilityNetworkSyncMode()
    return parameters
}
