package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.GenerateOfflineMapParameters
import com.esri.arcgisruntime.geometry.Geometry
import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseParameters
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapParameters
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapUpdateMode
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapItemInfo
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncParameters
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncResult
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapUpdateCapabilities
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapUpdatesInfo
import com.esri.arcgisruntime.tasks.offlinemap.OfflineUpdateAvailability
import com.esri.arcgisruntime.tasks.offlinemap.PreplannedScheduledUpdatesOption
import com.esri.arcgisruntime.tasks.vectortilecache.EsriVectorTilesDownloadOption
import com.valentingrigorean.arcgis_maps_flutter.Convert

object ConvertOfflineMap : Convert() {
    fun generateOfflineMapParametersToJson(parameters: GenerateOfflineMapParameters): Any {
        val data = HashMap<String, Any?>(16)
        data["areaOfInterest"] =
            Convert.Companion.geometryToJson(parameters.areaOfInterest)
        data["minScale"] = parameters.minScale
        data["maxScale"] = parameters.maxScale
        data["onlineOnlyServicesOption"] = parameters.onlineOnlyServicesOption.ordinal
        if (parameters.itemInfo != null) {
            data["itemInfo"] = offlineMapItemInfoToJson(parameters.itemInfo)
        }
        data["attachmentSyncDirection"] =
            attachmentSyncDirectionToJson(parameters.attachmentSyncDirection)
        data["continueOnErrors"] = parameters.isContinueOnErrors
        data["includeBasemap"] = parameters.isIncludeBasemap
        data["isDefinitionExpressionFilterEnabled"] = parameters.isDefinitionExpressionFilterEnabled
        data["returnLayerAttachmentOption"] =
            returnLayerAttachmentOptionToJson(parameters.returnLayerAttachmentOption)
        data["returnSchemaOnlyForEditableLayers"] = parameters.isReturnSchemaOnlyForEditableLayers
        data["updateMode"] = parameters.updateMode.ordinal
        data["destinationTableRowFilter"] = parameters.destinationTableRowFilter.ordinal
        data["esriVectorTilesDownloadOption"] = parameters.esriVectorTilesDownloadOption.ordinal
        data["referenceBasemapDirectory"] = parameters.referenceBasemapDirectory
        data["referenceBasemapFilename"] = parameters.referenceBasemapFilename
        return data
    }

    fun toGenerateOfflineMapParameters(json: Any?): GenerateOfflineMapParameters {
        val data: Map<*, *> = Convert.Companion.toMap(
            json!!
        )
        val areaOfInterest: Geometry = Convert.Companion.toGeometry(
            data["areaOfInterest"]
        )
        val minScale: Double = Convert.Companion.toDouble(
            data["minScale"]
        )
        val maxScale: Double = Convert.Companion.toDouble(
            data["maxScale"]
        )
        val parameters = GenerateOfflineMapParameters(areaOfInterest, minScale, maxScale)
        parameters.onlineOnlyServicesOption =
            GenerateOfflineMapParameters.OnlineOnlyServicesOption.values()[Convert.Companion.toInt(
                data["onlineOnlyServicesOption"]
            )]
        val itemInfo = data["itemInfo"]
        if (itemInfo != null) {
            parameters.itemInfo = toOfflineMapItemInfo(itemInfo)
        }
        parameters.attachmentSyncDirection =
            toAttachmentSyncDirection(data["attachmentSyncDirection"])
        parameters.isContinueOnErrors = Convert.Companion.toBoolean(
            data["continueOnErrors"]!!
        )
        parameters.isIncludeBasemap = Convert.Companion.toBoolean(
            data["includeBasemap"]!!
        )
        parameters.isDefinitionExpressionFilterEnabled = Convert.Companion.toBoolean(
            data["isDefinitionExpressionFilterEnabled"]!!
        )
        parameters.returnLayerAttachmentOption = toReturnLayerAttachmentOption(
            data["returnLayerAttachmentOption"]
        )
        parameters.isReturnSchemaOnlyForEditableLayers = Convert.Companion.toBoolean(
            data["returnSchemaOnlyForEditableLayers"]!!
        )
        parameters.updateMode = GenerateOfflineMapUpdateMode.values()[Convert.Companion.toInt(
            data["updateMode"]
        )]
        parameters.destinationTableRowFilter =
            GenerateOfflineMapParameters.DestinationTableRowFilter.values()[Convert.Companion.toInt(
                data["destinationTableRowFilter"]
            )]
        parameters.esriVectorTilesDownloadOption =
            EsriVectorTilesDownloadOption.values()[Convert.Companion.toInt(
                data["esriVectorTilesDownloadOption"]
            )]
        val referenceBasemapDirectory = data["referenceBasemapDirectory"]
        if (referenceBasemapDirectory != null) {
            parameters.referenceBasemapDirectory = referenceBasemapDirectory as String?
        }
        parameters.referenceBasemapFilename = data["referenceBasemapFilename"] as String?
        return parameters
    }

