package com.valentingrigorean.arcgis_maps_flutter.concurrent

import com.arcgismaps.tasks.Job
import com.arcgismaps.tasks.JobStatus
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.convert.tasks.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch

class JobNativeHandler<T>(job: Job<T>) :
    BaseNativeHandler<Job<T>>(job) {
    private var status: JobStatus

    init {
        status = job.status.value
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

    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result): Boolean {
        return when (method) {
            "job#getError" -> {
                scope.launch {
                    nativeHandler.checkStatus().onSuccess {
                        result.success(null)
                    }.onFailure {
                        result.success(it.toFlutterJson())
                    }
                }
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