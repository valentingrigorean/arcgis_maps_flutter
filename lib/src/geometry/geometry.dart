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
          return Point.fromJson(json);
        case GeometryType.envelope:
          return Envelope.fromJson(json);
        case GeometryType.polyline:
          return Polyline.fromJson(json);
        case GeometryType.polygon:
          return Polygon.fromJson(json);
        case GeometryType.multipoint:
          return Multipoint.fromJson(json);
        case GeometryType.unknown:
          break;
      }
    }

    if (json.containsKey('paths')) {
      return Polyline.fromJson(json);
    }
    if (json.containsKey('rings')) {
      return Polygon.fromJson(json);
    }
    if (json.containsKey('xmax')) {
      return Envelope.fromJson(json);
    }

    return Point.fromJson(json);
  }
}
