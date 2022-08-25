package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.ArcGISRuntimeException;
import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.loadable.LoadStatus;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.esri.arcgisruntime.mapping.MobileMapPackage;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncJob;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncParameters;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncTask;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapUpdateCapabilities;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapUpdatesInfo;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeMessageSink;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeObject;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.NativeObjectMessageSink;
import com.valentingrigorean.arcgis_maps_flutter.io.RemoteResourceNativeHandler;
import com.valentingrigorean.arcgis_maps_flutter.loadable.LoadableNativeHandler;

import java.util.ArrayList;
import java.util.Map;
import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;

public class OfflineMapSyncTaskNativeObject implements NativeObject {
    private final ArrayList<MethodCall> pendingCalls = new ArrayList<>();
    private final String objectId;
    private final String offlineMapPath;
    private boolean isDisposed;
    private OfflineMapSyncTaskNativeObjectWrapper offlineMapSyncTaskNativeObjectWrapper;
    private NativeMessageSink messageSink;

    public OfflineMapSyncTaskNativeObject(String objectId, String offlineMapPath) {
        this.objectId = objectId;
        this.offlineMapPath = offlineMapPath;
        loadOfflineMap();
    }

    @Override
    public String getObjectId() {
        return objectId;
    }

    @Override
    public void dispose() {
        if (isDisposed) {
            return;
        }
        isDisposed = true;
        if (offlineMapSyncTaskNativeObjectWrapper != null) {
            offlineMapSyncTaskNativeObjectWrapper.dispose();
        }
        offlineMapSyncTaskNativeObjectWrapper = null;
    }

    @Override
    public void setMessageSink(@Nullable NativeMessageSink messageSink) {
        this.messageSink = new NativeObjectMessageSink(objectId, messageSink);
        if (offlineMapSyncTaskNativeObjectWrapper != null) {
            offlineMapSyncTaskNativeObjectWrapper.setMessageSink(this.messageSink);
        }
    }

    @Override
    public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        if (offlineMapSyncTaskNativeObjectWrapper == null) {
            pendingCalls.add(new MethodCall(method, args, result));
        } else {
            offlineMapSyncTaskNativeObjectWrapper.onMethodCall(method, args, result);
        }
    }

    private void loadOfflineMap() {
        final MobileMapPackage mobileMapPackage = new MobileMapPackage(offlineMapPath);
        mobileMapPackage.loadAsync();
        mobileMapPackage.addDoneLoadingListener(() -> {
            if (mobileMapPackage.getLoadStatus() == LoadStatus.LOADED && !mobileMapPackage.getMaps().isEmpty()) {
                final ArcGISMap map = mobileMapPackage.getMaps().get(0);
                offlineMapSyncTaskNativeObjectWrapper = new OfflineMapSyncTaskNativeObjectWrapper(objectId, new OfflineMapSyncTask(map));
                if (messageSink != null) {
                    offlineMapSyncTaskNativeObjectWrapper.setMessageSink(messageSink);
                }
                for (MethodCall methodCall : pendingCalls) {
                    offlineMapSyncTaskNativeObjectWrapper.onMethodCall(methodCall.method, methodCall.args, methodCall.result);
                }
                pendingCalls.clear();
            } else {
                ArcGISRuntimeException exception = mobileMapPackage.getLoadError();
                if (exception == null) {
                    exception = new ArcGISRuntimeException(-1, ArcGISRuntimeException.ErrorDomain.UNKNOWN, "No maps in the package", null, null);
                }

                messageSink.send("offlineMapSyncTask#loadError", Convert.arcGISRuntimeExceptionToJson(exception));
            }
        });
    }


    private class MethodCall {
        private final String method;
        private final Object args;
        private final MethodChannel.Result result;

        public MethodCall(String method, Object args, MethodChannel.Result result) {
            this.method = method;
            this.args = args;
            this.result = result;
        }
    }

    private class OfflineMapSyncTaskNativeObjectWrapper extends BaseNativeObject<OfflineMapSyncTask> {

        protected OfflineMapSyncTaskNativeObjectWrapper(String objectId, OfflineMapSyncTask task) {
            super(objectId, task, new NativeHandler[]{
                    new LoadableNativeHandler(task),
                    new RemoteResourceNativeHandler(task),
            });
        }

        @Override
        public void onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
            switch (method) {
                case "offlineMapSyncTask#getUpdateCapabilities": {
                    final OfflineMapUpdateCapabilities updateCapabilities = getNativeObject().getUpdateCapabilities();
                    if (updateCapabilities != null) {
                        result.success(ConvertOfflineMap.offlineMapUpdateCapabilitiesToJson(updateCapabilities));
                    } else {
                        result.success(null);
                    }
                }
                break;
                case "offlineMapSyncTask#checkForUpdates": {
                    final ListenableFuture<OfflineMapUpdatesInfo> future = getNativeObject().checkForUpdatesAsync();
                    future.addDoneListener(() -> {
                        try {
                            final OfflineMapUpdatesInfo offlineMapUpdatesInfo = future.get();
                            result.success(ConvertOfflineMap.offlineMapUpdatesInfoToJson(offlineMapUpdatesInfo));
                        } catch (Exception e) {
                            result.error("offlineMapSyncTask#checkForUpdates", e.getMessage(), null);
                        }
                    });
                }
                break;
                case "offlineMapSyncTask#defaultOfflineMapSyncParameters": {
                    final ListenableFuture<OfflineMapSyncParameters> future = getNativeObject().createDefaultOfflineMapSyncParametersAsync();
                    future.addDoneListener(() -> {
                        try {
                            final OfflineMapSyncParameters offlineMapSyncParameters = future.get();
                            result.success(ConvertOfflineMap.offlineMapSyncParametersToJson(offlineMapSyncParameters));
                        } catch (Exception e) {
                            result.error("offlineMapSyncTask#defaultOfflineMapSyncParameters", e.getMessage(), null);
                        }
                    });
                }
                break;
                case "offlineMapSyncTask#offlineMapSyncJob": {
                    createJob(Convert.toMap(args), result);
                }
                break;
                default:
                    super.onMethodCall(method, args, result);
                    break;
            }
        }

        private void createJob(Map<?, ?> data, MethodChannel.Result result) {
            final OfflineMapSyncParameters offlineMapSyncParameters = ConvertOfflineMap.toOfflineMapSyncParameters(data);
            final OfflineMapSyncJob offlineMapSyncJob = getNativeObject().syncOfflineMap(offlineMapSyncParameters);
            final String jobId = UUID.randomUUID().toString();
            final OfflineMapSyncJobNativeObject jobNativeObject = new OfflineMapSyncJobNativeObject(jobId, offlineMapSyncJob);
            jobNativeObject.setMessageSink(getMessageSink());
            getNativeObjectStorage().addNativeObject(jobNativeObject);
            result.success(jobId);
        }
    }
}
