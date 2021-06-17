package com.valentingrigorean.arcgis_maps_flutter.scene;

import android.content.Context;

import com.valentingrigorean.arcgis_maps_flutter.LifecycleProvider;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class ArcgisSceneViewFactory extends PlatformViewFactory {

    private final BinaryMessenger binaryMessenger;
    private final LifecycleProvider lifecycleProvider;

    public ArcgisSceneViewFactory(BinaryMessenger binaryMessenger, LifecycleProvider lifecycleProvider) {
        super(StandardMessageCodec.INSTANCE);
        this.binaryMessenger = binaryMessenger;
        this.lifecycleProvider = lifecycleProvider;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new ArcgisSceneController(viewId, context, params, binaryMessenger, lifecycleProvider);
    }
}
