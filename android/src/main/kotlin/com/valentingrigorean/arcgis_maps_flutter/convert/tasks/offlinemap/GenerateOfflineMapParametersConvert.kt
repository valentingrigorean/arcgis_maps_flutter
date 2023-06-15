package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.GenerateOfflineMapParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.exportvectortiles.toEsriVectorTilesDownloadOption
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.exportvectortiles.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geodatabase.toAttachmentSyncDirection
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geodatabase.toFlutterValue

fun GenerateOfflineMapParameters.toFlutterJson(): Any {
    val data = HashMap<String, Any?>(16)
    areaOfInterest?.let {
        data["areaOfInterest"] = it.toFlutterJson()
    }
    data["minScale"] = minScale
    data["maxScale"] = maxScale
    data["onlineOnlyServicesOption"] = onlineOnlyServicesOption.toFlutterValue()
    if (itemInfo != null) {
        data["itemInfo"] = itemInfo!!.toFlutterJson()
    }
    data["attachmentSyncDirection"] = attachmentSyncDirection.toFlutterValue()
    data["continueOnErrors"] = continueOnErrors
    data["includeBasemap"] = includeBasemap
    data["isDefinitionExpressionFilterEnabled"] = isDefinitionExpressionFilterEnabled
    data["returnLayerAttachmentOption"] = returnLayerAttachmentOption.toFlutterValue()
    data["returnSchemaOnlyForEditableLayers"] = returnSchemaOnlyForEditableLayers
    data["updateMode"] = updateMode.toFlutterValue()
    data["destinationTableRowFilter"] = destinationTableRowFilter.toFlutterValue()
    data["esriVectorTilesDownloadOption"] = esriVectorTilesDownloadOption.toFlutterValue()
    data["referenceBasemapDirectory"] = referenceBasemapDirectory
    data["referenceBasemapFilename"] = referenceBasemapFilename
    return data
}

fun Any?.toGenerateOfflineMapParametersOrNull(): GenerateOfflineMapParameters? {
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val parameters = GenerateOfflineMapParameters(
        data["areaOfInterest"]!!.toGeometryOrNull()!!,
        data["minScale"] as Double?,
        data["maxScale"] as Double?
    )
    parameters.onlineOnlyServicesOption =
        (data["onlineOnlyServicesOption"] as Int).toOnlineOnlyServicesOption()
    parameters.itemInfo = data["itemInfo"]?.toOfflineMapItemInfoOrNull()
    parameters.attachmentSyncDirection =
        (data["attachmentSyncDirection"] as Int).toAttachmentSyncDirection()
    parameters.continueOnErrors = data["continueOnErrors"] as Boolean
    parameters.includeBasemap = data["includeBasemap"] as Boolean
    parameters.isDefinitionExpressionFilterEnabled =
        data["isDefinitionExpressionFilterEnabled"] as Boolean
    parameters.returnLayerAttachmentOption =
        (data["returnLayerAttachmentOption"] as Int).toReturnLayerAttachmentOption()
    parameters.returnSchemaOnlyForEditableLayers =
        data["returnSchemaOnlyForEditableLayers"] as Boolean
    parameters.updateMode = (data["updateMode"] as Int).toGenerateOfflineMapUpdateMode()
    parameters.destinationTableRowFilter = (data["destinationTableRowFilter"] as Int).toDestinationTableRowFilter()
    parameters.esriVectorTilesDownloadOption = (data["esriVectorTilesDownloadOption"] as Int).toEsriVectorTilesDownloadOption()
    parameters.referenceBasemapDirectory = data["referenceBasemapDirectory"] as String
    parameters.referenceBasemapFilename = data["referenceBasemapFilename"] as String
    return parameters
}