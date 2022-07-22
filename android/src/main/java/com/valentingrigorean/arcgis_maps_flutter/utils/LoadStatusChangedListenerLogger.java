package com.valentingrigorean.arcgis_maps_flutter.utils;

import android.util.Log;

import com.esri.arcgisruntime.loadable.LoadStatus;
import com.esri.arcgisruntime.loadable.LoadStatusChangedEvent;
import com.esri.arcgisruntime.loadable.LoadStatusChangedListener;
import com.esri.arcgisruntime.loadable.Loadable;

public class LoadStatusChangedListenerLogger implements LoadStatusChangedListener {
    private final String tag;
    private final Loadable loadable;
    private final boolean autoDetach;

    public LoadStatusChangedListenerLogger(String tag, Loadable loadable) {
        this(tag, loadable, true);
    }

    public LoadStatusChangedListenerLogger(String tag, Loadable loadable, boolean autoDetach) {
        this.tag = tag;
        this.loadable = loadable;
        this.autoDetach = autoDetach;
    }

    @Override
    public void loadStatusChanged(LoadStatusChangedEvent loadStatusChangedEvent) {
        Log.d(tag, "loadStatusChanged: " + loadStatusChangedEvent.getNewLoadStatus().name());

        if (loadStatusChangedEvent.getNewLoadStatus() == LoadStatus.FAILED_TO_LOAD) {
            Log.e(tag, "loadStatusChanged: " + loadable.getLoadError().getMessage());
            if (loadable.getLoadError().getCause() != null) {
                Log.e(tag, "loadStatusChanged: " + loadable.getLoadError().getCause().getMessage());
            }
        }

        if ((loadStatusChangedEvent.getNewLoadStatus() == LoadStatus.LOADED || loadStatusChangedEvent.getNewLoadStatus() == LoadStatus.FAILED_TO_LOAD) && autoDetach) {
            detach();
        }
    }

    public LoadStatusChangedListenerLogger attach() {
        loadable.addLoadStatusChangedListener(this);
        return this;
    }

    public LoadStatusChangedListenerLogger detach() {
        loadable.removeLoadStatusChangedListener(this);
        return this;
    }
}