    fun offlineMapUpdateCapabilitiesToJson(capabilities: OfflineMapUpdateCapabilities): Any {
        val data = HashMap<String, Any>(2)
        data["supportsScheduledUpdatesForFeatures"] =
            capabilities.isSupportsScheduledUpdatesForFeatures
        data["supportsSyncWithFeatureServices"] = capabilities.isSupportsSyncWithFeatureServices
        return data
    }

    fun offlineMapUpdatesInfoToJson(offlineMapUpdatesInfo: OfflineMapUpdatesInfo): Any {
        val data = HashMap<String, Any>(4)
        data["downloadAvailability"] =
            offlineUpdateAvailabilityToJson(offlineMapUpdatesInfo.downloadAvailability)
        data["isMobileMapPackageReopenRequired"] =
            offlineMapUpdatesInfo.isMobileMapPackageReopenRequired
        data["scheduledUpdatesDownloadSize"] = offlineMapUpdatesInfo.scheduledUpdatesDownloadSize
        data["uploadAvailability"] =
            offlineUpdateAvailabilityToJson(offlineMapUpdatesInfo.uploadAvailability)
        return data
    }

    fun offlineMapSyncParametersToJson(offlineMapSyncParameters: OfflineMapSyncParameters): Any {
        val data = HashMap<String, Any>(4)
        data["keepGeodatabaseDeltas"] = offlineMapSyncParameters.isKeepGeodatabaseDeltas
        data["preplannedScheduledUpdatesOption"] =
            offlineMapSyncParameters.preplannedScheduledUpdatesOption.ordinal
        data["rollbackOnFailure"] = offlineMapSyncParameters.isRollbackOnFailure
        data["syncDirection"] = Convert.Companion.syncDirectionToJson(
            offlineMapSyncParameters.syncDirection
        )
        return data
    }

    fun toOfflineMapSyncParameters(json: Any): OfflineMapSyncParameters {
        val data: Map<*, *> = Convert.Companion.toMap(json)
        val parameters = OfflineMapSyncParameters()
        parameters.isKeepGeodatabaseDeltas = Convert.Companion.toBoolean(
            data["keepGeodatabaseDeltas"]!!
        )
        parameters.preplannedScheduledUpdatesOption =
            PreplannedScheduledUpdatesOption.values()[Convert.Companion.toInt(
                data["preplannedScheduledUpdatesOption"]
            )]
        parameters.isRollbackOnFailure = Convert.Companion.toBoolean(
            data["rollbackOnFailure"]!!
        )
        parameters.syncDirection = Convert.Companion.toSyncDirection(
            Convert.Companion.toInt(
                data["syncDirection"]
            )
        )
        return parameters
    }

    fun offlineMapSyncResultToJson(result: OfflineMapSyncResult): Any {
        val data = HashMap<String, Any>(2)
        data["hasErrors"] = result.hasErrors()
        data["isMobileMapPackageReopenRequired"] = result.isMobileMapPackageReopenRequired
        return data
    }

