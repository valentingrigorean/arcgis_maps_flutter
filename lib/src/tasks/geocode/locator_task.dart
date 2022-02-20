part of arcgis_maps_flutter;

int _locatorTaskHandlerId = 0;

class LocatorTask {
  final Completer<int> _completer = Completer<int>();

  final int _id;
  final Credential? _credential;
  bool _created = false;
  bool _isDisposed = false;

  LocatorTask({required this.url, Credential? credential})
      : _credential = credential,
        _id = _locatorTaskHandlerId++;

  final String url;

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    if (!_created) return;
    LocatorTaskFlutterPlatform.instance.destroyLocatorTask(_id);
  }

  Future<LocatorInfo> getLocatorInfo() async {
    await _ensureCreated();
    return await LocatorTaskFlutterPlatform.instance.getLocatorInfo(_id);
  }

  Future<List<GeocodeResult>> reverseGeocode(AGSPoint location) async {
    await _ensureCreated();
    return await LocatorTaskFlutterPlatform.instance
        .reverseGeocode(_id, location);
  }

  Future<void> _ensureCreated() async {
    if (_isDisposed) {
      throw Exception('LocatorTask is disposed');
    }
    if (_created) {
      await _completer.future;
      return;
    }
    _created = true;
    await LocatorTaskFlutterPlatform.instance
        .createLocatorTask(_id, url, _credential);
    _completer.complete(_id);
  }
}
