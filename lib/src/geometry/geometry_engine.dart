part of arcgis_maps_flutter;

class GeometryEngine {
  GeometryEngine._();

  /// Projects the given geometry from it's current spatial reference
  /// system into the given spatial reference system.
  ///
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

  /// Returns a geometry object that represents a buffer
  /// relative to the given geometry.
  ///  Planar measurements of distance and area can be extremely inaccurate if
  ///  using an unsuitable spatial reference.Ensure that you understand
  ///  the potential for error with the geometry's spatial reference.
  ///  If you need to calculate more accurate results consider
  ///  using a different spatial reference, or using the geodetic equivalent,
  ///  [geodeticBufferGeometry]
  ///  Supports true curves as input, producing a densified curve as output where applicable
  ///  [geometry] Specifies the input geometry.
  ///  [distance] The distance (in the unit of the geometry's spatial reference)
  ///  by which to buffer the geometry.
  static Future<AGSPolygon?> bufferGeometry({
    required Geometry geometry,
    required double distance,
  }) {
    return GeometryEngineFlutterPlatform.instance.bufferGeometry(
      geometry: geometry,
      distance: distance,
    );
  }

  /// Creates a buffer polygon at the specified distance around the given geometry.
  /// Geodesic buffers account for the actual shape of the Earth.
  /// Distances are calculated between points on a curved surface (the geoid) as opposed to points on a flat
  /// surface (the Cartesian plane).
  /// Negative distance can be used to create buffers inside polygons.
  /// Using a negative buffer distance will shrink polygons' boundaries by the distance specified.
  /// Note that if the negative buffer distance is large enough, polygons may collapse to empty geometries.
  /// [geometry] The input geometry.
  /// [distance] The distance by which to buffer the geometry.
  /// [distanceUnit] The distance by which to buffer the geometry.
  /// [maxDeviation] the maximum distance that the generalized buffer geometry
  /// can deviate from the original one, specified in the units of [distanceUnit].
  /// Can be [double.nan] for default behavior, or must be a value between 0.001 and 0.5*abs [distance].
  /// [curveType] The type of geodetic curve. [GeodeticCurveType.shapePreserving]
  /// is a good option for most cases.
  static Future<AGSPolygon?> geodeticBufferGeometry({
    required Geometry geometry,
    required double distance,
    required LinearUnitId distanceUnit,
    required double maxDeviation,
    required GeodeticCurveType curveType,
  }) {
    return GeometryEngineFlutterPlatform.instance.geodeticBufferGeometry(
      geometry: geometry,
      distance: distance,
      distanceUnit: distanceUnit,
      maxDeviation: maxDeviation,
      curveType: curveType,
    );
  }
}
