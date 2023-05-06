part of arcgis_maps_flutter;

@immutable
class Camera {
  const Camera._({
    this.latitude,
    this.longitude,
    this.altitude,
    this.heading,
    this.pitch,
    this.roll,
    this.cameraLocation,
  });

  factory Camera.all(
    double latitude,
    double longitude,
    double altitude,
    double heading,
    double pitch,
    double roll,
  ) =>
      Camera._(
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        heading: heading,
        pitch: pitch,
        roll: roll,
      );

  factory Camera.fromPoint(
    Point cameraLocation,
    double heading,
    double pitch,
    double roll,
  ) =>
      Camera._(
        cameraLocation: cameraLocation,
        heading: heading,
        pitch: pitch,
        roll: roll,
      );

  final double? latitude;
  final double? longitude;
  final double? altitude;
  final double? heading;
  final double? pitch;
  final double? roll;

  final Point? cameraLocation;

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('latitude', latitude);
    addIfPresent('longitude', longitude);
    addIfPresent('altitude', altitude);
    addIfPresent('heading', heading);
    addIfPresent('pitch', pitch);
    addIfPresent('roll', roll);
    addIfPresent('cameraLocation', cameraLocation?.toJson());

    return json;
  }

  @override
  String toString() {
    return 'Camera{latitude: $latitude, longitude: $longitude, altitude: $altitude, heading: $heading, pitch: $pitch, roll: $roll, cameraLocation: $cameraLocation}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Camera &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          altitude == other.altitude &&
          heading == other.heading &&
          pitch == other.pitch &&
          roll == other.roll &&
          cameraLocation == other.cameraLocation;

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      altitude.hashCode ^
      heading.hashCode ^
      pitch.hashCode ^
      roll.hashCode ^
      cameraLocation.hashCode;
}
