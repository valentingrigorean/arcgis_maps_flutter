package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.offlinemap

import com.arcgismaps.tasks.offlinemaptask.DestinationTableRowFilter
import com.arcgismaps.tasks.offlinemaptask.GenerateOfflineMapUpdateMode
import com.arcgismaps.tasks.offlinemaptask.OfflineUpdateAvailability
import com.arcgismaps.tasks.offlinemaptask.OnlineOnlyServicesOption
import com.arcgismaps.tasks.offlinemaptask.PreplannedScheduledUpdatesOption
import com.arcgismaps.tasks.offlinemaptask.ReturnLayerAttachmentOption

fun OnlineOnlyServicesOption.toFlutterValue(): Int {
    return when (this) {
        OnlineOnlyServicesOption.Exclude -> 0
        OnlineOnlyServicesOption.Include -> 1
        OnlineOnlyServicesOption.UseAuthoredSettings -> 2
    }
}

fun Int.toOnlineOnlyServicesOption(): OnlineOnlyServicesOption {
    return when (this) {
        0 -> OnlineOnlyServicesOption.Exclude
        1 -> OnlineOnlyServicesOption.Include
        2 -> OnlineOnlyServicesOption.UseAuthoredSettings
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun ReturnLayerAttachmentOption.toFlutterValue() :Int{
    return when (this) {
        ReturnLayerAttachmentOption.None -> 0
        ReturnLayerAttachmentOption.AllLayers -> 1
        ReturnLayerAttachmentOption.ReadOnlyLayers -> 2
        ReturnLayerAttachmentOption.EditableLayers -> 3
    }
}

fun Int.toReturnLayerAttachmentOption() : ReturnLayerAttachmentOption{
    return when (this) {
        0 -> ReturnLayerAttachmentOption.None
        1 -> ReturnLayerAttachmentOption.AllLayers
        2 -> ReturnLayerAttachmentOption.ReadOnlyLayers
        3 -> ReturnLayerAttachmentOption.EditableLayers
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun GenerateOfflineMapUpdateMode.toFlutterValue() : Int{
    return when (this) {
        GenerateOfflineMapUpdateMode.SyncWithFeatureServices -> 0
        GenerateOfflineMapUpdateMode.NoUpdates -> 1
    }
}

fun Int.toGenerateOfflineMapUpdateMode() : GenerateOfflineMapUpdateMode{
    return when (this) {
        0 -> GenerateOfflineMapUpdateMode.SyncWithFeatureServices
        1 -> GenerateOfflineMapUpdateMode.NoUpdates
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun DestinationTableRowFilter.toFlutterValue() : Int {
    return when (this) {
        DestinationTableRowFilter.All -> 0
        DestinationTableRowFilter.RelatedOnly -> 1
    }
}

fun Int.toDestinationTableRowFilter() : DestinationTableRowFilter{
    return when (this) {
        0 -> DestinationTableRowFilter.All
        1 -> DestinationTableRowFilter.RelatedOnly
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun PreplannedScheduledUpdatesOption.toFlutterValue() : Int{
    return when (this) {
        PreplannedScheduledUpdatesOption.NoUpdates -> 0
        PreplannedScheduledUpdatesOption.DownloadAllUpdates -> 1
    }
}

fun Int.toPreplannedScheduledUpdatesOption() : PreplannedScheduledUpdatesOption{
    return when (this) {
        0 -> PreplannedScheduledUpdatesOption.NoUpdates
        1 -> PreplannedScheduledUpdatesOption.DownloadAllUpdates
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun OfflineUpdateAvailability.toFlutterValue() : Int {
    return when (this) {
        OfflineUpdateAvailability.Indeterminate -> -1
        OfflineUpdateAvailability.Available -> 0
        OfflineUpdateAvailability.None -> 1
    }
}
