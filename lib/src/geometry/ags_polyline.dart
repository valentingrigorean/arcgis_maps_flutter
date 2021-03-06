part of arcgis_maps_flutter;

class AGSPolyline implements Geometry {
  AGSPolyline({
    required this.points,
    this.spatialReference,
  });

  final List<Point> points;

  final SpatialReference? spatialReference;

  static AGSPolyline? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final bool hasZ = json['hasZ'] ?? false;

    final List<dynamic> paths = json['paths'];

    final SpatialReference? spatialReference =
        SpatialReference.fromJson(json['spatialReference']);

    return AGSPolyline(
      points: Point.fromJsonList(paths, hasZ),
      spatialReference: spatialReference,
    );
  }

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    Object _pointsToJson() {
      final List<Object> result = <Object>[];
      for (final Point point in points) {
        result.add(point.toJson());
      }
      return result;
    }

    addIfPresent('paths', _pointsToJson());
    addIfPresent('spatialReference', spatialReference?.toJson());

    return Object();
  }
}
