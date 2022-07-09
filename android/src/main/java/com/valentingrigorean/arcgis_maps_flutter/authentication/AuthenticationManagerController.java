package com.valentingrigorean.arcgis_maps_flutter.authentication;

import android.content.Context;

import androidx.annotation.NonNull;


import com.esri.arcgisruntime.security.CredentialCacheEntry;
import com.esri.arcgisruntime.security.SharedPreferencesCredentialPersistence;
import com.esri.arcgisruntime.security.UserCredential;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class AuthenticationManagerController implements MethodChannel.MethodCallHandler {
    private static final String TAG = "AuthenticationManagerController";
    private final MethodChannel channel;
    private Context context;
    public AuthenticationManagerController(BinaryMessenger messenger, Context context) {
        channel = new MethodChannel(messenger, "plugins.flutter.io/authentication_manager");
        channel.setMethodCallHandler(this);
        this.context = context;
    }


    public void dispose() {
        channel.setMethodCallHandler(null);
        context = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "setPersistence":
                final Map<?, ?> data = Convert.toMap(call.arguments);
                SharedPreferencesCredentialPersistence spp = new SharedPreferencesCredentialPersistence(context);
                UserCredential userCredential = new UserCredential( (String)data.get("username"), (String) data.get("password"));
                spp.add(new CredentialCacheEntry(
                        (String) data.get("serviceContext"),
                        userCredential
                ));
                 result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}