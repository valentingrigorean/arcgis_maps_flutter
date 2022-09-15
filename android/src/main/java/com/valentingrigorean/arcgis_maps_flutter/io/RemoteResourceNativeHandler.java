package com.valentingrigorean.arcgis_maps_flutter.io;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.esri.arcgisruntime.io.RemoteResource;
import com.esri.arcgisruntime.security.Credential;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.BaseNativeHandler;

import io.flutter.plugin.common.MethodChannel;

public class RemoteResourceNativeHandler extends BaseNativeHandler<RemoteResource> {

    public RemoteResourceNativeHandler(RemoteResource remoteResource) {
        super(remoteResource);
    }

    @Override
    public boolean onMethodCall(@NonNull String method, @Nullable Object args, @NonNull MethodChannel.Result result) {
        switch (method) {
            case "remoteResource#getUrl":
                result.success(getNativeHandler().getUri());
                return true;
            case "remoteResource#getCredential":
                final Credential credential = getNativeHandler().getCredential();
                result.success(credential != null ? Convert.credentialToJson(credential) : null);
                return true;
            case "remoteResource#setCredential":
                final Credential credential1 = Convert.toCredentials(args);
                getNativeHandler().setCredential(credential1);
                result.success(null);
                return true;
            default:
                return false;
        }

    }
}
