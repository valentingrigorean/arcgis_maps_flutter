import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/geometry/geometry_engine_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/utils/json.dart';
import 'package:flutter/services.dart';

class MethodChannelGeometryEngineFlutter extends GeometryEngineFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel("plugins.flutter.io/geometry_engine");

  @override
  Future<Geometry?> project(
      Geometry geometry, SpatialReference spatialReference) async {
    final result = await  _channel.invokeMethod("project", {
      "geometry": geometry.toJson(),
      "spatialReference": spatialReference.toJson(),
    });
    if(result == null){
      return null;
    }
    return Geometry.fromJson(toSafeMapNullable(result));
  }
}
