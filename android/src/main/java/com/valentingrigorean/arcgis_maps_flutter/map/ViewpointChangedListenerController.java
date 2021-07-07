package com.valentingrigorean.arcgis_maps_flutter.map;

import com.esri.arcgisruntime.mapping.view.ViewpointChangedEvent;
import com.esri.arcgisruntime.mapping.view.ViewpointChangedListener;

import io.flutter.plugin.common.MethodChannel;

public class ViewpointChangedListenerController implements ViewpointChangedListener {
    private final MethodChannel methodChannel;

    public ViewpointChangedListenerController(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }


    @Override
    public void viewpointChanged(ViewpointChangedEvent viewpointChangedEvent) {
        methodChannel.invokeMethod("map#viewpointChanged", null);
    }
}
