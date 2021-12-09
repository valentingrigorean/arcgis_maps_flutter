part of arcgis_maps_flutter;

enum LinearUnitId {
  centimeter,
  feet,
  inches,
  kilometers,
  meters,
  miles,
  nauticalMiles,
  yards,
  other
}

enum AngularUnitId {
  degrees,
  minutes,
  seconds,
  grads,
  radians,
  other,
}

enum GeodeticCurveType {

  /// The shortest line between any two points on the Earth's surface
  /// on a spheroid (ellipsoid).
  geodesic,

  /// A line of constant bearing, or azimuth.
  loxodrome,

  /// The line on a spheroid (ellipsoid) defined by the intersection at
  /// the surface by a plane that passes through the center of the spheroid
  /// and the start and end points of a segment. This is also known
  /// as a great circle when a sphere is used.
  greatElliptic,

  /// A normal section.
  normalSection,

  /// Keeps the original shape of the geometry or curve.
  shapePreserving,
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

  final AngularUnitId angularUnitId;

  factory GeodeticDistanceResult.fromJson(Map<dynamic, dynamic> json) {
    return GeodeticDistanceResult(
      distance: json['distance'],
      distanceUnitId: LinearUnitId.values[json['distanceUnitId']],
      azimuth1: json['azimuth1'],
      azimuth2: json['azimuth2'],
      angularUnitId: AngularUnitId.values[json['angularUnitId']],
    );
  }

  @override
  List<Object?> get props => [distance, distanceUnitId, azimuth1, azimuth2];
}
