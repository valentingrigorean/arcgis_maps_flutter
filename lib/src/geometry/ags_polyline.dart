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

    final bool hasZ = json['hasZ'];

    final List<dynamic> nativePaths = json['paths'];
    final List<Point> points = [];

    for (final path in nativePaths) {
      for (final point in path) {
        final double x = point[0];
        final double y = point[1];
        final double? z = hasZ ? toDoubleNullable(point[2]) : null;
        points.add(Point(x: x, y: y, z: z));
      }
    }

    final SpatialReference? spatialReference =
        SpatialReference.fromJson(json['spatialReference']);

    return AGSPolyline(
      points: points,
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
