part of arcgis_maps_flutter;

enum LatitudeLongitudeFormat {
  /// The geographical coordinates are represented in decimal degrees.
  decimalDegrees,

  /// The geographical coordinates are represented in degrees and decimal minutes.
  degreesDecimalMinutes,

  /// The geographical coordinates are represented in degrees and minutes and decimal seconds.
  degreesMinutesSeconds
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
    required AGSPoint from,
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
