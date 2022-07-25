package com.valentingrigorean.arcgis_maps_flutter.loadable;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.loadable.LoadStatusChangedEvent;
import com.esri.arcgisruntime.loadable.LoadStatusChangedListener;
import com.esri.arcgisruntime.loadable.Loadable;
import com.valentingrigorean.arcgis_maps_flutter.flutter.ArcgisNativeObjectController;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutter.NativeMessageSink;

import io.flutter.plugin.common.MethodChannel;

public class LoadableNativeObject implements ArcgisNativeObjectController.NativeHandler, LoadStatusChangedListener {

    private final Loadable loadable;
    private NativeMessageSink messageSink;
    private boolean disposed = false;

    public LoadableNativeObject(Loadable loadable) {
        this.loadable = loadable;
        this.loadable.addLoadStatusChangedListener(this);
    }

    @Override
    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        loadable.removeLoadStatusChangedListener(this);
    }

    @Override
    public void setMessageSink(@Nullable NativeMessageSink messageSink) {
        this.messageSink = messageSink;
    }

    @Override
    public boolean onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "loadable#getLoadStatus":
                result.success(loadable.getLoadStatus().ordinal());
                return true;
            case "loadable#getLoadError":
                result.success(Convert.arcGISRuntimeExceptionToJson(loadable.getLoadError()));
                return true;
            case "loadable#cancelLoad":
                loadable.cancelLoad();
                result.success(null);
                return true;
            case "loadable#loadAsync":
                loadable.loadAsync();
                loadable.addDoneLoadingListener(new DoneListener(result));
                return true;
            case "loadable#retryLoadAsync":
                loadable.retryLoadAsync();
                loadable.addDoneLoadingListener(new DoneListener(result));
                return true;
        }
        return false;
    }

    @Override
    public void loadStatusChanged(LoadStatusChangedEvent loadStatusChangedEvent) {
        final NativeMessageSink messageSink = this.messageSink;
        if (messageSink == null) {
            return;
        }
        messageSink.send("loadable#loadStatusChanged", loadStatusChangedEvent.getNewLoadStatus().ordinal());
    }

    private class DoneListener implements Runnable {
        private final MethodChannel.Result result;

        private DoneListener(MethodChannel.Result result) {
            this.result = result;
        }

        @Override
        public void run() {
            loadable.removeDoneLoadingListener(this);
            if (!disposed) {
                result.success(null);
            }
        }
    }
}
