package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.GenerateOfflineMapParameters
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toFlutterJson

fun GenerateOfflineMapParameters.toFlutterJson() : Any{
    val data = HashMap<String, Any?>(16)
   areaOfInterest?.let {
        data["areaOfInterest"] = it.toFlutterJson()
    }
    data["minScale"] = minScale
    data["maxScale"] = maxScale
    data["onlineOnlyServicesOption"] = onlineOnlyServicesOption.toFlutterValue()
    if (itemInfo != null) {
        data["itemInfo"] = ConvertOfflineMap.offlineMapItemInfoToJson(parameters.itemInfo)
    }
    data["attachmentSyncDirection"] =
        ConvertOfflineMap.attachmentSyncDirectionToJson(parameters.attachmentSyncDirection)
    data["continueOnErrors"] = parameters.isContinueOnErrors
    data["includeBasemap"] = parameters.isIncludeBasemap
    data["isDefinitionExpressionFilterEnabled"] = parameters.isDefinitionExpressionFilterEnabled
    data["returnLayerAttachmentOption"] =
        ConvertOfflineMap.returnLayerAttachmentOptionToJson(parameters.returnLayerAttachmentOption)
    data["returnSchemaOnlyForEditableLayers"] = parameters.isReturnSchemaOnlyForEditableLayers
    data["updateMode"] = parameters.updateMode.ordinal
    data["destinationTableRowFilter"] = parameters.destinationTableRowFilter.ordinal
    data["esriVectorTilesDownloadOption"] = parameters.esriVectorTilesDownloadOption.ordinal
    data["referenceBasemapDirectory"] = parameters.referenceBasemapDirectory
    data["referenceBasemapFilename"] = parameters.referenceBasemapFilename
    return data
}