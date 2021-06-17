import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class ScenePage extends StatefulWidget {
  @override
  _ScenePageState createState() => _ScenePageState();
}

class _ScenePageState extends State<ScenePage> {
  ArcGISScene _scene = ArcGISScene.fromBasemap(Basemap.createImagery());
  Surface _surface = Surface(
      surfaceId: SurfaceId("my_surface"),
      elevationSources: <ElevationSource>{
        ArcGISTiledElevationSource(
            elevationSourceId: ElevationSourceId("my_elevation"),
            url:
                "https://elevation3d.arcgis.com/arcgis/rest/services/WorldElevation3D/Terrain3D/ImageServer")
      },
      elevationExaggeration: 2.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scene 3d"),
      ),
      body: ArcgisSceneView(
        scene: _scene,
        surface: _surface,
        initialCamera: Camera.fromPoint(
            Point(
                x: -118.794,
                y: 33.909,
                z: 5330.0,
                spatialReference: SpatialReference.wgs84()),
            355.0,
            72.0,
            0),
      ),
    );
  }
}
