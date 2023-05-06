part of arcgis_maps_flutter;

@immutable
class Polyline extends Geometry {

  const Polyline._({
    required this.points,
    required this.hasZ,
    required this.hasM,
    SpatialReference? spatialReference,
  }) : super(
    spatialReference: spatialReference,
    geometryType: GeometryType.polyline,
  );

  Polyline({
    required List<List<Point>> points,
    SpatialReference? spatialReference,
  }) : this._(
    points: points,
    spatialReference: spatialReference,
    hasZ: points.any((e) => e.any((i) => i.hasZ)),
    hasM: points.any((e) => e.any((i) => i.hasM)),
  );

  final bool hasZ;
  final bool hasM;

  final List<List<Point>> points;

  static Polyline? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final bool hasZ = json['hasZ'] ?? false;
    final bool hasM = json['hasM'] ?? false;

    final List<dynamic> paths = json['paths'];

    final SpatialReference? spatialReference =
    SpatialReference.fromJson(json['spatialReference']);

    return Polyline._(
      points: Point.fromJsonList(paths, hasZ: hasZ, hasM: hasM),
      hasZ: hasZ,
      hasM: hasM,
      spatialReference: spatialReference,
    );
  }

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> json = super.toJson();

    if (hasZ) {
      json['hasZ'] = hasZ;
    }
    if (hasM) {
      json['hasM'] = hasM;
    }

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    Object pointsToJson() {
      final results = <List<Object>>[];
      for (final part in points) {
        final List<Object> pointsRaw = <Object>[];
        for (final Point point in part) {
          pointsRaw.add(pointToList(point, hasZ: hasZ, hasM: hasM));
        }
        results.add(pointsRaw);
      }
      return results;
    }

    addIfPresent('paths', pointsToJson());
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Polyline &&
          runtimeType == other.runtimeType &&
          hasZ == other.hasZ &&
          hasM == other.hasM &&
          points == other.points;

  @override
  int get hashCode => hasZ.hashCode ^ hasM.hashCode ^ points.hashCode;
}
