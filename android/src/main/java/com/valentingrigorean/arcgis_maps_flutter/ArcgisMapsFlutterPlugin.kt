package com.valentingrigorean.arcgis_maps_flutter

import android.util.Log
import androidx.lifecycle.Lifecycle
import com.esri.arcgisruntime.ArcGISRuntimeEnvironment
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectFactoryImpl
import com.valentingrigorean.arcgis_maps_flutter.flutterobject.ArcgisNativeObjectsController
import com.valentingrigorean.arcgis_maps_flutter.geometry.CoordinateFormatterController
import com.valentingrigorean.arcgis_maps_flutter.geometry.GeometryEngineController
import com.valentingrigorean.arcgis_maps_flutter.map.ArcgisMapFactory
import com.valentingrigorean.arcgis_maps_flutter.scene.ArcgisSceneViewFactory
import com.valentingrigorean.arcgis_maps_flutter.service_table.ServiceTableController
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * ArcgisMapsFlutterPlugin
 */
class ArcgisMapsFlutterPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {
    private var geometryEngineController: GeometryEngineController? = null
    private var coordinateFormatterController: CoordinateFormatterController? = null
    private var nativeObjectsController: ArcgisNativeObjectsController? = null
    private var channel: MethodChannel? = null
    private var serviceTableController: ServiceTableController? = null
    private var lifecycle: Lifecycle? = null
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        binding.platformViewRegistry
            .registerViewFactory(
                VIEW_TYPE_MAP,
                ArcgisMapFactory(binding.binaryMessenger) { lifecycle })
        binding.platformViewRegistry
            .registerViewFactory(
                VIEW_TYPE_SCENE,
                ArcgisSceneViewFactory(binding.binaryMessenger) { lifecycle })
        channel = MethodChannel(binding.binaryMessenger, "plugins.flutter.io/arcgis_channel")
        channel!!.setMethodCallHandler(this)
        geometryEngineController = GeometryEngineController(binding.binaryMessenger)
        coordinateFormatterController = CoordinateFormatterController(binding.binaryMessenger)
        nativeObjectsController = ArcgisNativeObjectsController(
            binding.binaryMessenger,
            ArcgisNativeObjectFactoryImpl(binding.applicationContext)
        )
        serviceTableController = ServiceTableController(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
        geometryEngineController!!.dispose()
        geometryEngineController = null
        coordinateFormatterController!!.dispose()
        coordinateFormatterController = null
        nativeObjectsController!!.dispose()
        nativeObjectsController = null
        serviceTableController!!.dispose()
        serviceTableController = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        lifecycle = getActivityLifecycle(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        lifecycle = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "arcgis#setApiKey" -> {
                val apiKey = call.arguments<String>()
                ArcGISRuntimeEnvironment.setApiKey(apiKey)
                Log.d(TAG, "setApiKey: $apiKey")
                result.success(null)
            }

            "arcgis#getApiKey" -> result.success(ArcGISRuntimeEnvironment.getApiKey())
            "arcgis#setLicense" -> {
                val licenseKey = call.arguments<String>()
                val licenseResult = ArcGISRuntimeEnvironment.setLicense(licenseKey)
                Log.d(TAG, "setLicense: $licenseKey")
                Log.d(TAG, "licenseResult: " + licenseResult.licenseStatus)
                result.success(licenseResult.licenseStatus.ordinal)
            }

            "arcgis#getApiVersion" -> result.success(ArcGISRuntimeEnvironment.getAPIVersion())
        }
    }

    companion object {
        const val TAG = "ArcgisMapsFlutterPlugin"
        private const val VIEW_TYPE_MAP = "plugins.flutter.io/arcgis_maps"
        private const val VIEW_TYPE_SCENE = "plugins.flutter.io/arcgis_scene"
        private fun getActivityLifecycle(
            activityPluginBinding: ActivityPluginBinding
        ): Lifecycle {
            val reference = activityPluginBinding.lifecycle as HiddenLifecycleReference
            return reference.lifecycle
        }
    }
}