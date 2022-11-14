part of arcgis_maps_flutter;

class GeodesicSectorParameters {
  const GeodesicSectorParameters({
    required this.center,
    required this.semiAxis1Length,
    required this.semiAxis2Length,
    required this.startDirection,
    required this.sectorAngle,
    this.linearUnit = LinearUnitId.meters,
    this.angularUnit = AngularUnitId.degrees,
    this.axisDirection = 0,
    this.maxSegmentLength,
    this.geometryType = GeometryType.polygon,
    this.maxPointCount = 65536,
  });

  /// The center [AGSPoint] of the ellipse. The ellipse is used to construct the sector's arc.
  final AGSPoint center;

  /// The length of the semi-major or the semi-minor axis of the ellipse.
  /// The ellipse is used to construct the sector's arc.
  final double semiAxis1Length;

  /// The length of the semi-major or the semi-minor axis of the ellipse.
  /// The ellipse is used to construct the sector's arc.
  final double semiAxis2Length;

  /// The linear units of the lengths [maxSegmentLength], [semiAxis1Length]
  /// and [semiAxis2Length].
  final LinearUnitId linearUnit;

  /// The angular unit of the [sectorAngle].
  final AngularUnitId angularUnit;

  /// The direction of the longest axis of the ellipse as an angle (in degrees).
  /// The ellipse is used to construct the sector's arc.
  final double axisDirection;

  /// The direction of the starting radius of the sector as an angle in degrees [0] is East.
  final double startDirection;

  /// The angle of the sector in degrees.
  /// An absolute value is used only. Should be greater than zero and less than 360.
  /// A positive sector angle goes clockwise from the [startDirection].
  final double sectorAngle;

  /// The maximum distance between vertices used to construct the sector's arc.
  final double? maxSegmentLength;

  /// The type of output geometry created.
  /// Acceptable values are [GeometryType.multipoint], [GeometryType.polyline]
  /// and [GeometryType.polygon].
  /// Defaults to [GeometryType.polygon].
  final GeometryType geometryType;

  /// The maximum number of points permitted in the constructed sector
  final int maxPointCount;

  Object toJson() {
    return {
      'center': center.toJson(),
      'semiAxis1Length': semiAxis1Length,
      'semiAxis2Length': semiAxis2Length,
      'linearUnit': linearUnit.index,
      'angularUnit': angularUnit.index,
      'axisDirection': axisDirection,
      'startDirection': startDirection,
      'sectorAngle': sectorAngle,
      'maxSegmentLength': maxSegmentLength,
      'geometryType': geometryType.value,
      'maxPointCount': maxPointCount,
    };
  }

  GeodesicSectorParameters copyWith({
    AGSPoint? center,
    double? semiAxis1Length,
    double? semiAxis2Length,
    LinearUnitId? linearUnit,
    AngularUnitId? angularUnit,
    double? axisDirection,
    double? startDirection,
    double? sectorAngle,
    double? maxSegmentLength,
    GeometryType? geometryType,
    int? maxPointCount,
  }) {
    return GeodesicSectorParameters(
      center: center ?? this.center,
      semiAxis1Length: semiAxis1Length ?? this.semiAxis1Length,
      semiAxis2Length: semiAxis2Length ?? this.semiAxis2Length,
      linearUnit: linearUnit ?? this.linearUnit,
      angularUnit: angularUnit ?? this.angularUnit,
      axisDirection: axisDirection ?? this.axisDirection,
      startDirection: startDirection ?? this.startDirection,
      sectorAngle: sectorAngle ?? this.sectorAngle,
      maxSegmentLength: maxSegmentLength ?? this.maxSegmentLength,
      geometryType: geometryType ?? this.geometryType,
      maxPointCount: maxPointCount ?? this.maxPointCount,
    );
  }
}
