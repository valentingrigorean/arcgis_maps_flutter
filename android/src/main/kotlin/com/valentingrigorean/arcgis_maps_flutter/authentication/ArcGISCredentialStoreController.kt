package com.valentingrigorean.arcgis_maps_flutter.authentication

import android.content.Context
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.ViewModelProvider
import com.arcgismaps.ArcGISEnvironment
import com.arcgismaps.httpcore.authentication.ArcGISAuthenticationChallengeHandler
import com.arcgismaps.httpcore.authentication.ArcGISAuthenticationChallengeResponse
import com.arcgismaps.httpcore.authentication.ArcGISCredential
import com.arcgismaps.httpcore.authentication.ArcGISCredentialStore
import com.arcgismaps.httpcore.authentication.OAuthUserConfiguration
import com.arcgismaps.httpcore.authentication.OAuthUserCredential
import com.arcgismaps.httpcore.authentication.PregeneratedTokenCredential
import com.arcgismaps.httpcore.authentication.TokenCredential
import com.arcgismaps.httpcore.authentication.TokenInfo
import com.arcgismaps.mapping.PortalItem
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
    private val context: Context,
) :
    MethodChannel.MethodCallHandler {

    private val channel: MethodChannel =
        MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/credential_store")
    private val credentials = mutableMapOf<String, ArcGISCredential>()

    private val oAuthConfigurations = mutableListOf<OAuthUserConfiguration>()

    private var store = ArcGISEnvironment.authenticationManager.arcGISCredentialStore

    init {
        channel.setMethodCallHandler(this)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        setUpArcGISAuthenticationChallengeHandler()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
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

            "arcGISCredentialStore#addOAuthCredential" -> {
                val arguments = call.arguments as Map<*, *>
                val oAuthConfiguration = OAuthUserConfiguration(
                    arguments["portalUrl"] as String,
                    arguments["clientId"] as String,
                    arguments["redirectUri"] as String,
                )
                oAuthConfigurations.add(oAuthConfiguration)
                scope.launch {
                    OAuthUserCredential.create(oAuthConfiguration) { oAuthUserSignIn ->
                        OAuthUserSignInActivity.promptForOAuthUserSignIn(context, oAuthUserSignIn)
                    }.onSuccess {
                        val uuid = UUID.randomUUID().toString()
                        credentials[uuid] = it
                        store.add(it)
                        result.success(uuid)
                    }.onFailure {
                        result.success(it.toFlutterJson())
                    }
                }
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


    private fun setUpArcGISAuthenticationChallengeHandler() {
        ArcGISEnvironment.authenticationManager.arcGISAuthenticationChallengeHandler =
            ArcGISAuthenticationChallengeHandler { challenge ->

                for (oAuthConfiguration in oAuthConfigurations) {
                    if (oAuthConfiguration.canBeUsedForUrl(challenge.requestUrl)) {
                        val oAuthUserCredential =
                            OAuthUserCredential.create(oAuthConfiguration) { oAuthUserSignIn ->
                                OAuthUserSignInActivity.promptForOAuthUserSignIn(
                                    context,
                                    oAuthUserSignIn
                                )
                            }.getOrThrow()

                        return@ArcGISAuthenticationChallengeHandler ArcGISAuthenticationChallengeResponse.ContinueWithCredential(
                            oAuthUserCredential
                        )
                    }
                }

                ArcGISAuthenticationChallengeResponse.ContinueAndFailWithError(
                    UnsupportedOperationException()
                )
            }
    }

}