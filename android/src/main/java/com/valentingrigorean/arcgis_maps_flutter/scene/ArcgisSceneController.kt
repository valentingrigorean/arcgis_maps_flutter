package com.valentingrigorean.arcgis_maps_flutter.scene

import android.content.Context
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.arcgismaps.mapping.view.SceneView
import com.esri.arcgisruntime.mapping.view.Camera
import com.esri.arcgisruntime.mapping.view.SceneView
import com.valentingrigorean.arcgis_maps_flutter.Convert
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView

class ArcgisSceneController(
    id: Int,
    context: Context?,
    params: Map<String?, Any?>?,
    binaryMessenger: BinaryMessenger?,
    private val lifecycleProvider: LifecycleProvider
) : DefaultLifecycleObserver, PlatformView, MethodCallHandler {
    private val methodChannel: MethodChannel
    private val sceneController: SceneController
    private var sceneView: SceneView?
    private var disposed = false
    private var camera: Camera

    init {
        methodChannel = MethodChannel(binaryMessenger!!, "plugins.flutter.io/arcgis_scene_$id")
        methodChannel.setMethodCallHandler(this)
        sceneView = SceneView(context)
        sceneController = SceneController()
        sceneController.setSceneView(sceneView)
        if (params == null) {
            return
        }
        sceneController.setScene(params!!["scene"])
        sceneController.setSurface(params["surface"])
        camera = Convert.Companion.toCamera(params["initialCamera"])
        sceneView!!.setViewpointCamera(camera)
    }

    override fun getView(): View? {
        return sceneView
    }

    override fun dispose() {
        if (disposed) {
            return
        }
        disposed = true
        methodChannel.setMethodCallHandler(null)
        destroyMapViewIfNecessary()
        val lifecycle = lifecycleProvider.lifecycle
        lifecycle?.removeObserver(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "sceneView#waitForView" -> result.success(null)
            "sceneView#setScene" -> {
                sceneController.setScene(call.arguments)
                result.success(null)
            }

            "sceneView#setSurface" -> {
                sceneController.setSurface(call.arguments)
                result.success(null)
            }

            "sceneView#setViewpointCamera" -> {
                camera = Convert.Companion.toCamera(call.arguments)
                sceneView!!.setViewpointCamera(camera)
                result.success(null)
            }
        }
    }

    override fun onCreate(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
    }

    override fun onStart(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
    }

    override fun onResume(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
        sceneView!!.resume()
    }

    override fun onPause(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
        sceneView!!.pause()
    }

    override fun onStop(owner: LifecycleOwner) {
        if (disposed) {
            return
        }
    }

    override fun onDestroy(owner: LifecycleOwner) {
        owner.lifecycle.removeObserver(this)
        if (disposed) {
            return
        }
        destroyMapViewIfNecessary()
    }

    private fun destroyMapViewIfNecessary() {
        if (sceneView == null) {
            return
        }
        sceneController.setSceneView(null)
        sceneView!!.dispose()
        sceneView = null
    }
}