part of arcgis_maps_flutter;

@immutable
class AGSPolyline extends Geometry {
  final bool? _hasZ;
  final bool? _hasM;

  const AGSPolyline._({
    required this.points,
    bool? hasZ,
    bool? hasM,
    SpatialReference? spatialReference,
  })  : _hasZ = hasZ,
        _hasM = hasM,
        super(
          spatialReference: spatialReference,
          geometryType: GeometryType.polyline,
        );

  final  List<List<AGSPoint>>  points;

  static AGSPolyline? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final bool hasZ = json['hasZ'] ?? false;
    final bool hasM = json['hasM'] ?? false;

    final List<dynamic> paths = json['paths'];

    final SpatialReference? spatialReference =
        SpatialReference.fromJson(json['spatialReference']);

    return AGSPolyline._(
      points: AGSPoint.fromJsonList(paths, hasZ: hasZ, hasM: hasM),
      hasZ: hasZ,
      hasM: hasM,
      spatialReference: spatialReference,
    );
  }

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> json = super.toJson();

    final hasZ = _hasZ ?? points.any((p) => p.any((e) => e.z != null));
    final hasM = _hasM ?? points.any((p) => p.any((e) => e.m != null));

    if(hasZ){
      json['hasZ'] = hasZ;
    }
    if(hasM){
      json['hasM'] = hasM;
    }

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
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

    addIfPresent('paths', _pointsToJson());
    return json;
  }
}
