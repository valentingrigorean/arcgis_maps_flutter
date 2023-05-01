part of arcgis_maps_flutter;

class LocatorTask extends ArcgisNativeObject with Loadable, ApiKeyResource {
  final String _url;

  LocatorTask({
    required String url,
  }) : _url = url;

  @override
  String get type => 'LocatorTask';

  @override
  dynamic getCreateArguments() => _url;

  Future<LocatorInfo?> getLocatorInfo() async {
    final result = await invokeMethod('locatorTask#getLocatorInfo');
    if (result == null) {
      return null;
    }
    return LocatorInfo.fromJson(result);
  }

  Future<List<GeocodeResult>> geocode({
    required String searchText,
    GeocodeParameters? parameters,
  }) async {
    final result = await invokeMethod<List<dynamic>>('locatorTask#geocode',
        arguments: {
          'searchText': searchText,
          'parameters': parameters?.toJson()
        });

    if (result == null) {
      return const [];
    }
    return result.map((e) => GeocodeResult.fromJson(e)).toList();
  }

  Future<List<GeocodeResult>> geocodeSuggestResult({
    required SuggestResult suggestResult,
    GeocodeParameters? parameters,
  }) async {
    final result = await invokeMethod<List<dynamic>>(
        'locatorTask#geocodeSuggestResult',
        arguments: {
          'suggestResultId': suggestResult.toJson(),
          'parameters': parameters?.toJson(),
        });

    if (result == null) {
      return const [];
    }
    return result.map((e) => GeocodeResult.fromJson(e)).toList();
  }

  /// Perform a geocode operation to find location candidates for the provided
  /// values of a multi-line address. [searchValues] to geocode.
  /// Each value represents an individual address component of a multi-line address.
  /// The address components supported are defined by [LocatorInfo.searchAttributes].
  /// The key of this dictionary should match [LocatorAttribute.name], and the
  /// value in the input for that address component.
  Future<List<GeocodeResult>> geocodeSearchValues({
    required Map<String, String> searchValues,
    GeocodeParameters? parameters,
  }) async {
    final result = await invokeMethod<List<dynamic>>(
        'locatorTask#geocodeSearchValues',
        arguments: {
          'searchValues': searchValues,
          'parameters': parameters?.toJson(),
        });

    if (result == null) {
      return const [];
    }
    return result.map((e) => GeocodeResult.fromJson(e)).toList();
  }

  Future<List<GeocodeResult>> reverseGeocode({
    required AGSPoint location,
    ReverseGeocodeParameters? parameters,
  }) async {
    final List<dynamic> result = await invokeMethod(
      'locatorTask#reverseGeocode',
      arguments: {
        'location': location.toJson(),
        'parameters': parameters?.toJson(),
      },
    );
    return result
        .map<GeocodeResult>((json) => GeocodeResult.fromJson(json))
        .toList();
  }

  /// Returns a list of [SuggestResult]s based on the given [searchText].
  /// SuggestResult need to be release with [releaseSuggestResults]
  /// when they are no longer used.
  Future<List<SuggestResult>> suggest(
      {required String searchText, SuggestParameters? parameters}) async {
    final List<dynamic> result = await invokeMethod(
      'locatorTask#suggest',
      arguments: {
        'searchText': searchText,
        'parameters': parameters?.toJson(),
      },
    );
    return result
        .map<SuggestResult>((json) => SuggestResult.fromJson(json))
        .toList();
  }

  /// Releases the given [suggestResults].
  /// This method should be called when the [suggestResults] are no longer used
  /// to free up resources.
  /// The [suggestResults] should not be used after this method is called.
  /// If parameter is null, will clear all suggest results.
  Future<void> releaseSuggestResults({List<SuggestResult>? results}) async {
    await invokeMethod(
      'locatorTask#releaseSuggestResults',
      arguments: results?.map((e) => e.toJson()).toList(),
    );
  }
}
