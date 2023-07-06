package com.valentingrigorean.arcgis_maps_flutter.authentication

import com.arcgismaps.ArcGISEnvironment
import com.arcgismaps.httpcore.authentication.ArcGISCredentialStore
import com.arcgismaps.httpcore.authentication.NetworkCredential
import com.arcgismaps.httpcore.authentication.PasswordCredential
import com.arcgismaps.httpcore.authentication.TokenCredential
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import java.util.UUID

class ArcGISCredentialStoreController(
    messenger: BinaryMessenger,
    private val scope: CoroutineScope,
) :
    MethodChannel.MethodCallHandler {

    private val channel: MethodChannel =
        MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/credential_store")
    private val tokenCredentials = mutableMapOf<String, TokenCredential>()

    private var store = ArcGISEnvironment.authenticationManager.arcGISCredentialStore

    init {
        channel.setMethodCallHandler(this)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        ArcGISEnvironment.authenticationManager.networkCredentialStore.
        when (call.method) {
            "arcGISCredentialStore#makePersistent" ->{
                scope.launch {
                    ArcGISCredentialStore.createWithPersistence().onSuccess {
                        ArcGISEnvironment.authenticationManager.arcGISCredentialStore = it
                        store = it
                        result.success(null)
                    }.onFailure {
                        result.success(it.toFlutterJson())
                    }
                }
            }
            "arcGISCredentialStore#addCredential" -> {
                scope.launch {
                    val arguments = call.arguments as Map<*, *>
                    TokenCredential.create(
                        arguments["url"] as String,
                        arguments["username"] as String,
                        arguments["password"] as String,
                        arguments["tokenExpirationMinutes"] as Int?
                    ).onSuccess {
                        val uuid = UUID.randomUUID().toString()
                        tokenCredentials[uuid] = it
                        store.add(it)
                        result.success(uuid)
                    }.onFailure {
                        result.success(it.toFlutterJson())
                    }
                }
            }

            "arcGISCredentialStore.removeCredential" -> {
                val arguments = call.arguments as String
                val tokenCredential = tokenCredentials[arguments]
                if (tokenCredential != null) {
                    store.remove(tokenCredential)
                    tokenCredentials.remove(arguments)
                }
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

}