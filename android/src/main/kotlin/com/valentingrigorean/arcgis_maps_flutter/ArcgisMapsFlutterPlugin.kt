package com.valentingrigorean.arcgis_maps_flutter

import android.util.Log
import androidx.lifecycle.Lifecycle
import com.arcgismaps.ApiKey
import com.arcgismaps.ArcGISEnvironment
import com.arcgismaps.LicenseKey
import com.arcgismaps.LicenseStatus
import com.valentingrigorean.arcgis_maps_flutter.authentication.ArcGISCredentialStoreController
import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectFactoryImpl
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController
import com.valentingrigorean.arcgis_maps_flutter.geometry.CoordinateFormatterController
import com.valentingrigorean.arcgis_maps_flutter.geometry.GeometryEngineController
import com.valentingrigorean.arcgis_maps_flutter.map.ArcgisMapFactory
import com.valentingrigorean.arcgis_maps_flutter.scene.ArcgisSceneViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel

/**
 * ArcgisMapsFlutterPlugin
 */
class ArcgisMapsFlutterPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {
    private var geometryEngineController: GeometryEngineController? = null
    private var coordinateFormatterController: CoordinateFormatterController? = null
    private var nativeObjectsController: ArcgisNativeObjectsController? = null
    private var arcGISCredentialStoreController: ArcGISCredentialStoreController? = null
    private var scope: CoroutineScope? = null

    private lateinit var channel: MethodChannel
    private var lifecycle: Lifecycle? = null
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        scope = CoroutineScope(Dispatchers.Main)
        ArcGISEnvironment.applicationContext = binding.applicationContext
        binding.platformViewRegistry
            .registerViewFactory(
                VIEW_TYPE_MAP,
                ArcgisMapFactory(binding.binaryMessenger) { lifecycle!! })
        binding.platformViewRegistry
            .registerViewFactory(
                VIEW_TYPE_SCENE,
                ArcgisSceneViewFactory(binding.binaryMessenger) { lifecycle!! })
        channel = MethodChannel(binding.binaryMessenger, "plugins.flutter.io/arcgis_channel")
        channel.setMethodCallHandler(this)
        geometryEngineController = GeometryEngineController(binding.binaryMessenger)
        coordinateFormatterController = CoordinateFormatterController(binding.binaryMessenger)
        nativeObjectsController = ArcgisNativeObjectsController(
            binding.binaryMessenger,
            ArcgisNativeObjectFactoryImpl(scope!!),
        )
        arcGISCredentialStoreController =
            ArcGISCredentialStoreController(binding.binaryMessenger, scope!!)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        ArcGISEnvironment.applicationContext = null
        channel.setMethodCallHandler(null)
        scope?.cancel()
        scope = null
        geometryEngineController?.dispose()
        geometryEngineController = null
        coordinateFormatterController?.dispose()
        coordinateFormatterController = null
        nativeObjectsController?.dispose()
        nativeObjectsController = null
        arcGISCredentialStoreController?.dispose()
        arcGISCredentialStoreController = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
    }

    override fun onDetachedFromActivity() {
        lifecycle = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "arcgis#setApiKey" -> {
                val apiKey = call.arguments<String>()!!
                ArcGISEnvironment.apiKey = ApiKey.create(apiKey)
                Log.d(TAG, "setApiKey: $apiKey")
                result.success(null)
            }

            "arcgis#getApiKey" -> result.success(ArcGISEnvironment.apiKey?.toString())
            "arcgis#setLicense" -> {
                val licenseKey = call.arguments<String>()!!
                val licenseResult = ArcGISEnvironment.setLicense(LicenseKey.create(licenseKey)!!)
                Log.d(TAG, "setLicense: $licenseKey")
                Log.d(TAG, "licenseResult: " + licenseResult?.licenseStatus)
                val licenseStatus = licenseResult?.licenseStatus
                result.success(
                    licenseStatus?.toFlutterValue() ?: LicenseStatus.Invalid.toFlutterValue()
                )
            }

            "arcgis#getApiVersion" -> result.success(ArcGISEnvironment.apiVersion)
            else -> {
                result.notImplemented()
            }
        }
    }

    companion object {
        const val TAG = "ArcgisMapsFlutterPlugin"
        private const val VIEW_TYPE_MAP = "plugins.flutter.io/arcgis_maps"
        private const val VIEW_TYPE_SCENE = "plugins.flutter.io/arcgis_scene"
    }
}