    private fun offlineMapItemInfoToJson(itemInfo: OfflineMapItemInfo): Any {
        val data = HashMap<String, Any>(7)
        data["accessInformation"] = itemInfo.accessInformation
        data["itemDescription"] = itemInfo.description
        data["snippet"] = itemInfo.snippet
        data["tags"] = itemInfo.tags
        data["termsOfUse"] = itemInfo.termsOfUse
        data["title"] = itemInfo.title
        if (itemInfo.thumbnailData != null) {
            data["thumbnail"] = itemInfo.thumbnailData
        }
        return data
    }

    private fun toOfflineMapItemInfo(json: Any): OfflineMapItemInfo {
        val data: Map<*, *> = Convert.Companion.toMap(json)
        val mapItemInfo = OfflineMapItemInfo()
        mapItemInfo.accessInformation = data["accessInformation"] as String?
        mapItemInfo.description = data["itemDescription"] as String?
        mapItemInfo.snippet = data["snippet"] as String?
        for (item in Convert.Companion.toList(
            data["tags"]!!
        )) {
            mapItemInfo.tags.add(item as String)
        }
        mapItemInfo.termsOfUse = data["termsOfUse"] as String?
        mapItemInfo.title = data["title"] as String?
        val thumbnail = data["thumbnail"]
        if (thumbnail != null) {
            mapItemInfo.thumbnailData = thumbnail as ByteArray?
        }
        return mapItemInfo
    }

    private fun toReturnLayerAttachmentOption(json: Any?): GenerateOfflineMapParameters.ReturnLayerAttachmentOption {
        return when (Convert.Companion.toInt(json)) {
            1 -> GenerateOfflineMapParameters.ReturnLayerAttachmentOption.ALL_LAYERS
            2 -> GenerateOfflineMapParameters.ReturnLayerAttachmentOption.READ_ONLY_LAYERS
            3 -> GenerateOfflineMapParameters.ReturnLayerAttachmentOption.EDITABLE_LAYERS
            else -> GenerateOfflineMapParameters.ReturnLayerAttachmentOption.NONE
        }
    }

    private fun returnLayerAttachmentOptionToJson(option: GenerateOfflineMapParameters.ReturnLayerAttachmentOption): Int {
        return when (option) {
            GenerateOfflineMapParameters.ReturnLayerAttachmentOption.ALL_LAYERS -> 1
            GenerateOfflineMapParameters.ReturnLayerAttachmentOption.READ_ONLY_LAYERS -> 2
            GenerateOfflineMapParameters.ReturnLayerAttachmentOption.EDITABLE_LAYERS -> 3
            else -> 0
        }
    }

    private fun toAttachmentSyncDirection(json: Any?): GenerateGeodatabaseParameters.AttachmentSyncDirection {
        return when (Convert.Companion.toInt(json)) {
            1 -> GenerateGeodatabaseParameters.AttachmentSyncDirection.UPLOAD
            2 -> GenerateGeodatabaseParameters.AttachmentSyncDirection.BIDIRECTIONAL
            else -> GenerateGeodatabaseParameters.AttachmentSyncDirection.NONE
        }
    }

    private fun attachmentSyncDirectionToJson(attachmentSyncDirection: GenerateGeodatabaseParameters.AttachmentSyncDirection): Int {
        return when (attachmentSyncDirection) {
            GenerateGeodatabaseParameters.AttachmentSyncDirection.UPLOAD -> 1
            GenerateGeodatabaseParameters.AttachmentSyncDirection.BIDIRECTIONAL -> 2
            else -> 0
        }
    }

    private fun offlineUpdateAvailabilityToJson(availability: OfflineUpdateAvailability): Int {
        return when (availability) {
            OfflineUpdateAvailability.AVAILABLE -> 0
            OfflineUpdateAvailability.NONE -> 1
            else -> -1
        }
    }
}