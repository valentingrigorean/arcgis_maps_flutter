part of arcgis_maps_flutter;

@immutable
class AGSPoint extends Geometry {
  const AGSPoint({
    required this.x,
    required this.y,
    this.z,
    this.m,
    SpatialReference? spatialReference,
  }) : super(
          spatialReference: spatialReference,
          geometryType: GeometryType.point,
        );

  factory AGSPoint.fromLatLng({
    required double latitude,
    required double longitude,
  }) =>
      AGSPoint(
        x: longitude,
        y: latitude,
        spatialReference: SpatialReference.wgs84(),
      );

  static AGSPoint? fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return AGSPoint(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      z: json['z']?.toDouble(),
      m: json['m']?.toDouble(),
      spatialReference: SpatialReference.fromJson(json['spatialReference']),
    );
  }

  static List<AGSPoint> fromJsonList(List<dynamic> json, bool hasZ) {
    final List<AGSPoint> points = [];

    for (final path in json) {
      for (final point in path) {
        final double x = toDoubleSafe(point[0]);
        final double y = toDoubleSafe(point[1]);
        final double? z = hasZ ? toDoubleSafeNullable(point[2]) : null;
        points.add(AGSPoint(x: x, y: y, z: z));
      }
    }
    return points;
  }

  final double x;
  final double y;
  final double? z;
  final double? m;

  double get latitude => y;

  double get longitude => x;

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
      other is AGSPoint &&
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
