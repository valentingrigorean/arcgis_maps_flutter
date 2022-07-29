package com.valentingrigorean.arcgis_maps_flutter.concurrent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.concurrent.Job;
import com.esri.arcgisruntime.data.Geodatabase;
import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseParameters;
import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseSyncTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public class JobNativeHandler extends BaseNativeHandler<Job> {

    private final JobChangedListener jobChangedListener;
    private final ProgressChangedListener progressChangedListener;
    private final JobType jobType;

    private int messageCount;

    private Job.Status status;

    public JobNativeHandler(Job job, JobType jobType) {
        super(job);
        this.jobType = jobType;
        status = job.getStatus();
        messageCount = job.getMessages().size();
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
    protected void disposeInternal() {
        getNativeHandler().removeJobChangedListener(jobChangedListener);
        getNativeHandler().removeProgressChangedListener(progressChangedListener);
        super.disposeInternal();
    }

    @Override
    public boolean onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "job#getError":
                result.success(Convert.arcGISRuntimeExceptionToJson(getNativeHandler().getError()));
                return true;
            case "job#getJobType":
                result.success(jobType.ordinal());
                return true;
            case "job#getMessages":
                final ArrayList<Object> messages = new ArrayList<>();
                for (Job.Message message : getNativeHandler().getMessages()) {
                    messages.add(ConvertConcurrent.jobMessageToJson(message));
                }
                result.success(messages);
                return true;
            case "job#serverJobId":
                result.success(getNativeHandler().getServerJobId());
                return true;
            case "job#getStatus":
                result.success(status.ordinal());
                return true;
            case "job#getProgress":
                result.success(getNativeHandler().getProgress() / 100.0);
                return true;
            case "job#start":
                result.success(getNativeHandler().start());
                return true;
            case "job#cancel":
                result.success(getNativeHandler().cancel());
                return true;
            case "job#pause":
                result.success(getNativeHandler().pause());
                return true;
            default:
                return false;
        }
    }

    private class JobChangedListener implements Runnable {
        @Override
        public void run() {
            checkMessages();
            checkStatus();
        }

        private void checkMessages() {
            final List<Job.Message> messages = getNativeHandler().getMessages();
            if (messageCount == messages.size()) {
                return;
            }
            for (int i = messageCount; i < messages.size(); i++) {
                sendMessage("job#onMessageAdded", ConvertConcurrent.jobMessageToJson(messages.get(i)));
            }
            messageCount = messages.size();
        }

        private void checkStatus() {
            if (status == getNativeHandler().getStatus()) {
                return;
            }
            status = getNativeHandler().getStatus();
            sendMessage("job#onStatusChanged", getNativeHandler().getStatus().ordinal());
        }
    }

    private class ProgressChangedListener implements Runnable {
        @Override
        public void run() {
            sendMessage("job#onProgressChanged", getNativeHandler().getProgress() / 100.0);
        }
    }
}
