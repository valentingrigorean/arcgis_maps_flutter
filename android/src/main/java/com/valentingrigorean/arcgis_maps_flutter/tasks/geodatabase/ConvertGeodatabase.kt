package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase

import com.esri.arcgisruntime.data.SyncModel
import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseParameters
import com.esri.arcgisruntime.tasks.geodatabase.GenerateLayerOption
import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseDeltaInfo
import com.esri.arcgisruntime.tasks.geodatabase.SyncGeodatabaseParameters
import com.esri.arcgisruntime.tasks.geodatabase.SyncLayerOption
import com.esri.arcgisruntime.tasks.geodatabase.SyncLayerResult
import com.esri.arcgisruntime.tasks.geodatabase.UtilityNetworkSyncMode
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap

object ConvertGeodatabase : Convert() {
    fun geodatabaseDeltaInfoToJson(geodatabaseDeltaInfo: GeodatabaseDeltaInfo): Any {
        val data = HashMap<String, Any>(4)
        if (geodatabaseDeltaInfo.downloadDeltaPath != null) {
            data["downloadDeltaFileUrl"] = geodatabaseDeltaInfo.downloadDeltaPath
        }
        data["featureServiceUrl"] = geodatabaseDeltaInfo.featureServiceUrl
        data["geodatabaseFileUrl"] = geodatabaseDeltaInfo.geodatabasePath
        if (geodatabaseDeltaInfo.uploadDeltaPath != null) {
            data["uploadDeltaFileUrl"] = geodatabaseDeltaInfo.uploadDeltaPath
        }
        return data
    }

    fun syncGeodatabaseParametersToJson(syncGeodatabaseParameters: SyncGeodatabaseParameters): Any {
        val data = HashMap<String, Any>(4)
        data["keepGeodatabaseDeltas"] = syncGeodatabaseParameters.isKeepGeodatabaseDeltas
        data["geodatabaseSyncDirection"] =
            Convert.Companion.syncDirectionToJson(
                syncGeodatabaseParameters.syncDirection
            )
        data["layerOptions"] =
            syncLayerOptionsToJson(syncGeodatabaseParameters.layerOptions)
        data["rollbackOnFailure"] = syncGeodatabaseParameters.isRollbackOnFailure
        return data
    }

    fun toSyncGeodatabaseParameters(o: Any?): SyncGeodatabaseParameters {
        val data: Map<*, *> = Convert.Companion.toMap(
            o!!
        )
        val syncGeodatabaseParameters = SyncGeodatabaseParameters()
        syncGeodatabaseParameters.isKeepGeodatabaseDeltas = Convert.Companion.toBoolean(
            data["keepGeodatabaseDeltas"]!!
        )
        syncGeodatabaseParameters.syncDirection = Convert.Companion.toSyncDirection(
            data["geodatabaseSyncDirection"]
        )
        syncGeodatabaseParameters.layerOptions.addAll(toSyncLayerOptions(data["layerOptions"]))
        syncGeodatabaseParameters.isRollbackOnFailure = Convert.Companion.toBoolean(
            data["rollbackOnFailure"]!!
        )
        return syncGeodatabaseParameters
    }

    private fun toSyncLayerOptions(layerOptions: Any?): Collection<SyncLayerOption> {
        val data: List<*> = Convert.Companion.toList(
            layerOptions!!
        )
        val syncLayerOptions = ArrayList<SyncLayerOption>(data.size)
        for (layerOption in data) {
            syncLayerOptions.add(toSyncLayerOption(layerOption))
        }
        return syncLayerOptions
    }

    fun syncLayerResultsToJson(syncResults: List<SyncLayerResult>): Any {
        val data = ArrayList<Any>(syncResults.size)
        for (layerResult in syncResults) {
            data.add(syncLayerResultToJson(layerResult))
        }
        return data
    }

    fun generateGeodatabaseParametersToJson(parameters: GenerateGeodatabaseParameters): Any {
        val json = HashMap<String, Any?>()
        json["attachmentSyncDirection"] =
            attachmentSyncDirectionToJson(parameters.attachmentSyncDirection)
        if (parameters.extent != null) {
            json["extent"] = Convert.Companion.geometryToJson(parameters.extent)
        }
        val layersOptions = ArrayList<Any>()
        for (option in parameters.layerOptions) {
            layersOptions.add(generateLayerOptionToJson(option))
        }
        json["layerOptions"] = layersOptions
        if (parameters.outSpatialReference != null) {
            json["outSpatialReference"] =
                Convert.Companion.spatialReferenceToJson(parameters.outSpatialReference)
        }
        json["returnAttachments"] = parameters.isReturnAttachments
        json["shouldSyncContingentValues"] = parameters.syncContingentValues
        json["syncModel"] = parameters.syncModel.ordinal
        json["utilityNetworkSyncMode"] = parameters.utilityNetworkSyncMode.ordinal
        return json
    }

