package com.valentingrigorean.arcgis_maps_flutter.scene;

import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import com.esri.arcgisruntime.mapping.view.Camera;
import com.esri.arcgisruntime.mapping.view.SceneView;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.LifecycleProvider;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class ArcgisSceneController implements DefaultLifecycleObserver, PlatformView, MethodChannel.MethodCallHandler {


    private final LifecycleProvider lifecycleProvider;
    private final MethodChannel methodChannel;

    private final SceneController sceneController;

    @Nullable
    private SceneView sceneView;

    private boolean disposed;

    private Camera camera;

    public ArcgisSceneController(int id, Context context, Map<String, Object> params, BinaryMessenger binaryMessenger, LifecycleProvider lifecycleProvider) {

        this.lifecycleProvider = lifecycleProvider;
        methodChannel = new MethodChannel(binaryMessenger, "plugins.flutter.io/arcgis_scene_" + id);
        methodChannel.setMethodCallHandler(this);

        sceneView = new SceneView(context);
        sceneController = new SceneController();
        sceneController.setSceneView(sceneView);

        if (params == null) {
            return;
        }

        sceneController.setScene(params.get("scene"));
        sceneController.setSurface(params.get("surface"));

        camera = Convert.toCamera(params.get("initialCamera"));
        sceneView.setViewpointCamera(camera);
    }

    @Override
    public View getView() {
        return sceneView;
    }

    @Override
    public void dispose() {
        if (disposed) {
            return;
        }

        disposed = true;
        methodChannel.setMethodCallHandler(null);
        destroyMapViewIfNecessary();

        Lifecycle lifecycle = lifecycleProvider.getLifecycle();
        if (lifecycle != null) {
            lifecycle.removeObserver(this);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "sceneView#waitForView":
                result.success(null);
                break;
            case "sceneView#setScene":
                sceneController.setScene(call.arguments);
                result.success(null);
                break;
            case "sceneView#setSurface":
                sceneController.setSurface(call.arguments);
                result.success(null);
                break;
            case "sceneView#setViewpointCamera":
                camera = Convert.toCamera(call.arguments);
                sceneView.setViewpointCamera(camera);
                result.success(null);
                break;
        }
    }

    @Override
    public void onCreate(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onStart(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
        sceneView.resume();
    }

    @Override
    public void onPause(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
        sceneView.pause();
    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
        if (disposed) {
            return;
        }
    }

    @Override
    public void onDestroy(@NonNull LifecycleOwner owner) {
        owner.getLifecycle().removeObserver(this);
        if (disposed) {
            return;
        }
        destroyMapViewIfNecessary();
    }

    private void destroyMapViewIfNecessary() {
        if (sceneView == null) {
            return;
        }
        sceneController.setSceneView(null);
        sceneView.dispose();
        sceneView = null;
    }

}
