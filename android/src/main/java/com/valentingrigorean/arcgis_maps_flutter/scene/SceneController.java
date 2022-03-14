package com.valentingrigorean.arcgis_maps_flutter.scene;

import com.esri.arcgisruntime.mapping.ArcGISScene;
import com.esri.arcgisruntime.mapping.Surface;
import com.esri.arcgisruntime.mapping.view.SceneView;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

public class SceneController {
    private SceneView sceneView;

    private ArcGISScene scene;

    private Surface surface;

    public void setSceneView(SceneView sceneView) {

        this.sceneView = sceneView;
    }

    public void setScene(Object json) {
        if (json == null) {
            return;
        }

        scene = Convert.toScene(json);
        if (surface != null) {
            scene.setBaseSurface(surface);
        }

        sceneView.setScene(scene);
    }

    public void setSurface(Object json) {
        if (json == null) {
            return;
        }
        surface = Convert.toSurface(json);
        if (scene != null) {
            scene.setBaseSurface(surface);
        }
    }
}
