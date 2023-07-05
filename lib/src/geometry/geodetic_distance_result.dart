part of arcgis_maps_flutter;

enum LinearUnitId {
  centimeter(0),
  feet(1),
  inches(2),
  kilometers(3),
  meters(4),
  miles(5),
  millimeters(6),
  nauticalMiles(7),
  yards(8),
  other(9),
  ;

  const LinearUnitId(this.value);

  factory LinearUnitId.fromValue(int value) {
    return LinearUnitId.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LinearUnitId.other,
    );
  }

  final int value;
}

enum AngularUnitId {
  degrees(0),
  minutes(1),
  seconds(2),
  grads(3),
  radians(4),
  other(5),
  ;

  const AngularUnitId(this.value);

  factory AngularUnitId.fromValue(int value) {
    return AngularUnitId.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AngularUnitId.other,
    );
  }

  final int value;
}

enum GeodeticCurveType {
  /// The shortest line between any two points on the Earth's surface
  /// on a spheroid (ellipsoid).
  geodesic(0),

  /// A line of constant bearing, or azimuth.
  loxodrome(1),

  /// The line on a spheroid (ellipsoid) defined by the intersection at
  /// the surface by a plane that passes through the center of the spheroid
  /// and the start and end points of a segment. This is also known
  /// as a great circle when a sphere is used.
  greatElliptic(2),

  /// A normal section.
  normalSection(3),

  /// Keeps the original shape of the geometry or curve.
  shapePreserving(4),
  ;

  const GeodeticCurveType(this.value);

  factory GeodeticCurveType.fromValue(int value) {
    return GeodeticCurveType.values.firstWhere(
      (e) => e.value == value,
    );
  }

  final int value;
}

@immutable
class GeodeticDistanceResult extends Equatable {
  const GeodeticDistanceResult({
    required this.distance,
    required this.distanceUnitId,
    required this.azimuth1,
    required this.azimuth2,
    required this.angularUnitId,
  });

  final double distance;

  final LinearUnitId distanceUnitId;

  final double azimuth1;

  final double azimuth2;

  final AngularUnitId? angularUnitId;

  factory GeodeticDistanceResult.fromJson(Map<dynamic, dynamic> json) {
    return GeodeticDistanceResult(
      distance: json['distance'],
      distanceUnitId: LinearUnitId.fromValue(json['distanceUnitId']),
      azimuth1: json['azimuth1'],
      azimuth2: json['azimuth2'],
      angularUnitId: json.containsKey('angularUnitId')
          ? AngularUnitId.fromValue(json['angularUnitId'])
          : null,
    );
  }

  @override
  List<Object?> get props => [distance, distanceUnitId, azimuth1, azimuth2];
}
