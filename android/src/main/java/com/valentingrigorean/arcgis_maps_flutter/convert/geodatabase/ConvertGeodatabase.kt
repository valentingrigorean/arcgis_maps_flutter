package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.tasks.geodatabase.GenerateLayerOption
import com.arcgismaps.tasks.geodatabase.SyncLayerOption
import com.arcgismaps.tasks.geodatabase.SyncLayerResult
import com.esri.arcgisruntime.data.SyncModel
import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseParameters
import com.esri.arcgisruntime.tasks.geodatabase.GenerateLayerOption
import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseDeltaInfo
import com.esri.arcgisruntime.tasks.geodatabase.SyncGeodatabaseParameters
import com.esri.arcgisruntime.tasks.geodatabase.SyncLayerOption
import com.esri.arcgisruntime.tasks.geodatabase.SyncLayerResult
import com.esri.arcgisruntime.tasks.geodatabase.UtilityNetworkSyncMode
import com.valentingrigorean.arcgis_maps_flutter.Convert

object ConvertGeodatabase : Convert() {

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
}