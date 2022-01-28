part of arcgis_maps_flutter;

int _routeTaskHandlerId = 0;

class RouteTask {
  final Completer<int> _completer = Completer<int>();

  final int _id;
  final Credential? _credential;

  bool _created = false;
  bool _isDisposed = false;

  RouteTask({
    required this.url,
    Credential? credential,
  })
      : _id = _routeTaskHandlerId++,
        _credential = credential;

  final String url;

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    if (!_created) return;
    //LocatorTaskFlutterPlatform.instance.destroyLocatorTask(_id);
  }

  Future<RouteTask> geRouteTaskInfo() async {
    await _ensureCreated();
    throw UnimplementedError();
  }

  Future<RouteParameters> createDefaultParameters() async {
    await _ensureCreated();
    throw UnimplementedError();
  }

  Future<RouteResult> solve(RouteParameters parameters) async {
    await _ensureCreated();
    throw UnimplementedError();
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
