part of arcgis_maps_flutter;

class LocatorTask {
  final String _url;
  final Credential? _credential;

  const LocatorTask({required String url, Credential? credential})
      : _url = url,
        _credential = credential;

  Future<List<GeocodeResult>> reverseGeocode(AGSPoint point) {
    return LocatorTaskFlutterPlatform.instance.reverseGeocode(
      url: _url,
      location: point,
      credential: _credential,
    );
  }
}
