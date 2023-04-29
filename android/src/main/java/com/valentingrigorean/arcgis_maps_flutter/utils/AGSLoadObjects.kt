package com.valentingrigorean.arcgis_maps_flutter.utils

import com.esri.arcgisruntime.loadable.LoadStatus
import com.esri.arcgisruntime.loadable.Loadable
import com.esri.arcgisruntime.mapping.LayerList

object AGSLoadObjects {
    fun load(array: LayerList, callback: LoadObjectsResult?) {
        val loadedItems = HashSet<Loadable>(array.size)
        val loadingStatus = LoadingStatus()
        for (loadable in array) {
            when (loadable.loadStatus) {
                LoadStatus.LOADED -> {
                    loadedItems.add(loadable)
                    if (didFinishLoading(loadedItems, array.size)) {
                        if (callback != null) {
                            callback.completed(didFinishWithNoErrors(loadedItems))
                            loadingStatus.setFinish()
                        }
                    }
                }

                LoadStatus.FAILED_TO_LOAD -> {
                    if (callback != null) {
                        callback.completed(false)
                        loadingStatus.setFinish()
                    }
                    return
                }

                LoadStatus.LOADING, LoadStatus.NOT_LOADED -> {
                    loadable.addDoneLoadingListener {
                        if (loadingStatus.isFinish()) {
                            return@addDoneLoadingListener
                        }
                        if (loadable.loadStatus != LoadStatus.LOADED) {
                            if (callback != null) {
                                callback.completed(false)
                                loadingStatus.setFinish()
                            }
                        } else {
                            loadedItems.add(loadable)
                            if (didFinishLoading(loadedItems, array.size)) {
                                if (callback != null) {
                                    callback.completed(didFinishWithNoErrors(loadedItems))
                                    loadingStatus.setFinish()
                                }
                            }
                        }
                    }
                    loadable.loadAsync()
                }
            }
        }
    }

    private fun didFinishLoading(array: Collection<Loadable>, count: Int): Boolean {
        return array.size == count
    }

    private fun didFinishWithNoErrors(array: Collection<Loadable>): Boolean {
        for (loadable in array) {
            if (loadable.loadStatus != LoadStatus.LOADED) {
                return false
            }
        }
        return true
    }

    interface LoadObjectsResult {
        fun completed(loaded: Boolean)
    }

    private class LoadingStatus {
        var isFinish = false
            private set

        fun setFinish() {
            isFinish = true
        }
    }
}