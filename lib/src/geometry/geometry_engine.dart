part of arcgis_maps_flutter;

class GeometryEngine {
  GeometryEngine._();

  static Future<Geometry?> project(Geometry geometry, SpatialReference target) {
    return GeometryEngineFlutterPlatform.instance.project(geometry, target);
  }
}
