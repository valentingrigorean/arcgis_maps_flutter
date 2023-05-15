package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap

import com.arcgismaps.mapping.MobileMapPackage
import com.arcgismaps.tasks.offlinemaptask.OfflineMapSyncTask
import com.valentingrigorean.arcgis_maps_flutter.ConvertUti
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeObject
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class OfflineMapSyncTaskNativeObject(
    override val objectId: String,
    private val offlineMapPath: String
) : NativeObject {
    private val pendingCalls = ArrayList<MethodCall>()
    private var isDisposed = false
    private var offlineMapSyncTaskNativeObjectWrapper: OfflineMapSyncTaskNativeObjectWrapper? = null
    private var messageSink: NativeMessageSink? = null

    init {
        loadOfflineMap()
    }

    override fun dispose() {
        if (isDisposed) {
            return
        }
        isDisposed = true
        if (offlineMapSyncTaskNativeObjectWrapper != null) {
            offlineMapSyncTaskNativeObjectWrapper!!.dispose()
        }
        offlineMapSyncTaskNativeObjectWrapper = null
    }

    override fun setMessageSink(messageSink: NativeMessageSink?) {
        this.messageSink = NativeObjectMessageSink(objectId, messageSink)
        if (offlineMapSyncTaskNativeObjectWrapper != null) {
            offlineMapSyncTaskNativeObjectWrapper!!.setMessageSink(this.messageSink)
        }
    }

    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
        if (offlineMapSyncTaskNativeObjectWrapper == null) {
            pendingCalls.add(MethodCall(method, args, result))
        } else {
            offlineMapSyncTaskNativeObjectWrapper!!.onMethodCall(method, args, result)
        }
    }

    private fun loadOfflineMap() {
        val mobileMapPackage = MobileMapPackage(
            offlineMapPath
        )
        mobileMapPackage.loadAsync()
        mobileMapPackage.addDoneLoadingListener {
            if (mobileMapPackage.loadStatus == LoadStatus.LOADED && !mobileMapPackage.maps.isEmpty()) {
                val map = mobileMapPackage.maps[0]
                offlineMapSyncTaskNativeObjectWrapper =
                    OfflineMapSyncTaskNativeObjectWrapper(objectId, OfflineMapSyncTask(map))
                if (messageSink != null) {
                    offlineMapSyncTaskNativeObjectWrapper!!.setMessageSink(messageSink)
                }
                for (methodCall in pendingCalls) {
                    offlineMapSyncTaskNativeObjectWrapper!!.onMethodCall(
                        methodCall.method,
                        methodCall.args,
                        methodCall.result
                    )
                }
                pendingCalls.clear()
            } else {
                var exception = mobileMapPackage.loadError
                if (exception == null) {
                    exception =
                        ArcGISRuntimeException(
                        -1,
                        ArcGISRuntimeException.ErrorDomain.UNKNOWN,
                        "No maps in the package",
                        null,
                        null
                    )
                }
                messageSink!!.send(
                    "offlineMapSyncTask#loadError",
                    ConvertUti.Companion.arcGISRuntimeExceptionToJson(exception)
                )
            }
        }
    }

    private inner class MethodCall(
        val method: String,
        val args: Any,
        val result: MethodChannel.Result
    )

    private inner class OfflineMapSyncTaskNativeObjectWrapper(
        objectId: String,
        task: OfflineMapSyncTask
    ) : BaseNativeObject<OfflineMapSyncTask>(
        objectId, task, arrayOf<NativeHandler>(
            LoadableNativeHandler(task),
        )
    ) {
        override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result) {
            when (method) {
                "offlineMapSyncTask#getUpdateCapabilities" -> {
                    val updateCapabilities = nativeObject.getUpdateCapabilities()
                    if (updateCapabilities != null) {
                        result.success(
                            ConvertOfflineMap.offlineMapUpdateCapabilitiesToJson(
                                updateCapabilities
                            )
                        )
                    } else {
                        result.success(null)
                    }
                }

                "offlineMapSyncTask#checkForUpdates" -> {
                    val future = nativeObject.checkForUpdatesAsync()
                    future.addDoneListener {
                        try {
                            val offlineMapUpdatesInfo = future.get()
                            result.success(
                                ConvertOfflineMap.offlineMapUpdatesInfoToJson(
                                    offlineMapUpdatesInfo
                                )
                            )
                        } catch (e: Exception) {
                            result.error("offlineMapSyncTask#checkForUpdates", e.message, null)
                        }
                    }
                }

                "offlineMapSyncTask#defaultOfflineMapSyncParameters" -> {
                    val future = nativeObject.createDefaultOfflineMapSyncParametersAsync()
                    future.addDoneListener {
                        try {
                            val offlineMapSyncParameters = future.get()
                            result.success(
                                ConvertOfflineMap.offlineMapSyncParametersToJson(
                                    offlineMapSyncParameters
                                )
                            )
                        } catch (e: Exception) {
                            result.error(
                                "offlineMapSyncTask#defaultOfflineMapSyncParameters",
                                e.message,
                                null
                            )
                        }
                    }
                }

                "offlineMapSyncTask#offlineMapSyncJob" -> {
                    createJob(ConvertUti.Companion.toMap(args!!), result)
                }

                else -> super.onMethodCall(method, args, result)
            }
        }

        private fun createJob(data: Map<*, *>, result: MethodChannel.Result) {
            val offlineMapSyncParameters = ConvertOfflineMap.toOfflineMapSyncParameters(data)
            val offlineMapSyncJob = nativeObject.syncOfflineMap(offlineMapSyncParameters)
            val jobId = UUID.randomUUID().toString()
            val jobNativeObject = OfflineMapSyncJobNativeObject(jobId, offlineMapSyncJob)
            jobNativeObject.setMessageSink(messageSink)
            nativeObjectStorage.addNativeObject(jobNativeObject)
            result.success(jobId)
        }
    }
}