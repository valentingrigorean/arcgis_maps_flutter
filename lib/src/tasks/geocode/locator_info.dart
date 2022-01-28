part of arcgis_maps_flutter;

@immutable
class LocatorInfo {
  const LocatorInfo._({
    required this.name,
    required this.description,
    required this.intersectionResultAttributes,
    this.properties,
    required this.resultAttributes,
    required this.searchAttributes,
    this.spatialReference,
    required this.supportsPOI,
    required this.supportsAddresses,
    required this.supportsIntersections,
    required this.supportsSuggestions,
    required this.version,
  });

  static LocatorInfo fromJson(Map<dynamic, dynamic> json) {
    return LocatorInfo._(
      name: json['name'] as String,
      description: json['description'] as String,
      intersectionResultAttributes:
          _parseAttributes(json['intersectionResultAttributes']),
      properties: (json['properties'] as Map<dynamic, dynamic>?)
          ?.map((key, value) => MapEntry(key as String, value as String)),
      resultAttributes: _parseAttributes(json['resultAttributes']),
      searchAttributes: _parseAttributes(json['searchAttributes']),
      spatialReference: SpatialReference.fromJson(json['spatialReference']),
      supportsPOI: json['supportsPOI'] as bool,
      supportsAddresses: json['supportsAddresses'] as bool,
      supportsIntersections: json['supportsIntersections'] as bool,
      supportsSuggestions: json['supportsSuggestions'] as bool,
      version: json['version'] as String,
    );
  }

  /// Name of the locator service or dataset.
  final String name;

  /// Description of the locator service or dataset.
  final String description;

  /// The attribute fields that can be returned in the results of geocode
  /// or reverse geocode operations when searching for street intersections.
  final List<LocatorAttribute> intersectionResultAttributes;

  /// The locator properties. For example, MinimumCandidateScore,
  /// SideOffsetUnits, SpellingSensitivity, MinimumMatchScore and so on.
  final Map<String, String>? properties;

  /// The attribute fields that can be returned in the results of geocode
  /// or reverse geocode operations when searching for addresses or places.
  final List<LocatorAttribute> resultAttributes;

  /// The default spatial reference in which result geometries are returned,
  /// unless overriden in
  final List<LocatorAttribute> searchAttributes;

  /// The default spatial reference in which result geometries are returned,
  /// unless overriden in
  final SpatialReference? spatialReference;

  /// Indicates whether geocoding points of interest is supported.
  final bool supportsPOI;

  /// Indicates whether geocoding addresses is supported. If supported,
  /// these can be specified as x/y coordinate pairs in the search text
  /// for geocode operations, where the spatial reference of the coordinates
  /// is WGS84. For example, “-115.172783,36.114789”.
  final bool supportsAddresses;

  /// Indicates whether geocoding street intersections is supported.
  final bool supportsIntersections;

  /// Indicates whether getting suggestions for geocode operations is supported.
  final bool supportsSuggestions;

  /// Version of the locator service or dataset.
  final String version;

  @override
  String toString() {
    return 'LocatorInfo{name: $name, description: $description, intersectionResultAttributes: $intersectionResultAttributes, properties: $properties, resultAttributes: $resultAttributes, searchAttributes: $searchAttributes, spatialReference: $spatialReference, supportsPOI: $supportsPOI, supportsAddresses: $supportsAddresses, supportsIntersections: $supportsIntersections, supportsSuggestions: $supportsSuggestions, version: $version}';
  }
}

List<LocatorAttribute> _parseAttributes(List<dynamic> items) {
  return items.map((e) => LocatorAttribute.fromJson(e)).toList();
}
