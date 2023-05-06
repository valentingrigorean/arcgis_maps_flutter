part of arcgis_maps_flutter;

@immutable
class SuggestParameters {
  const SuggestParameters({
    this.categories = const [],
    this.countryCode = '',
    this.maxResults = 2147483647,
    this.preferredSearchLocation,
    this.searchArea,
  });

  /// Categories by which to filter geocoded results.
  /// Categories represent address and place types,
  /// for example "city", "school", "Ski Resort".
  /// By default no category filtering is applied.
  /// https://developers.arcgis.com/rest/geocode/api-reference/geocoding-category-filtering.htm
  final List<String> categories;

  /// Country by which to filter results. This can speed up the geocoding operation.
  /// Acceptable values include the full country name in English or the official
  /// language of the country, the ISO 3166-1 2-digit country code, or the
  /// ISO 3166-1 3-digit country code.
  /// https://developers.arcgis.com/rest/geocode/api-reference/geocode-coverage.htm
  final String countryCode;

  /// The maximum number of results desired.
  /// Only applies when using an ArcGIS Geocode service
  /// (i.e not geocoding locally on the device using a locator dataset).
  /// Please consult the service properties for information on the largest
  /// acceptable value for this parameter.
  final int maxResults;

  /// The location by which to prioritize/order geocoded results.
  /// Results that fall within a 50 KM buffer of this location are boosted
  /// in rank so that they show up higher in the list of candidates, but results
  /// further away are still included. To exclude results based on a region,
  /// use [searchArea] instead. The preferred search location is only intended
  /// to influence the sort order of results so that the most locationally-relevant
  /// candidates are returned first.
  final Point? preferredSearchLocation;

  /// The search area used to spatially filter the geocoded results.
  /// Only results that lie within this area are included.
  final Geometry? searchArea;

  SuggestParameters copyWith({
    List<String>? categories,
    String? countryCode,
    int? maxResults,
    Point? preferredSearchLocation,
    Geometry? searchArea,
  }) {
    return SuggestParameters(
      categories: categories ?? this.categories,
      countryCode: countryCode ?? this.countryCode,
      maxResults: maxResults ?? this.maxResults,
      preferredSearchLocation:
          preferredSearchLocation ?? this.preferredSearchLocation,
      searchArea: searchArea ?? this.searchArea,
    );
  }

  Object toJson() {
    return {
      'categories': categories,
      'countryCode': countryCode,
      'maxResults': maxResults,
      'preferredSearchLocation': preferredSearchLocation?.toJson(),
      'searchArea': searchArea?.toJson(),
    };
  }
}
