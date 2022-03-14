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
}
