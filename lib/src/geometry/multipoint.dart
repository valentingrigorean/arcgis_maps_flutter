part of arcgis_maps_flutter;

@immutable
class Multipoint extends Geometry {
  const Multipoint._({
    required this.points,
    SpatialReference? spatialReference,
  }) : super(
    spatialReference: spatialReference,
    geometryType: GeometryType.multipoint,
  );

  const Multipoint({
    required List<Point> points,
    SpatialReference? spatialReference,
  }) : this._(points: points, spatialReference: spatialReference);

  final List<Point> points;

  static Multipoint? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final List<dynamic> points = json['points'];

    final SpatialReference? spatialReference =
    SpatialReference.fromJson(json['spatialReference']);

    var validPoints =
    points.where((element) => (element as List<dynamic>?)?.length == 2);

    return Multipoint._(
      points: validPoints
          .map((e) => Point(x: toDoubleSafe(e[0]), y: toDoubleSafe(e[1])))
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

    List<List<double>> pointsToJson() {
      List<List<double>> pointsResult = [];
      for (var point in points) {
        pointsResult.add([point.x, point.y]);
      }
      return pointsResult;
    }

    addIfPresent('points', pointsToJson());
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Multipoint &&
              runtimeType == other.runtimeType &&
              points == other.points;

  @override
  int get hashCode => points.hashCode;
}
