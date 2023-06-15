package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.OfflineMapSyncParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geodatabase.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.geodatabase.toSyncDirection

fun OfflineMapSyncParameters.toFlutterJson() : Any{
    val data = HashMap<String, Any>(4)
    data["keepGeodatabaseDeltas"] = keepGeodatabaseDeltas
    data["preplannedScheduledUpdatesOption"] = preplannedScheduledUpdatesOption.toFlutterValue()
    data["rollbackOnFailure"] = rollbackOnFailure
    data["syncDirection"] = syncDirection.toFlutterValue()
    return data
}

fun Any.toOfflineMapSyncParametersOrNull() : OfflineMapSyncParameters?{
    val data: Map<*, *> = this as Map<*, *>? ?: return null
    val parameters = OfflineMapSyncParameters()
    parameters.keepGeodatabaseDeltas = data["keepGeodatabaseDeltas"] as Boolean
    parameters.preplannedScheduledUpdatesOption = (  data["preplannedScheduledUpdatesOption"] as Int).toPreplannedScheduledUpdatesOption()
    parameters.rollbackOnFailure = data["rollbackOnFailure"] as Boolean
    parameters.syncDirection = ( data["syncDirection"] as Int).toSyncDirection()
    return parameters
}