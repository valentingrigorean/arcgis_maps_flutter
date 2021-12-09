part of arcgis_maps_flutter;

class GeometryEngine {
  GeometryEngine._();

  static Future<Geometry?> project(Geometry geometry, SpatialReference target) {
    return GeometryEngineFlutterPlatform.instance.project(geometry, target);
  }

  static Future<GeodeticDistanceResult?> distanceGeodetic({
    required AGSPoint point1,
    required AGSPoint point2,
    required LinearUnitId distanceUnitId,
    required AngularUnitId azimuthUnitId,
    required GeodeticCurveType curveType,
  }) async {
    return GeometryEngineFlutterPlatform.instance.distanceGeodetic(
      point1: point1,
      point2: point2,
      distanceUnitId: distanceUnitId,
      azimuthUnitId: azimuthUnitId,
      curveType: curveType,
    );
  }
}
