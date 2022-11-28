part of arcgis_maps_flutter;

class LocatorTask extends ArcgisNativeObject
    with Loadable, RemoteResource, ApiKeyResource {
  final String _url;

  LocatorTask({
    required String url,
    Credential? credential,
  }) : _url = url {
    if (credential != null) {
      setCredential(credential);
    }
  }

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
    final result = await invokeMethod<List<dynamic>>('locatorTask#geocode', arguments: {
      'searchText': searchText,
      'parameters': parameters?.toJson()
    });

    if (result == null) {
      return const [];
    }
    return result.map((e) => GeocodeResult.fromJson(e)).toList();
  }

  Future<List<GeocodeResult>> reverseGeocode(AGSPoint location) async {
    final List<dynamic> result = await invokeMethod(
      'locatorTask#reverseGeocode',
      arguments: location.toJson(),
    );
    return result
        .map<GeocodeResult>((json) => GeocodeResult.fromJson(json))
        .toList();
  }
}
