part of arcgis_maps_flutter;

@immutable
class AGSMultipoint extends Geometry {

  const AGSMultipoint._({
    required this.points,
    required this.hasZ,
    required this.hasM,
    SpatialReference? spatialReference,
  }) : super(
    spatialReference: spatialReference,
    geometryType: GeometryType.multipoint,
  );

  AGSMultipoint({
    required List<List<AGSPoint>> points,
    SpatialReference? spatialReference,
  }) : this._(
    points: points,
    spatialReference: spatialReference,
    hasZ: points.any((e) => e.any((i) => i.hasZ)),
    hasM: points.any((e) => e.any((i) => i.hasM)),
  );

  final bool hasZ;
  final bool hasM;

  final List<List<AGSPoint>> points;

  static AGSMultipoint? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final bool hasZ = json['hasZ'] ?? false;
    final bool hasM = json['hasM'] ?? false;

    final List<dynamic> paths = json['points'];

    final SpatialReference? spatialReference =
    SpatialReference.fromJson(json['spatialReference']);

    return AGSMultipoint._(
      points: AGSPoint.fromJsonList(paths, hasZ: hasZ, hasM: hasM),
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

    Object _pointsToJson() {
      final results = <List<Object>>[];
      for (final part in points) {
        final List<Object> pointsRaw = <Object>[];
        for (final AGSPoint point in part) {
          pointsRaw.add(pointToList(point, hasZ: hasZ, hasM: hasM));
        }
        results.add(pointsRaw);
      }
      return results;
    }

    addIfPresent('points', _pointsToJson());
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AGSMultipoint &&
              runtimeType == other.runtimeType &&
              hasZ == other.hasZ &&
              hasM == other.hasM &&
              points == other.points;

  @override
  int get hashCode => hasZ.hashCode ^ hasM.hashCode ^ points.hashCode;
}
