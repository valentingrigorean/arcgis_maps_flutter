part of arcgis_maps_flutter;

@immutable
class ReverseGeocodeParameters {
  const ReverseGeocodeParameters({
    this.resultAttributeNames = const [],
    this.featureTypes = const [],
    this.forStorage = false,
    this.maxDistance = 1000,
    this.maxResults = 2147483647,
    this.outputSpatialReference,
    this.outputLanguageCode = '',
  });

  /// List of attributes to be returned for each geocoded result.
  /// The attributes available are specified by [LocatorInfo.resultAttributes]
  /// and [LocatorInfo.intersectionResultAttributes].
  /// Use "*" to return all attributes.
  final List<String> resultAttributeNames;

  /// Feature types used to filter the results of the reverse geocode operation.
  /// Currently only one feature type has any effect - specifying "intersection"
  /// causes the nearest street intersection to be returned.
  final List<String> featureTypes;

  /// Specifies whether the results of the operation should be persisted.
  /// The default value is false, which indicates the results of the operation
  /// can't be stored, but they can be temporarily displayed on a map for instance.
  /// If you store the results in a database, for example, you need to set this
  /// parameter to true.
  /// Applications are contractually prohibited from storing the results of
  /// geocoding transactions unless they perform the operation as an
  /// authenticated user.
  /// ArcGIS Online service credits are deducted from the organization account
  /// for each geocode transaction that uses this capability.
  final bool forStorage;

  /// The maximum distance (in meters) from the given location within which a
  /// matching address will be searched.
  /// Defaults to 1000 meters.
  final double maxDistance;

  /// The maximum number of results desired.
  final int maxResults;

  /// The spatial reference in which result geometries should be returned.
  final SpatialReference? outputSpatialReference;

  /// The language in which results should be returned. Based on the 2-digit ISO 639-1 language code.
  final String outputLanguageCode;

  ReverseGeocodeParameters copyWith({
    List<String>? resultAttributeNames,
    List<String>? featureTypes,
    bool? forStorage,
    double? maxDistance,
    int? maxResults,
    SpatialReference? outputSpatialReference,
    String? outputLanguageCode,
  }) {
    return ReverseGeocodeParameters(
      resultAttributeNames: resultAttributeNames ?? this.resultAttributeNames,
      featureTypes: featureTypes ?? this.featureTypes,
      forStorage: forStorage ?? this.forStorage,
      maxDistance: maxDistance ?? this.maxDistance,
      maxResults: maxResults ?? this.maxResults,
      outputSpatialReference:
          outputSpatialReference ?? this.outputSpatialReference,
      outputLanguageCode: outputLanguageCode ?? this.outputLanguageCode,
    );
  }

  Object toJson() {
    return {
      'resultAttributeNames': resultAttributeNames,
      'featureTypes': featureTypes,
      'forStorage': forStorage,
      'maxDistance': maxDistance,
      'maxResults': maxResults,
      'outputSpatialReference': outputSpatialReference?.toJson(),
      'outputLanguageCode': outputLanguageCode,
    };
  }
}
