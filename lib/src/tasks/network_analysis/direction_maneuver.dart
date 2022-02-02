part of arcgis_maps_flutter;

@immutable
class DirectionManeuver {
  const DirectionManeuver._({
    required this.directionEvents,
    required this.directionText,
    required this.estimatedArriveTime,
    required this.estimatedArrivalTimeShift,
    required this.maneuverMessages,
    required this.fromLevel,
    required this.geometry,
    required this.maneuverType,
    required this.toLevel,
    required this.length,
    required this.duration,
  });

  factory DirectionManeuver.fromJson(Map<String, dynamic> json) {
    return DirectionManeuver._(
      directionEvents: DirectionEvent.fromJsonList(json['directionEvents']),
      directionText: json['directionText'] as String,
      estimatedArriveTime: parseDateTimeSafeNullable(json['estimatedArriveTime']),
      estimatedArrivalTimeShift: json['estimatedArrivalTimeShift'] as double,
      maneuverMessages: DirectionMessage.fromJsonList(json['maneuverMessages']),
      fromLevel: json['fromLevel'] as int,
      geometry: Geometry.fromJson(json['geometry']),
      maneuverType: DirectionManeuverType.values[json['maneuverType'] as int],
      toLevel: json['toLevel'] as int,
      length: json['length'] as double,
      duration: json['duration'] as double,
    );
  }

  static List<DirectionManeuver> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DirectionManeuver.fromJson(json)).toList();
  }

  /// Events along the maneuver
  final List<DirectionEvent> directionEvents;

  /// User-friendly text describing the maneuver
  final String directionText;

  /// Estimated time of arrival at the destination of this manuever in the current locale of the device.
  final DateTime? estimatedArriveTime;

  /// Time zone shift in minutes (based on the destination of this manuever) for the estimated arrival time.
  final double estimatedArrivalTimeShift;

  /// The detailed messages describing this manuever
  final List<DirectionMessage> maneuverMessages;

  /// The logical level at the start of the maneuver.
  /// The [fromLevel] and [toLevel] properties are defined to provide a way
  /// to filter directions based on logical level division.
  /// For example, a 3D routing application might render a 2D map with route lines
  /// filtered by vertical level instead of displaying overlapping lines on different levels.
  /// The [fromLevel] and [toLevel] properties are populated from source data and not calculated
  /// by the directions engine. If the source data does not contain "LevelFrom" and "LevelTo" fields, the
  /// properties will be populated with -1 values
  final int fromLevel;

  /// Geometry representing the maneuver, be it a turn or travelling in a straight line.
  final Geometry? geometry;

  /// The maneuver type
  final DirectionManeuverType maneuverType;

  /// The logical level at the end of the maneuver.
  /// The [fromLevel] and [toLevel] properties are defined to provide a way
  /// to filter directions based on logical level division.
  /// For example, a 3D routing application might render a 2D map with route lines
  /// filtered by vertical level instead of displaying overlapping lines on different levels.
  /// The [fromLevel] and [toLevel] properties are populated from source data and not calculated
  /// by the directions engine. If the source data does not contain "LevelFrom" and "LevelTo" fields, the
  /// properties will be populated with -1 values
  final int toLevel;

  /// Length (in meters) of the maneuver.
  final double length;

  /// Duration (in minutes) of the maneuver
  final double duration;
}
