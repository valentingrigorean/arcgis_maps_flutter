package com.valentingrigorean.arcgis_maps_flutter.flutterobject;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ArcgisNativeObjectsController implements MethodChannel.MethodCallHandler {
    private final MethodChannel channel;
    private final ArcgisNativeObjectFactory factory;
    private final MessageSink messageSink;
    private final NativeObjectStorage storage;

    public ArcgisNativeObjectsController(BinaryMessenger messenger, ArcgisNativeObjectFactory factory) {
        this.channel = new MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/native_objects");
        this.factory = factory;
        this.messageSink = new MessageSink(channel);
        channel.setMethodCallHandler(this);
        storage = NativeObjectStorage.getInstance();
    }

    public interface NativeObjectControllerMessageSink extends NativeMessageSink {

    }

    public void dispose() {
        channel.setMethodCallHandler(null);
        storage.clearAll();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "createNativeObject": {
                final Map<?, ?> args = call.arguments();
                final String objectId = (String) args.get("objectId");
                final String type = (String) args.get("type");
                final Object arguments = args.get("arguments");
                final ArcgisNativeObjectController nativeObject = factory.createNativeObject(objectId, type, arguments, messageSink);
                storage.addNativeObject(nativeObject);
                result.success(null);
            }
            break;
            case "destroyNativeObject": {
                final String objectId = call.arguments();
                storage.removeNativeObject(objectId);
                result.success(null);
            }
            break;
            case "sendMessage": {
                final Map<?, ?> args = call.arguments();
                final String objectId = (String) args.get("objectId");
                final String method = (String) args.get("method");
                final Object arguments = args.get("arguments");
                final ArcgisNativeObjectController nativeObject = storage.getNativeObject(objectId);
                if (nativeObject != null) {
                    nativeObject.onMethodCall(method, arguments, result);
                } else {
                    result.error("object_not_found", "Native object not found", null);
                }
            }
            break;
            default:
                result.notImplemented();
                break;
        }
    }

    private static class MessageSink implements NativeObjectControllerMessageSink {
        private final MethodChannel channel;

        private MessageSink(MethodChannel channel) {
            this.channel = channel;
        }

        @Override
        public void send(@NonNull String method, @Nullable Object args) {
            channel.invokeMethod(method, args);
        }
    }
}
