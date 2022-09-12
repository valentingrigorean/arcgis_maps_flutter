part of arcgis_maps_flutter;

@immutable
class AGSPolygon extends Geometry {
  const AGSPolygon._({
    required this.points,
    required this.hasZ,
    required this.hasM,
    SpatialReference? spatialReference,
  }) : super(
          spatialReference: spatialReference,
          geometryType: GeometryType.polygon,
        );

  AGSPolygon({
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

  static AGSPolygon? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final bool hasZ = json['hasZ'] ?? false;
    final bool hasM = json['hasM'] ?? false;

    final List<dynamic> rings = json['rings'];

    final SpatialReference? spatialReference =
        SpatialReference.fromJson(json['spatialReference']);

    return AGSPolygon._(
      points: AGSPoint.fromJsonList(rings, hasZ: hasZ, hasM: hasM),
      hasZ: hasZ,
      hasM: hasM,
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

    if (hasZ) {
      json['hasZ'] = hasZ;
    }
    if (hasM) {
      json['hasM'] = hasM;
    }

    Object pointsToJson() {
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

    addIfPresent('rings', pointsToJson());

    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AGSPolygon &&
          runtimeType == other.runtimeType &&
          hasZ == other.hasZ &&
          hasM == other.hasM &&
          points == other.points;

  @override
  int get hashCode => hasZ.hashCode ^ hasM.hashCode ^ points.hashCode;
}
