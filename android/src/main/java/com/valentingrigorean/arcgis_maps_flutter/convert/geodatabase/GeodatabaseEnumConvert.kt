package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.data.EditResult
import com.arcgismaps.tasks.geodatabase.AttachmentSyncDirection
import com.arcgismaps.tasks.geodatabase.GenerateGeodatabaseParameters
import com.arcgismaps.tasks.geodatabase.GenerateLayerQueryOption
import com.arcgismaps.tasks.geodatabase.SyncDirection
import com.arcgismaps.tasks.geodatabase.SyncModel
import com.arcgismaps.tasks.geodatabase.UtilityNetworkSyncMode

fun SyncDirection.toFlutterValue(): Int {
    return when (this) {
        SyncDirection.None -> 0
        SyncDirection.Download -> 1
        SyncDirection.Upload -> 2
        SyncDirection.Bidirectional -> 3
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun Int.toSyncDirection(): SyncDirection {
    return when (this) {
        0 -> SyncDirection.None
        1 -> SyncDirection.Download
        2 -> SyncDirection.Upload
        3 -> SyncDirection.Bidirectional
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun GenerateLayerQueryOption.toFlutterValue(): Int {
    return when (this) {
        GenerateLayerQueryOption.All -> return 0
        GenerateLayerQueryOption.None -> return 1
        GenerateLayerQueryOption.UseFilter -> return 2
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun Int.toGenerateLayerQueryOption() : GenerateLayerQueryOption{
    return when (this) {
        0 -> GenerateLayerQueryOption.All
        1 -> GenerateLayerQueryOption.None
        2 -> GenerateLayerQueryOption.UseFilter
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun AttachmentSyncDirection.toFlutterValue() : Int{
    return when (this) {
        AttachmentSyncDirection.Upload -> 1
        AttachmentSyncDirection.Bidirectional -> 2
        else -> 0
    }
}

fun Int.toAttachmentSyncDirection() : AttachmentSyncDirection{
    return when (this) {
        1 -> AttachmentSyncDirection.Upload
        2 -> AttachmentSyncDirection.Bidirectional
        else -> AttachmentSyncDirection.None
    }
}

fun SyncModel.toFlutterValue() : Int{
    return when (this) {
        SyncModel.None -> 0
        SyncModel.Geodatabase -> 1
        SyncModel.Layer -> 2
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun Int.toSyncModel() : SyncModel{
    return when (this) {
        0 -> SyncModel.None
        1 -> SyncModel.Geodatabase
        2 -> SyncModel.Layer
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun UtilityNetworkSyncMode.toFlutterValue() : Int{
    return when (this) {
        UtilityNetworkSyncMode.None -> 0
        UtilityNetworkSyncMode.SyncSystemTables -> 1
        UtilityNetworkSyncMode.SyncSystemAndTopologyTables -> 2
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun Int.toUtilityNetworkSyncMode() : UtilityNetworkSyncMode {
    return when (this) {
        0 -> UtilityNetworkSyncMode.None
        1 -> UtilityNetworkSyncMode.SyncSystemTables
        2 -> UtilityNetworkSyncMode.SyncSystemAndTopologyTables
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}