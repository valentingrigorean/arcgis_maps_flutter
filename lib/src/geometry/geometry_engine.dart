part of arcgis_maps_flutter;

class GeometryEngine {
  GeometryEngine._();

  /// Projects the given geometry from it's current spatial reference
  /// system into the given spatial reference system.
  ///
  static Future<Geometry?> project(Geometry geometry, SpatialReference target) {
    return GeometryEngineFlutterPlatform.instance.project(geometry, target);
  }

  /// Projects the given geometry from it's current spatial reference
  /// system into the given spatial reference system.
  ///
  static Future<T?> projectAs<T extends Geometry>(
      T geometry, SpatialReference target) async {
    final result =
        await GeometryEngineFlutterPlatform.instance.project(geometry, target);
    if (result == null) {
      return null;
    }
    return result as T?;
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

  /// Constructs the set-theoretic intersection between two geometries.
  /// Supports true curves.
  static Future<Geometry?> intersection(Geometry first, Geometry second) {
    return GeometryEngineFlutterPlatform.instance.intersection(first, second);
  }

  /// Calculates the intersection of two geometries.
  /// The returned array contains one geometry of each dimension for which there are intersections. For example,
  /// if both inputs are polylines, the array will contain at most two geometries: the first a multipoint containing the
  /// points at which the lines cross, and the second a polyline containing the lines of overlap. If a crossing point lies
  /// within a line of overlap, only the line of overlap is present -- the result set is not self-intersecting. If there are no
  /// crossing points or there are no lines of overlap, the respective geometry will not be present in the returned
  /// array. If the input geometries do not intersect, the resulting array will be empty. The table below shows, for each
  /// combination of pairs of input geometry types, the types of geometry that will be contained within the returned array if there are
  /// intersections of that type.
  /// Set of potential output geometry types for pairs of input geometry types
  /// Input type          Point/Multipoint    Polyline                Polygon/Envelope
  /// Point/Multipoint    Multipoint          Multipoint              Multipoint
  /// Polyline            Multipoint          Multipoint, Polyline    Multipoint, Polyline
  /// Polygon/Envelope    Multipoint          Multipoint, Polyline    Multipoint, Polyline,Polygon
  /// The geometries in the returned array are sorted by ascending dimensionality,
  /// e.g. multipoint (dimension 0) then polyline (dimension 1) then polygon
  /// (dimension 2) for the intersection of two geometries with area that have
  /// intersections of those types. Returns @c nil on error. Supports true curves.
  static Future<List<Geometry>> intersections(Geometry first, Geometry second) {
    return GeometryEngineFlutterPlatform.instance.intersections(first, second);
  }

  /// Return true if [container] contains [within].
  static Future<bool> contains(Geometry container, Geometry within) {
    return GeometryEngineFlutterPlatform.instance.contains(container, within);
  }

  /// Constructs a geodesic sector defined by a geodesic arc and 2 radii.
  /// The arc is a portion of an ellipse that is centered on a specified point
  /// and is defined by it's 2 axes and the length of it's longest axis.
  /// The first radius angle is defined by the startDirection angle and the
  /// second radius angle is the sum of the startDirection and the sectorAngle. T
  /// he sector is constructed as a [AGSPolygon], [AGSPolyline] or [AGSMultipoint] geometry.
  /// [params] Specifies the parameters for constructing the sector.
  /// Returns The sector is returned in the format specified by the geometryType
  /// and is generalized according to the arcVertexCount and the radiusVertexCount parameters.
  static Future<Geometry?> geodesicSector(GeodesicSectorParameters params) {
    return GeometryEngineFlutterPlatform.instance.geodesicSector(params);
  }

  /// Moves each point in the point collection by a geodesic distance.
  /// There must be the same spatial reference on each point in the input array of points.
  /// The returned array is in the same order as the input, but with new points at their destination locations.
  /// Specifying a negative distance moves points in the opposite direction from azimuth.
  static Future<List<AGSPoint>> geodeticMove({
    required List<AGSPoint> points,
    required double distance,
    required LinearUnitId distanceUnit,
    required double azimuth,
    required AngularUnitId azimuthUnit,
    required GeodeticCurveType curveType,
  }) {
    return GeometryEngineFlutterPlatform.instance.geodeticMove(
      points: points,
      distance: distance,
      distanceUnit: distanceUnit,
      azimuth: azimuth,
      azimuthUnit: azimuthUnit,
      curveType: curveType,
    );
  }

  /// Simplifies the given geometry to make it topologically consistent according to its geometry type. For instance, it rectifies polygons that may be self-intersecting, or contain incorrect ring orientations.
  /// Many of the methods in the geometry engine only work on geometry that is simple, and only simple geometries can be stored in a geodatabase.
  ///
  /// Supports true curves.
  static Future<Geometry?> simplify(Geometry geometry) {
    return GeometryEngineFlutterPlatform.instance.simplify(geometry);
  }

  /// Indicates if this Geometry is topologically simple (in other words, is topologically correct).
  /// [AGSPoint] geometries are always simple.
  ///
  /// [AGSMultipoint] geometries cannot have any points with exactly equal x and y values.
  ///
  /// [AGSPolyline]  can have no degenerate segments.
  ///
  /// For [AGSPolygon], the following must be true for the polygon to be considered simple:
  ///
  /// - Exterior rings must be clockwise, and holes must be counterclockwise.
  /// - Rings can touch other rings only at a finite number of vertices.
  /// - Rings can be self tangent only at a finite number of vertices.
  /// - Segments with a length less than zero are not allowed.
  /// - Each path must contain at least three non-coincident vertices.
  /// Paths must not be empty.
  ///
  /// Returns true by default if geometry is null or error occurs.
  static Future<bool> isSimple(Geometry geometry) {
    return GeometryEngineFlutterPlatform.instance.isSimple(geometry);
  }
}
