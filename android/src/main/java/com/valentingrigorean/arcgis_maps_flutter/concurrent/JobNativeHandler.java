package com.valentingrigorean.arcgis_maps_flutter.concurrent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.concurrent.Job;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectController;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink;

import io.flutter.plugin.common.MethodChannel;

public class JobNativeHandler implements ArcgisNativeObjectController.NativeHandler {
    private final Job job;
    private final JobChangedListener jobChangedListener;
    private final ProgressChangedListener progressChangedListener;
    private final JobType jobType;

    private Job.Status status;

    private NativeMessageSink messageSink;

    public JobNativeHandler(Job job, JobType jobType) {
        this.job = job;
        this.jobType = jobType;
        status = job.getStatus();
        jobChangedListener = new JobChangedListener();
        progressChangedListener = new ProgressChangedListener();
        job.addJobChangedListener(jobChangedListener);
        job.addProgressChangedListener(progressChangedListener);
    }

    public enum JobType {
        GENERATE_GOO_DATABASE,
        SYNC_GEO_DATABASE,
        EXPORT_TILE_CACHE,
        ESTIMATE_TILE_CACHE_SIZE,
        GEO_PROCESSING_JOB,
        GENERATE_OFFLINE_MAP,
        OFFLINE_MAP_SYNC,
        DOWNLOAD_PREPLANNED_OFFLINE_MAP_JOB,
    }

    @Override
    public void dispose() {
        job.removeJobChangedListener(jobChangedListener);
        job.removeProgressChangedListener(progressChangedListener);
    }

    @Override
    public void setMessageSink(@Nullable NativeMessageSink messageSink) {
        this.messageSink = messageSink;
    }

    @Override
    public boolean onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "job#getError":
                result.success(Convert.arcGISRuntimeExceptionToJson(job.getError()));
                return true;
            case "job#getJobType":
                result.success(jobType.ordinal());
                return true;
            case "job#serverJobId":
                result.success(job.getServerJobId());
                return true;
            case "job#getStatus":
                result.success(status.ordinal());
                return true;
            case "job#getProgress":
                result.success(job.getProgress() / 100.0);
                return true;
            case "job#start":
                result.success(job.start());
                return true;
            case "job#cancel":
                result.success(job.cancel());
                return true;
            case "job#pause":
                result.success(job.pause());
                return true;
            default:
                return false;
        }
    }

    private class JobChangedListener implements Runnable {
        @Override
        public void run() {

            if (status == job.getStatus()) {
                return;
            }

            status = job.getStatus();

            final NativeMessageSink messageSink = JobNativeHandler.this.messageSink;
            if (messageSink != null) {
                messageSink.send("job#onStatusChanged", job.getStatus().ordinal());
            }
        }
    }

    private class ProgressChangedListener implements Runnable {

        @Override
        public void run() {
            final NativeMessageSink messageSink = JobNativeHandler.this.messageSink;
            if (messageSink != null) {
                messageSink.send("job#onProgressChanged", job.getProgress() / 100.0);
            }
        }
    }
}
