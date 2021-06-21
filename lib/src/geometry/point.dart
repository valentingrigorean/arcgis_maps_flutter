part of arcgis_maps_flutter;

@immutable
class Point implements Geometry {
  const Point({
    required this.x,
    required this.y,
    this.z,
    this.m,
    this.spatialReference,
  });

  factory Point.fromLatLng({
    required double latitude,
    required double longitude,
  }) =>
      Point(
        x: longitude,
        y: latitude,
        spatialReference: SpatialReference.wgs84(),
      );

  static Point? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return Point(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      z: json['z']?.toDouble(),
      m: json['m']?.toDouble(),
      spatialReference: SpatialReference.fromJson(json['spatialReference']),
    );
  }

  static List<Point> fromJsonList(List<dynamic> json, bool hasZ) {
    final List<Point> points = [];

    for (final path in json) {
      for (final point in path) {
        final double x = toDoubleSafe(point[0]);
        final double y = toDoubleSafe(point[1]);
        final double? z = hasZ ? toDoubleSafeNullable(point[2]) : null;
        points.add(Point(x: x, y: y, z: z));
      }
    }
    return points;
  }

  final double x;
  final double y;
  final double? z;
  final double? m;

  final SpatialReference? spatialReference;

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    json['x'] = x;
    json['y'] = y;
    addIfPresent('z', z);
    addIfPresent('m', m);
    addIfPresent('spatialReference', spatialReference?.toJson());

    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          z == other.z &&
          m == other.m &&
          spatialReference == other.spatialReference;

  @override
  int get hashCode =>
      x.hashCode ^
      y.hashCode ^
      z.hashCode ^
      m.hashCode ^
      spatialReference.hashCode;

  @override
  String toString() {
    return 'Point{x: $x, y: $y, z: $z, m: $m, spatialReference: $spatialReference}';
  }
}
