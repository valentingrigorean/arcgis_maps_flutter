package com.valentingrigorean.arcgis_maps_flutter.concurrent

import com.arcgismaps.tasks.Job
import com.arcgismaps.tasks.JobStatus
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

class JobNativeHandler<T>(job: Job<T>, private val jobType: JobType) :
    BaseNativeHandler<Job<T>>(job) {
    private var messageCount: Int
    private var status: JobStatus

    init {
        status = job.status.value
        messageCount = job.messages.replayCache.size
        nativeHandler.messages
            .onEach { message ->
                // Perform any action you want to do with the message here
                // You can send the message to the Flutter side using the sendMessage method
                sendMessage("job#onMessageAdded", message.toFlutterJson())
            }
            .launchIn(scope)

        nativeHandler.progress
            .onEach { progress ->
                // Perform any action you want to do with the progress here
                // You can send the progress to the Flutter side using the sendMessage method
                sendMessage("job#onProgressChanged", progress)
            }
            .launchIn(scope)

        nativeHandler.status
            .onEach { status ->
                // Perform any action you want to do with the status here
                // You can send the status to the Flutter side using the sendMessage method
                sendMessage("job#onStatusChanged", status.toFlutterValue())
            }
            .launchIn(scope)
    }

    enum class JobType {
        GENERATE_GEODATABASE, SYNC_GEO_DATABASE, EXPORT_TILE_CACHE, ESTIMATE_TILE_CACHE_SIZE, GEO_PROCESSING_JOB, GENERATE_OFFLINE_MAP, OFFLINE_MAP_SYNC, DOWNLOAD_PREPLANNED_OFFLINE_MAP_JOB
    }


    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result): Boolean {
        return when (method) {
            "job#getJobType" -> {
                result.success(jobType.ordinal)
                true
            }

            "job#getMessages" -> {
                result.success(nativeHandler.messages.replayCache.map { it.toFlutterJson() })
                true
            }

            "job#serverJobId" -> {
                result.success(nativeHandler.serverJobId)
                true
            }

            "job#getStatus" -> {
                result.success(status.toFlutterValue())
                true
            }

            "job#getProgress" -> {
                result.success(nativeHandler.progress.value / 100.0)
                true
            }

            "job#start" -> {
                result.success(nativeHandler.start())
                true
            }

            "job#cancel" -> {
                scope.launch {
                    nativeHandler.cancel().onSuccess {
                        result.success(true)
                    }.onFailure {
                        result.error(
                            "JobNativeHandler",
                            "Failed to cancel job",
                            it.localizedMessage
                        )
                    }
                }

                true
            }

            "job#pause" -> {
                result.success(nativeHandler.pause())
                true
            }

            else -> false
        }
    }
}