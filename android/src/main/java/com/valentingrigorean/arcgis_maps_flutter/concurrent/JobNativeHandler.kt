package com.valentingrigorean.arcgis_maps_flutter.concurrent

import com.esri.arcgisruntime.concurrent.Job
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler
import io.flutter.plugin.common.MethodChannel

class JobNativeHandler(job: Job, private val jobType: JobType) : BaseNativeHandler<Job?>(job) {
    private val jobChangedListener: JobChangedListener
    private val progressChangedListener: ProgressChangedListener
    private var messageCount: Int
    private var status: Job.Status

    init {
        status = job.status
        messageCount = job.messages.size
        jobChangedListener = JobChangedListener()
        progressChangedListener = ProgressChangedListener()
        job.addJobChangedListener(jobChangedListener)
        job.addProgressChangedListener(progressChangedListener)
    }

    enum class JobType {
        GENERATE_GEODATABASE, SYNC_GEO_DATABASE, EXPORT_TILE_CACHE, ESTIMATE_TILE_CACHE_SIZE, GEO_PROCESSING_JOB, GENERATE_OFFLINE_MAP, OFFLINE_MAP_SYNC, DOWNLOAD_PREPLANNED_OFFLINE_MAP_JOB
    }

    override fun disposeInternal() {
        nativeHandler.removeJobChangedListener(jobChangedListener)
        nativeHandler.removeProgressChangedListener(progressChangedListener)
        super.disposeInternal()
    }

    override fun onMethodCall(method: String, args: Any?, result: MethodChannel.Result): Boolean {
        return when (method) {
            "job#getError" -> {
                result.success(
                    Convert.Companion.arcGISRuntimeExceptionToJson(
                        nativeHandler.getError()
                    )
                )
                true
            }

            "job#getJobType" -> {
                result.success(jobType.ordinal)
                true
            }

            "job#getMessages" -> {
                val messages = ArrayList<Any?>()
                for (message in nativeHandler.getMessages()) {
                    messages.add(ConvertConcurrent.jobMessageToJson(message))
                }
                result.success(messages)
                true
            }

            "job#serverJobId" -> {
                result.success(nativeHandler.getServerJobId())
                true
            }

            "job#getStatus" -> {
                result.success(status.ordinal)
                true
            }

            "job#getProgress" -> {
                result.success(nativeHandler.getProgress() / 100.0)
                true
            }

            "job#start" -> {
                result.success(nativeHandler.start())
                true
            }

            "job#cancel" -> {
                result.success(nativeHandler.cancel())
                true
            }

            "job#pause" -> {
                result.success(nativeHandler.pause())
                true
            }

            else -> false
        }
    }

    private inner class JobChangedListener : Runnable {
        override fun run() {
            checkMessages()
            checkStatus()
        }

        private fun checkMessages() {
            val messages = nativeHandler.getMessages()
            if (messageCount == messages.size) {
                return
            }
            for (i in messageCount until messages.size) {
                sendMessage("job#onMessageAdded", ConvertConcurrent.jobMessageToJson(messages[i]))
            }
            messageCount = messages.size
        }

        private fun checkStatus() {
            if (status == nativeHandler.getStatus()) {
                return
            }
            status = nativeHandler.getStatus()
            sendMessage("job#onStatusChanged", nativeHandler.getStatus().ordinal)
        }
    }

    private inner class ProgressChangedListener : Runnable {
        override fun run() {
            sendMessage("job#onProgressChanged", nativeHandler.getProgress() / 100.0)
        }
    }
}