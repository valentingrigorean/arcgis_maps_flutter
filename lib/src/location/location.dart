part of arcgis_maps_flutter;

@immutable
class Location {
  Location({
    this.course = -1,
    this.horizontalAccuracy = -1,
    this.lastKnown = false,
    this.position,
    this.speed = -1,
    DateTime? timestamp,
    this.verticalAccuracy = 0,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Location.fromJson(Map<dynamic, dynamic> json) {
    return Location(
      course: json['course'] as double,
      horizontalAccuracy: json['horizontalAccuracy'] as double,
      lastKnown: json['lastKnown'] as bool,
      position: json['position'] == null
          ? null
          : Point.fromJson(json['position'] as Map<dynamic, dynamic>),
      speed: json['speed'] as double,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      verticalAccuracy: json['verticalAccuracy'] as double,
    );
  }

  /// The direction in which the device is traveling, measured in degrees
  /// starting at due north and continuing clockwise around the compass.
  /// Thus, north is  0 degrees, east is 90 degrees, south is @c 180 degrees,
  /// and so on.Course values may not be available on all devices.
  /// A negative value indicates that the direction is invalid.
  final double course;

  /// The radius of uncertainty for the location, measured in meters.
  /// The location’s @c #position property identifies the center of the
  /// circle, and this value indicates the radius of that circle.
  /// A negative value indicates that the location’s position is invalid.
  final double horizontalAccuracy;

  /// Indicates whether this is an outdated device position retrieved and
  /// cached earlier and therefore not guaranteed to represent the current location.
  final bool lastKnown;

  /// The coordinates of the location.
  final Point? position;

  /// The speed of the device in meters per second.
  final double speed;

  /// The time the location was determined.
  final DateTime timestamp;

  /// The accuracy of the location's vertical component, in meters.
  final double verticalAccuracy;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          course == other.course &&
          horizontalAccuracy == other.horizontalAccuracy &&
          lastKnown == other.lastKnown &&
          position == other.position &&
          speed == other.speed &&
          timestamp == other.timestamp &&
          verticalAccuracy == other.verticalAccuracy;

  @override
  int get hashCode =>
      course.hashCode ^
      horizontalAccuracy.hashCode ^
      lastKnown.hashCode ^
      position.hashCode ^
      speed.hashCode ^
      timestamp.hashCode ^
      verticalAccuracy.hashCode;

  @override
  String toString() {
    return 'Location{course: $course, horizontalAccuracy: $horizontalAccuracy, lastKnown: $lastKnown, position: $position, speed: $speed, timestamp: $timestamp, verticalAccuracy: $verticalAccuracy}';
  }
}
