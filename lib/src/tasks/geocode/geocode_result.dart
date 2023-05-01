part of arcgis_maps_flutter;

@immutable
class GeocodeResult {
  const GeocodeResult._({
    this.attributes,
    this.displayLocation,
    this.extent,
    this.inputLocation,
    required this.label,
    this.routeLocation,
    required this.score,
  });

  /// A collection of attributes as requeste
  /// Available attributes depend on the data stored with the locator, and can
  /// include things like place name, URL, phone number, and so on.
  final Map<String, Object?>? attributes;

  /// Location of the candidate suitable for display on a map.
  /// For example, this may provide a more precise rooftop location of a house,
  /// whereas [routeLocation] represents the nearest street location.
  final AGSPoint? displayLocation;

  /// An extent suitable for zooming the map to display the candidate.
  final Envelope? extent;

  /// The [AGSPoint] provided as input to [LocatorTask.reverseGeocodeAsync]
  /// Only applicable for results of reverse-geocode operations.
  final AGSPoint? inputLocation;

  /// User-friendly text that describes this result.
  final String label;

  /// The nearest street location for the result.
  /// Use this location if you want to use the candidate as a stop in a route.
  /// For example [displayLocation] may provide a more precise rooftop location of a house,
  /// whereas [routeLocation] represents the nearest street location.
  final AGSPoint? routeLocation;

  /// A value that indicates how well the address was matched.
  /// The score is in a range between 0 (no match) and 100 (perfect match).
  final double score;

  /// Creates a new [GeocodeResult] from a JSON object.
  static GeocodeResult fromJson(Map<dynamic, dynamic> json) {
    return GeocodeResult._(
      attributes: parseAttributes(json['attributes']),
      displayLocation: AGSPoint.fromJson(json['displayLocation']),
      extent: Envelope.fromJson(json['extent']),
      inputLocation: AGSPoint.fromJson(json['inputLocation']),
      label: json['label'] as String,
      routeLocation: AGSPoint.fromJson(json['routeLocation']),
      score: json['score'] as double,
    );
  }

  @override
  String toString() {
    return 'GeocodeResult{attributes: $attributes, displayLocation: $displayLocation, extent: $extent, inputLocation: $inputLocation, label: $label, routeLocation: $routeLocation, score: $score}';
  }
}
