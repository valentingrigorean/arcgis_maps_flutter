part of arcgis_maps_flutter;

@immutable
class AGSPolyline extends Geometry {

  const AGSPolyline({
    required this.points,
    SpatialReference? spatialReference,
  }) : super(
          spatialReference: spatialReference,
          geometryType: GeometryType.polyline,
        );

  final List<AGSPoint> points;

  static AGSPolyline? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final bool hasZ = json['hasZ'] ?? false;

    final List<dynamic> paths = json['paths'];

    final SpatialReference? spatialReference =
        SpatialReference.fromJson(json['spatialReference']);

    return AGSPolyline(
      points: AGSPoint.fromJsonList(paths, hasZ),
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

    addIfPresent('paths', _pointsToJson());
    return json;
  }
}
