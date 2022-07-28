package com.valentingrigorean.arcgis_maps_flutter.io;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.ApiKeyResource;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler;

import io.flutter.plugin.common.MethodChannel;

public class ApiKeyResourceNativeHandler extends BaseNativeHandler<ApiKeyResource> {

    public ApiKeyResourceNativeHandler(ApiKeyResource apiKeyResource) {
        super(apiKeyResource);
    }

    @Override
    public boolean onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "apiKeyResource#getApiKey":
                result.success(getNativeHandler().getApiKey());
                return true;
            case "apiKeyResource#setApiKey":
                getNativeHandler().setApiKey((String) args);
                result.success(null);
                return true;
            default:
                return false;
        }
    }
}
