import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/geometry/method_channel_geometry_engine_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class GeometryEngineFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static GeometryEngineFlutterPlatform _instance =
      MethodChannelGeometryEngineFlutter();

  GeometryEngineFlutterPlatform() : super(token: _token);

  static GeometryEngineFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(GeometryEngineFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Projects the given geometry from it's current spatial reference system into the given spatial reference system.
  Future<Geometry?> project(
      Geometry geometry, SpatialReference spatialReference) {
    throw UnimplementedError('project() has not been implemented.');
  }

  Future<GeodeticDistanceResult?> distanceGeodetic({
    required AGSPoint point1,
    required AGSPoint point2,
    required LinearUnitId distanceUnitId,
    required AngularUnitId azimuthUnitId,
    required GeodeticCurveType curveType,
  }) {
    throw UnimplementedError('distanceGeodetic() has not been implemented.');
  }

  Future<AGSPolygon?> bufferGeometry(
      {required Geometry geometry, required double distance}) {
    throw UnimplementedError('bufferGeometry() has not been implemented.');
  }

  Future<AGSPolygon?> geodeticBufferGeometry({
    required Geometry geometry,
    required double distance,
    required LinearUnitId distanceUnit,
    required double maxDeviation,
    required GeodeticCurveType curveType,
  }) {
    throw UnimplementedError(
        'geodeticBufferGeometry() has not been implemented.');
  }

  Future<Geometry?> intersection(Geometry first, Geometry second) {
    throw UnimplementedError('intersections() has not been implemented.');
  }

  Future<List<Geometry>> intersections(Geometry first, Geometry second) {
    throw UnimplementedError('intersections() has not been implemented.');
  }

  Future<bool> contains(Geometry container, Geometry within) {
    throw UnimplementedError('contains() has not been implemented.');
  }

  Future<Geometry?> geodesicSector(GeodesicSectorParameters params) {
    throw UnimplementedError('geodesicSector() has not been implemented.');
  }

  Future<List<AGSPoint>> geodeticMove({
    required List<AGSPoint> points,
    required double distance,
    required LinearUnitId distanceUnit,
    required double azimuth,
    required AngularUnitId azimuthUnit,
    required GeodeticCurveType curveType,
  }) {
    throw UnimplementedError('geodeticMove() has not been implemented.');
  }

  Future<Geometry?> simplify(Geometry geometry) {
    throw UnimplementedError('simplify() has not been implemented.');
  }

  Future<bool> isSimple(Geometry geometry) {
    throw UnimplementedError('isSimple() has not been implemented.');
  }

  Future<Geometry?> densifyGeodetic(
      {required Geometry geometry,
      required double maxSegmentLength,
      required LinearUnitId lengthUnit,
      required GeodeticCurveType curveType}) {
    throw UnimplementedError('densifyGeodetic() has not been implemented.');
  }

  Future<num?> lengthGeodetic(
      {required Geometry geometry,
      required LinearUnitId lengthUnit,
      required GeodeticCurveType curveType}) {
    throw UnimplementedError('lengthGeodetic() has not been implemented.');
  }

  Future<num?> areaGeodetic(
      {required Geometry geometry,
      required AreaUnitId areaUnit,
      required GeodeticCurveType curveType}) {
    throw UnimplementedError('areaGeodetic() has not been implemented.');
  }

  Future<Envelope?> getExtent(Geometry geometry){
    throw UnimplementedError('getExtent() has not been implemented.');
  }
}
