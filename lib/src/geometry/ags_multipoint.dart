part of arcgis_maps_flutter;

@immutable
class AGSMultipoint extends Geometry {
  const AGSMultipoint._({
    required this.points,
    SpatialReference? spatialReference,
  }) : super(
    spatialReference: spatialReference,
    geometryType: GeometryType.multipoint,
  );

  const AGSMultipoint({
    required List<AGSPoint> points,
    SpatialReference? spatialReference,
  }) : this._(points: points, spatialReference: spatialReference);

  final List<AGSPoint> points;

  static AGSMultipoint? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final List<dynamic> points = json['points'];

    final SpatialReference? spatialReference =
    SpatialReference.fromJson(json['spatialReference']);

    var validPoints =
    points.where((element) => (element as List<dynamic>?)?.length == 2);

    return AGSMultipoint._(
      points: validPoints
          .map((e) => AGSPoint(x: toDoubleSafe(e[0]), y: toDoubleSafe(e[1])))
          .toList(),
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

    List<List<double>> _pointsToJson() {
      List<List<double>> pointsResult = [];
      for (var point in points) {
        pointsResult.add([point.x, point.y]);
      }
      return pointsResult;
    }

    addIfPresent('points', _pointsToJson());
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AGSMultipoint &&
              runtimeType == other.runtimeType &&
              points == other.points;

  @override
  int get hashCode => points.hashCode;
}
