part of arcgis_maps_flutter;

enum LatitudeLongitudeFormat {
  /// The geographical coordinates are represented in decimal degrees.
  decimalDegrees(0),

  /// The geographical coordinates are represented in degrees and decimal minutes.
  degreesDecimalMinutes(1),

  /// The geographical coordinates are represented in degrees and minutes and decimal seconds.
  degreesMinutesSeconds(2),
  ;


  const LatitudeLongitudeFormat(this.value);

  factory LatitudeLongitudeFormat.fromValue(int value) {
    switch (value) {
      case 0:
        return LatitudeLongitudeFormat.decimalDegrees;
      case 1:
        return LatitudeLongitudeFormat.degreesDecimalMinutes;
      case 2:
        return LatitudeLongitudeFormat.degreesMinutesSeconds;
      default:
        throw ArgumentError.value(value, 'value', 'Invalid value for LatitudeLongitudeFormat');
    }
  }

  final int value;
}

class CoordinateFormatter {
  CoordinateFormatter._();

  /// Returns a coordinate notation string in latitude-longitude format
  /// representing the given point's location.
  /// The latitude-longitude string will contain a space separating the latitude
  /// from the longitude value, and the characters 'N' or 'S', and 'E' and 'W',
  /// to indicate the hemisphere of each value. The string will also
  /// contain spaces separating the components (degrees, minutes, seconds)
  /// of each value. The precision of the output is controlled by both
  /// the [format] and [decimalPlaces] parameters.
  static Future<String?> latitudeLongitudeString({
    required Point from,
    required LatitudeLongitudeFormat format,
    required int decimalPlaces,
  }) {
    return CoordinateFormatterFlutterPlatform.instance.latitudeLongitudeString(
      from: from,
      format: format,
      decimalPlaces: decimalPlaces,
    );
  }
}
