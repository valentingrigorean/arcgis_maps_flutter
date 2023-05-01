part of arcgis_maps_flutter;

enum GeometryType {
  unknown(-1),
  point(1),
  envelope(2),
  polyline(3),
  polygon(4),
  multipoint(5);

  const GeometryType(this.value);

  factory GeometryType.fromValue(dynamic value) {
    if (value is int) {
      return GeometryType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => GeometryType.unknown,
      );
    }
    if (value is String) {
      switch (value) {
        case 'point':
          return GeometryType.point;
        case 'envelope':
          return GeometryType.envelope;
        case 'polyline':
          return GeometryType.polyline;
        case 'polygon':
          return GeometryType.polygon;
        case 'multipoint':
          return GeometryType.multipoint;
        default:
          return GeometryType.unknown;
      }
    }

    return GeometryType.unknown;
  }

  final int value;
}
