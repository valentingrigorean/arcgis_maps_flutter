import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/arcgis_method_channel.dart';
import 'package:arcgis_maps_flutter/src/method_channel/geometry/geometry_engine_flutter_platform.dart';
import 'package:flutter/services.dart';

class MethodChannelGeometryEngineFlutter extends GeometryEngineFlutterPlatform {
  final MethodChannel _channel = const ArcgisMethodChannel(
      "plugins.flutter.io/arcgis_channel/geometry_engine");

  @override
  Future<Geometry?> project(
      Geometry geometry, SpatialReference spatialReference) async {
    final result = await _channel.invokeMethod("project", {
      "geometry": geometry.toJson(),
      "spatialReference": spatialReference.toJson(),
    });
    if (result == null) {
      return null;
    }
    return Geometry.fromJson(result);
  }

  @override
  Future<GeodeticDistanceResult?> distanceGeodetic({
    required Point point1,
    required Point point2,
    required LinearUnitId distanceUnitId,
    required AngularUnitId azimuthUnitId,
    required GeodeticCurveType curveType,
  }) async {
    final result = await _channel.invokeMethod("distanceGeodetic", {
      "point1": point1.toJson(),
      "point2": point2.toJson(),
      "distanceUnitId": distanceUnitId.value,
      "azimuthUnitId": azimuthUnitId.value,
      "curveType": curveType.value,
    });
    if (result == null) {
      return null;
    }
    return GeodeticDistanceResult.fromJson(result);
  }

  @override
  Future<Polygon?> bufferGeometry({
    required Geometry geometry,
    required double distance,
  }) {
    return _channel.invokeMethod("bufferGeometry", {
      "geometry": geometry.toJson(),
      "distance": distance,
    }).then((result) {
      if (result == null) {
        return null;
      }
      return Polygon.fromJson(result);
    });
  }

  @override
  Future<Polygon?> geodeticBufferGeometry({
    required Geometry geometry,
    required double distance,
    required LinearUnitId distanceUnit,
    required double maxDeviation,
    required GeodeticCurveType curveType,
  }) {
    return _channel.invokeMethod("geodeticBufferGeometry", {
      "geometry": geometry.toJson(),
      "distance": distance,
      "distanceUnit": distanceUnit.value,
      "maxDeviation": maxDeviation,
      "curveType": curveType.value,
    }).then((result) {
      if (result == null) {
        return null;
      }
      return Polygon.fromJson(result);
    });
  }

  @override
  Future<Geometry?> intersection(Geometry first, Geometry second) async {
    var result = await _channel.invokeMethod("intersection", {
      "firstGeometry": first.toJson(),
      "secondGeometry": second.toJson(),
    });
    return Geometry.fromJson(result);
  }

  @override
  Future<List<Geometry>> intersections(Geometry first, Geometry second) async {
    var result = await _channel.invokeMethod("intersections", {
      "firstGeometry": first.toJson(),
      "secondGeometry": second.toJson(),
    });
    if (result == null) {
      return [];
    }
    List<dynamic> list = result;
    List<Geometry> geometryList = [];
    for (var json in list) {
      Geometry? geometry = Geometry.fromJson(json);
      if (geometry != null) {
        geometryList.add(geometry);
      }
    }
    return geometryList;
  }

  @override
  Future<bool> contains(Geometry container, Geometry within) async {
    final result = await _channel.invokeMethod<bool>(
      "contains",
      {
        "containerGeometry": container.toJson(),
        "withinGeometry": within.toJson(),
      },
    );
    return result ?? false;
  }

  @override
  Future<Geometry?> geodesicSector(GeodesicSectorParameters params) async {
    final result =
        await _channel.invokeMethod("geodesicSector", params.toJson());
    return Geometry.fromJson(result);
  }

  @override
  Future<List<Point>> geodeticMove({
    required List<Point> points,
    required double distance,
    required LinearUnitId distanceUnit,
    required double azimuth,
    required AngularUnitId azimuthUnit,
    required GeodeticCurveType curveType,
  }) async {
    final result = await _channel.invokeMethod("geodeticMove", {
      "points": points.map((e) => e.toJson()).toList(),
      "distance": distance,
      "distanceUnit": distanceUnit.value,
      "azimuth": azimuth,
      "azimuthUnit": azimuthUnit.value,
      "curveType": curveType.value,
    });
    if (result == null) {
      return const [];
    }
    List<Point> pointList = [];
    for (var json in result) {
      Point? point = Point.fromJson(json);
      if (point != null) {
        pointList.add(point);
      }
    }
    return pointList;
  }

  @override
  Future<Geometry?> simplify(Geometry geometry) async {
    final result = await _channel.invokeMethod("simplify", geometry.toJson());
    return Geometry.fromJson(result);
  }

  @override
  Future<bool> isSimple(Geometry geometry) async {
    final result = await _channel.invokeMethod("isSimple", geometry.toJson());
    return result ?? true;
  }

  @override
  Future<Geometry?> densifyGeodetic({
    required Geometry geometry,
    required double maxSegmentLength,
    required LinearUnitId lengthUnit,
    required GeodeticCurveType curveType,
  }) async {
    final result = await _channel.invokeMethod("densifyGeodetic", {
      "geometry": geometry.toJson(),
      "maxSegmentLength": maxSegmentLength,
      "lengthUnit": lengthUnit.value,
      "curveType": curveType.value
    });
    return Geometry.fromJson(result);
  }

  @override
  Future<num?> lengthGeodetic({
    required Geometry geometry,
    required LinearUnitId lengthUnit,
    required GeodeticCurveType curveType,
  }) async {
    final result = await _channel.invokeMethod("lengthGeodetic", {
      "geometry": geometry.toJson(),
      "lengthUnit": lengthUnit.value,
      "curveType": curveType.value
    });

    return result;
  }

  @override
  Future<num?> areaGeodetic({
    required Geometry geometry,
    required AreaUnitId areaUnit,
    required GeodeticCurveType curveType,
  }) async {
    final result = await _channel.invokeMethod("areaGeodetic", {
      "geometry": geometry.toJson(),
      "areaUnit": areaUnit.value,
      "curveType": curveType.value
    });

    return result;
  }

  @override
  Future<Envelope?> getExtent(Geometry geometry) async {
    final extent = await _channel
        .invokeMethod("getExtent", {"geometry": geometry.toJson()});
    Envelope? result;
    if (extent is Envelope) {
      result = extent;
    }
    return result;
  }
}