    fun toGenerateGeodatabaseParameters(json: Any?): GenerateGeodatabaseParameters {
        val data: Map<*, *> = Convert.Companion.toMap(
            json!!
        )
        val attachmentSyncDirection = data["attachmentSyncDirection"]
        val extent = data["extent"]
        val layerOptions: List<*> = Convert.Companion.toList(
            data["layerOptions"]!!
        )
        val outSpatialReference = data["outSpatialReference"]
        val returnAttachments = data["returnAttachments"]
        val shouldSyncContingentValues = data["shouldSyncContingentValues"]
        val syncModel = data["syncModel"]
        val utilityNetworkSyncMode = data["utilityNetworkSyncMode"]
        val parameters = GenerateGeodatabaseParameters()
        parameters.attachmentSyncDirection = toAttachmentSyncDirection(attachmentSyncDirection)
        if (extent != null) {
            parameters.extent = Convert.Companion.toGeometry(extent)
        }
        for (layerOption in layerOptions) {
            parameters.layerOptions.add(toGenerateLayerOption(layerOption))
        }
        if (outSpatialReference != null) {
            parameters.outSpatialReference =
                Convert.Companion.toSpatialReference(outSpatialReference)
        }
        parameters.isReturnAttachments = Convert.Companion.toBoolean(
            returnAttachments!!
        )
        parameters.syncContingentValues = Convert.Companion.toBoolean(
            shouldSyncContingentValues!!
        )
        parameters.syncModel = SyncModel.values()[Convert.Companion.toInt(syncModel)]
        parameters.utilityNetworkSyncMode =
            UtilityNetworkSyncMode.values()[Convert.Companion.toInt(utilityNetworkSyncMode)]
        return parameters
    }

    private fun syncLayerOptionsToJson(syncLayerOptions: List<SyncLayerOption>): Any {
        val data = ArrayList<Any>(syncLayerOptions.size)
        for (layerOption in syncLayerOptions) {
            data.add(syncLayerOptionToJson(layerOption))
        }
        return data
    }

    private fun syncLayerOptionToJson(syncLayerOption: SyncLayerOption): Any {
        val data = HashMap<String, Any>(2)
        data["layerId"] = syncLayerOption.layerId
        data["syncDirection"] =
            Convert.Companion.syncDirectionToJson(syncLayerOption.syncDirection)
        return data
    }

    private fun toSyncLayerOption(json: Any): SyncLayerOption {
        val data: Map<*, *> = Convert.Companion.toMap(json)
        val layerId = data["layerId"]
        val syncDirection = data["syncDirection"]
        return SyncLayerOption(
            Convert.Companion.toInt(layerId).toLong(),
            Convert.Companion.toSyncDirection(syncDirection)
        )
    }

    private fun syncLayerResultToJson(syncResult: SyncLayerResult): Any {
        val json = HashMap<String, Any>(3)
        val editsResults = ArrayList<Any>(syncResult.editResults.size)
        for (editResult in syncResult.editResults) {
            editsResults.add(Convert.Companion.featureEditResultToJson(editResult))
        }
        json["editResults"] = editsResults
        json["layerId"] = syncResult.layerId
        json["tableName"] = syncResult.tableName
        return json
    }

    private fun generateLayerOptionToJson(layerOption: GenerateLayerOption): Any {
        val json = HashMap<String, Any>(5)
        json["layerId"] = layerOption.layerId
        json["includeRelated"] = layerOption.isIncludeRelated
        json["queryOption"] = layerOption.queryOption.ordinal
        json["useGeometry"] = layerOption.isUseGeometry
        json["whereClause"] = layerOption.whereClause
        return json
    }

    private fun toGenerateLayerOption(json: Any): GenerateLayerOption {
        val data: Map<*, *> = Convert.Companion.toMap(json)
        val layerOption = GenerateLayerOption()
        layerOption.layerId = Convert.Companion.toLong(
            data["layerId"]
        )
        layerOption.isIncludeRelated = Convert.Companion.toBoolean(
            data["includeRelated"]!!
        )
        layerOption.queryOption = GenerateLayerOption.QueryOption.values()[Convert.Companion.toInt(
            data["queryOption"]
        )]
        layerOption.isUseGeometry = Convert.Companion.toBoolean(
            data["useGeometry"]!!
        )
        layerOption.whereClause = data["whereClause"] as String?
        return layerOption
    }

    private fun attachmentSyncDirectionToJson(direction: GenerateGeodatabaseParameters.AttachmentSyncDirection): Int {
        return when (direction) {
            GenerateGeodatabaseParameters.AttachmentSyncDirection.UPLOAD -> 1
            GenerateGeodatabaseParameters.AttachmentSyncDirection.BIDIRECTIONAL -> 2
            else -> 0
        }
    }

    private fun toAttachmentSyncDirection(direction: Any?): GenerateGeodatabaseParameters.AttachmentSyncDirection {
        return when (Convert.Companion.toInt(direction)) {
            1 -> GenerateGeodatabaseParameters.AttachmentSyncDirection.UPLOAD
            2 -> GenerateGeodatabaseParameters.AttachmentSyncDirection.BIDIRECTIONAL
            else -> GenerateGeodatabaseParameters.AttachmentSyncDirection.NONE
        }
    }
}