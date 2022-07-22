part of arcgis_maps_flutter;

// ignore_for_file: library_private_types_in_public_api
class ArcgisSceneController {
  // ignore: unused_field
  final _ArcgisSceneViewState _arcgisSceneViewState;
  final int sceneId;

  ArcgisSceneController._(this._arcgisSceneViewState, this.sceneId);

  static Future<ArcgisSceneController> init(
      int id, _ArcgisSceneViewState arcgisSceneViewState) async {
    await ArcgisMapsFlutterPlatform.instance.init(id);
    return ArcgisSceneController._(arcgisSceneViewState, id);
  }

  Future<void> setScene(ArcGISScene scene) {
    return ArcgisSceneFlutterPlatform.instance.setScene(sceneId, scene);
  }

  Future<void> setSurface(Surface surface) {
    return ArcgisSceneFlutterPlatform.instance.setSurface(sceneId, surface);
  }

  Future<void> setViewpointCamera(Camera camera) {
    return ArcgisSceneFlutterPlatform.instance
        .setViewpointCamera(sceneId, camera);
  }
}
