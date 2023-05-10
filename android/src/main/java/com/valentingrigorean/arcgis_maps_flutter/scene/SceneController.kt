package com.valentingrigorean.arcgis_maps_flutter.scene

import com.arcgismaps.mapping.ArcGISScene
import com.arcgismaps.mapping.Surface
import com.arcgismaps.mapping.view.SceneView

import com.valentingrigorean.arcgis_maps_flutter.Convert

class SceneController {
    private var sceneView: SceneView? = null
    private var scene: ArcGISScene? = null
    private var surface: Surface? = null
    fun setSceneView(sceneView: SceneView?) {
        this.sceneView = sceneView
    }

//    fun setScene(json: Any?) {
//        if (json == null) {
//            return
//        }
//        scene = Convert.Companion.toScene(json)
//        if (surface != null) {
//            scene!!.baseSurface = surface
//        }
//        sceneView!!.scene = scene
//    }
//
//    fun setSurface(json: Any?) {
//        if (json == null) {
//            return
//        }
//        surface = Convert.Companion.toSurface(json)
//        if (scene != null) {
//            scene!!.baseSurface = surface
//        }
//    }
}