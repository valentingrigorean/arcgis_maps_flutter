part of arcgis_maps_flutter;

abstract class Geometry {
  const Geometry({
    required this.geometryType,
    this.spatialReference,
  });

  /// The spatial reference of the geometry.
  final SpatialReference? spatialReference;

  final GeometryType geometryType;

  Map<String, Object> toJson() => {
        'type': geometryType.value,
        if (spatialReference != null)
          'spatialReference': spatialReference!.toJson(),
      };

  static Geometry? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    if (json.containsKey('type')) {
      final geometryType = GeometryType.fromValue(json['type']);
      switch (geometryType) {
        case GeometryType.point:
          return AGSPoint.fromJson(json);
        case GeometryType.envelope:
          return Envelope.fromJson(json);
        case GeometryType.polyline:
          return AGSPolyline.fromJson(json);
        case GeometryType.polygon:
          return AGSPolygon.fromJson(json);
        case GeometryType.multipoint:
          return AGSMultipoint.fromJson(json);
        case GeometryType.unknown:
          break;
      }
    }

    if (json.containsKey('paths')) {
      return AGSPolyline.fromJson(json);
    }
    if (json.containsKey('rings')) {
      return AGSPolygon.fromJson(json);
    }
    if (json.containsKey('xmax')) {
      return Envelope.fromJson(json);
    }

    return AGSPoint.fromJson(json);
  }
}
