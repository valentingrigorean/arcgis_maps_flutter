package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.tasks.geodatabase.GenerateGeodatabaseParameters
import com.arcgismaps.tasks.geodatabase.SyncModel
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toSpatialReferenceOrNull

fun GenerateGeodatabaseParameters.toFlutterJson(): Any {

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
    parameters.syncModel = SyncModel.values()[Convert.Companion.toInt(syncModel)]
    parameters.utilityNetworkSyncMode =
        UtilityNetworkSyncMode.values()[Convert.Companion.toInt(utilityNetworkSyncMode)]
    return parameters
}