package com.valentingrigorean.arcgis_maps_flutter.loadable;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.loadable.LoadStatusChangedEvent;
import com.esri.arcgisruntime.loadable.LoadStatusChangedListener;
import com.esri.arcgisruntime.loadable.Loadable;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler;

import io.flutter.plugin.common.MethodChannel;

public class LoadableNativeHandler extends BaseNativeHandler<Loadable> implements LoadStatusChangedListener {

    public LoadableNativeHandler(Loadable loadable) {
        super(loadable);
        loadable.addLoadStatusChangedListener(this);
    }

    @Override
    protected void disposeInternal() {
        super.disposeInternal();
        getNativeHandler().removeLoadStatusChangedListener(this);
    }

    @Override
    public boolean onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "loadable#getLoadStatus":
                result.success(getNativeHandler().getLoadStatus().ordinal());
                return true;
            case "loadable#getLoadError":
                result.success(Convert.arcGISRuntimeExceptionToJson(getNativeHandler().getLoadError()));
                return true;
            case "loadable#cancelLoad":
                getNativeHandler().cancelLoad();
                result.success(null);
                return true;
            case "loadable#loadAsync":
                getNativeHandler().loadAsync();
                getNativeHandler().addDoneLoadingListener(new DoneListener(result));
                return true;
            case "loadable#retryLoadAsync":
                getNativeHandler().retryLoadAsync();
                getNativeHandler().addDoneLoadingListener(new DoneListener(result));
                return true;
        }
        return false;
    }

    @Override
    public void loadStatusChanged(LoadStatusChangedEvent loadStatusChangedEvent) {
        sendMessage("loadable#loadStatusChanged", loadStatusChangedEvent.getNewLoadStatus().ordinal());
    }

    private class DoneListener implements Runnable {
        private final MethodChannel.Result result;

        private DoneListener(MethodChannel.Result result) {
            this.result = result;
        }

        @Override
        public void run() {
            getNativeHandler().removeDoneLoadingListener(this);
            if (!isDisposed()) {
                result.success(null);
            }
        }
    }
}
