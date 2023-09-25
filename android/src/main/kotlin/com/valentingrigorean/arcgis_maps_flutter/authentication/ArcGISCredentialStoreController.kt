package com.valentingrigorean.arcgis_maps_flutter.authentication

import com.arcgismaps.ArcGISEnvironment
import com.arcgismaps.httpcore.authentication.ArcGISCredential
import com.arcgismaps.httpcore.authentication.ArcGISCredentialStore
import com.arcgismaps.httpcore.authentication.PregeneratedTokenCredential
import com.arcgismaps.httpcore.authentication.TokenCredential
import com.arcgismaps.httpcore.authentication.TokenInfo
import com.valentingrigorean.arcgis_maps_flutter.convert.authentication.toTokenInfoOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterJson
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import java.time.Instant
import java.time.temporal.ChronoUnit
import java.util.UUID

class ArcGISCredentialStoreController(
    messenger: BinaryMessenger,
    private val scope: CoroutineScope,
) :
    MethodChannel.MethodCallHandler {

    private val channel: MethodChannel =
        MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/credential_store")
    private val credentials = mutableMapOf<String, ArcGISCredential>()

    private var store = ArcGISEnvironment.authenticationManager.arcGISCredentialStore

    init {
        channel.setMethodCallHandler(this)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        var accessToken = "xxxxxxx"
        val tokenInfo = TokenInfo(accessToken, Instant.now().plus(2, ChronoUnit.HOURS), true)
        var pregeneratedTokenCredential = PregeneratedTokenCredential("", tokenInfo)
        store.add(pregeneratedTokenCredential)
        when (call.method) {
            "arcGISCredentialStore#makePersistent" -> {
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
                        credentials[uuid] = it
                        store.add(it)
                        result.success(uuid)
                    }.onFailure {
                        result.success(it.toFlutterJson())
                    }
                }
            }

            "arcGISCredentialStore#addPregeneratedTokenCredential" -> {
                val arguments = call.arguments as Map<*, *>
                val tokenInfo = arguments["tokenInfo"]!!.toTokenInfoOrNull()!!
                val token = PregeneratedTokenCredential(
                    arguments["url"] as String,
                    tokenInfo,
                    arguments["referer"] as String
                )
                store.add(token)
                val uuid = UUID.randomUUID().toString()
                credentials[uuid] = token
                result.success(uuid)
            }

            "arcGISCredentialStore.removeCredential" -> {
                val arguments = call.arguments as String
                val tokenCredential = credentials[arguments]
                if (tokenCredential != null) {
                    store.remove(tokenCredential)
                    credentials.remove(arguments)
                }
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

}