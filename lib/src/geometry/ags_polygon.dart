part of arcgis_maps_flutter;

@immutable
class AGSPolygon extends Geometry {
  final bool? _hasZ;
  final bool? _hasM;

  const AGSPolygon._({
    required this.points,
    bool? hasZ,
    bool? hasM,
    SpatialReference? spatialReference,
  })  : _hasZ = hasZ,
        _hasM = hasM,
        super(
          spatialReference: spatialReference,
          geometryType: GeometryType.polygon,
        );

  const AGSPolygon({
    required List<List<AGSPoint>> points,
    SpatialReference? spatialReference,
  }) : this._(
          points: points,
          spatialReference: spatialReference,
          hasZ: false,
          hasM: false,
        );

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

    final hasZ = _hasZ ?? points.any((p) => p.any((e) => e.z != null));
    final hasM = _hasM ?? points.any((p) => p.any((e) => e.m != null));

    if(hasZ){
      json['hasZ'] = hasZ;
    }
    if(hasM){
      json['hasM'] = hasM;
    }

    Object _pointsToJson() {
      final results = <List<Object>>[];
      for(final part in points) {
        final List<Object> pointsRaw = <Object>[];
        for (final AGSPoint point in part) {
          pointsRaw.add(pointToList(point, hasZ: hasZ, hasM: hasM));
        }
        results.add(pointsRaw);
      }
      return results;
    }

    addIfPresent('rings', _pointsToJson());

    return json;
  }
}
