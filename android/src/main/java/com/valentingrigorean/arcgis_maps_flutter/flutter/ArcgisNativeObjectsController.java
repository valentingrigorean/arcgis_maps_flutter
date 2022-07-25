package com.valentingrigorean.arcgis_maps_flutter.flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ArcgisNativeObjectsController implements MethodChannel.MethodCallHandler, NativeMessageSink {
    private final MethodChannel channel;
    private final ArcgisNativeObjectFactory factory;
    private Map<Integer, ArcgisNativeObjectController> nativeObjects = new HashMap<>();

    public ArcgisNativeObjectsController(BinaryMessenger messenger, ArcgisNativeObjectFactory factory) {
        this.channel = new MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/native_objects");
        this.factory = factory;
    }

    @Override
    public void send(@NonNull String method, @Nullable Object args) {
        channel.invokeMethod(method, args);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "createNativeObject": {
                final Map<?, ?> args = call.arguments();
                final int objectId = (int) args.get("objectId");
                final String type = (String) args.get("type");
                final Object arguments = args.get("arguments");
                final ArcgisNativeObjectController nativeObject = factory.createNativeObject(objectId, type, arguments, this);
                nativeObject.setMessageSink(this);
                nativeObjects.put(objectId, nativeObject);
                result.success(null);
            }
            break;
            case "destroyNativeObject": {
                final int objectId = call.arguments();
                final ArcgisNativeObjectController nativeObject = nativeObjects.get(objectId);
                if (nativeObject != null) {
                    nativeObject.setMessageSink(null);
                    nativeObject.dispose();
                    nativeObjects.remove(objectId);
                }
                result.success(null);
            }
            break;
            case "sendMessage": {
                final Map<?, ?> args = call.arguments();
                final int objectId = (int) args.get("objectId");
                final String method = (String) args.get("method");
                final Object arguments = args.get("arguments");
                final ArcgisNativeObjectController nativeObject = nativeObjects.get(objectId);
                if (nativeObject != null) {
                    nativeObject.onMethodCall(method, arguments, result);
                } else {
                    result.error("object_not_found", "Native object not found", null);
                }
            }
            default:
                result.notImplemented();
                break;
        }
    }


}
