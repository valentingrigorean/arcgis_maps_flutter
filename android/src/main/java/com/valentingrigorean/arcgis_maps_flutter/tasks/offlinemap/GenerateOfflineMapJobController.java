package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap;

import androidx.annotation.NonNull;

import com.esri.arcgisruntime.concurrent.Job;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapJob;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class GenerateOfflineMapJobController implements MethodChannel.MethodCallHandler {
    private final MethodChannel channel;
    private final GenerateOfflineMapJob offlineMapJob;
    private final Runnable onProgressChangedRunnable;
    private final Runnable onJobChangedRunnable;
    private Job.Status status = Job.Status.NOT_STARTED;

    public GenerateOfflineMapJobController(BinaryMessenger messenger, int id, GenerateOfflineMapJob offlineMapJob) {
        this.channel = new MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/offline_map_task/job_" + id);
        this.offlineMapJob = offlineMapJob;
        channel.setMethodCallHandler(this);
        onProgressChangedRunnable = () -> {
            channel.invokeMethod("onProgressChanged", offlineMapJob.getProgress() / 100);
        };
        onJobChangedRunnable = () -> {
            final Job.Status jobStatus = offlineMapJob.getStatus();
            if (jobStatus != status) {
                status = jobStatus;
                channel.invokeMethod("onStatusChanged", status.ordinal());
            }
        };
        offlineMapJob.addProgressChangedListener(onProgressChangedRunnable);
        offlineMapJob.addJobChangedListener(onJobChangedRunnable);
    }

    public void dispose() {
        offlineMapJob.removeProgressChangedListener(onProgressChangedRunnable);
        offlineMapJob.removeJobChangedListener(onJobChangedRunnable);
        channel.setMethodCallHandler(null);
    }

    @Override
    protected void finalize() throws Throwable {
        dispose();
        super.finalize();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getJobProgress":
                result.success(offlineMapJob.getProgress() / 100);
                break;
            case "getJobStatus":
                result.success(offlineMapJob.getStatus().ordinal());
                break;
            case "startJob":
                offlineMapJob.start();
                break;
            case "cancelJob":
                result.success(offlineMapJob.cancel());
                break;
            case "pauseJob":
                result.success(offlineMapJob.pause());
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
