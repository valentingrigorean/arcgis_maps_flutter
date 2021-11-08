part of arcgis_maps_flutter;

@immutable
class AGSPolygon extends Geometry {
  const AGSPolygon({
    required this.points,
    SpatialReference? spatialReference,
  }) : super(
          spatialReference: spatialReference,
          geometryType: GeometryType.polygon,
        );

  final List<AGSPoint> points;

  static AGSPolygon? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final bool hasZ = json['hasZ'] ?? false;

    final List<dynamic> rings = json['rings'];

    final SpatialReference? spatialReference =
        SpatialReference.fromJson(json['spatialReference']);

    return AGSPolygon(
      points: AGSPoint.fromJsonList(rings, hasZ),
      spatialReference: spatialReference,
    );
  }

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> json = super.toJson();

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    Object _pointsToJson() {
      final List<Object> result = <Object>[];
      for (final AGSPoint point in points) {
        result.add(point.toJson());
      }
      return result;
    }

    addIfPresent('rings', _pointsToJson());

    return json;
  }
}
