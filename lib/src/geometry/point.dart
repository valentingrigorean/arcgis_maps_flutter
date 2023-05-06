part of arcgis_maps_flutter;

@immutable
class Point extends Geometry {
  const Point({
    required this.x,
    required this.y,
    this.z,
    this.m,
    SpatialReference? spatialReference,
  }) : super(
          spatialReference: spatialReference,
          geometryType: GeometryType.point,
        );

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

    if (json['x'] == null || json['y'] == null) {
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

  static List<List<Point>> fromJsonList(
    List<dynamic> json, {
    required bool hasZ,
    bool hasM = false,
  }) {
    List<List<Point>> result = [];

    for (final path in json) {
      final List<Point> points = [];
      for (final point in path) {
        final double x = toDoubleSafe(point[0]);
        final double y = toDoubleSafe(point[1]);
        final double? z = hasZ ? toDoubleSafeNullable(point[2]) : null;
        final double? m = hasM
            ? hasZ
                ? toDoubleSafeNullable(point[3])
                : toDoubleSafeNullable(point[2])
            : null;
        points.add(Point(x: x, y: y, z: z, m: m));
      }
      result.add(points);
    }
    return result;
  }

  final double x;
  final double y;
  final double? z;
  final double? m;

  bool get hasZ => z != null;

  bool get hasM => m != null;

  double get latitude => y;

  double get longitude => x;

  Point copyWithSpatialReference(SpatialReference? spatialReference) {
    return Point(
      x: x,
      y: y,
      z: z,
      m: m,
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

    json['x'] = x;
    json['y'] = y;
    addIfPresent('z', z);
    addIfPresent('m', m);
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
    return 'AGSPoint{x: $x, y: $y, z: $z, m: $m, spatialReference: $spatialReference}';
  }
}
