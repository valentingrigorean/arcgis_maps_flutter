part of arcgis_maps_flutter;

class AGSPolygon implements Geometry {
  AGSPolygon({
    required this.points,
    this.spatialReference,
  });

  final List<Point> points;

  final SpatialReference? spatialReference;

  static AGSPolygon? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final bool hasZ = json['hasZ'] ?? false;

    final List<dynamic> rings = json['rings'];

    final SpatialReference? spatialReference =
        SpatialReference.fromJson(json['spatialReference']);

    return AGSPolygon(
      points: Point.fromJsonList(rings, hasZ),
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

    addIfPresent('rings', _pointsToJson());
    addIfPresent('spatialReference', spatialReference?.toJson());

    return Object();
  }
}
