package com.valentingrigorean.arcgis_maps_flutter.utils

import android.util.Log
import com.esri.arcgisruntime.loadable.LoadStatus
import com.esri.arcgisruntime.loadable.LoadStatusChangedEvent
import com.esri.arcgisruntime.loadable.LoadStatusChangedListener
import com.esri.arcgisruntime.loadable.Loadable

class LoadStatusChangedListenerLogger @JvmOverloads constructor(
    private val tag: String,
    private val loadable: Loadable,
    private val autoDetach: Boolean = true
) : LoadStatusChangedListener {
    override fun loadStatusChanged(loadStatusChangedEvent: LoadStatusChangedEvent) {
        Log.d(tag, "loadStatusChanged: " + loadStatusChangedEvent.newLoadStatus.name)
        if (loadStatusChangedEvent.newLoadStatus == LoadStatus.FAILED_TO_LOAD) {
            Log.e(tag, "loadStatusChanged: " + loadable.loadError.message)
            if (loadable.loadError.cause != null) {
                Log.e(tag, "loadStatusChanged: " + loadable.loadError.cause!!.message)
            }
        }
        if ((loadStatusChangedEvent.newLoadStatus == LoadStatus.LOADED || loadStatusChangedEvent.newLoadStatus == LoadStatus.FAILED_TO_LOAD) && autoDetach) {
            detach()
        }
    }

    fun attach(): LoadStatusChangedListenerLogger {
        loadable.addLoadStatusChangedListener(this)
        return this
    }

    fun detach(): LoadStatusChangedListenerLogger {
        loadable.removeLoadStatusChangedListener(this)
        return this
    }
}