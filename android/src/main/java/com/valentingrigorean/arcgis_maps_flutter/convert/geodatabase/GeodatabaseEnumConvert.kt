package com.valentingrigorean.arcgis_maps_flutter.convert.geodatabase

import com.arcgismaps.tasks.geodatabase.AttachmentSyncDirection
import com.arcgismaps.tasks.geodatabase.GenerateGeodatabaseParameters
import com.arcgismaps.tasks.geodatabase.GenerateLayerQueryOption
import com.arcgismaps.tasks.geodatabase.SyncDirection

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