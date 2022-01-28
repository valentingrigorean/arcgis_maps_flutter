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
  })  : _id = _routeTaskHandlerId++,
        _credential = credential;

  final String url;

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    if (!_created) return;
    RouteTaskFlutterPlatform.instance.destroyRouteTask(_id);
  }

  Future<RouteTaskInfo> geRouteTaskInfo() async {
    await _ensureCreated();
    return await RouteTaskFlutterPlatform.instance.getRouteTaskInfo(_id);
  }

  Future<RouteParameters> createDefaultParameters() async {
    await _ensureCreated();
    return await RouteTaskFlutterPlatform.instance.createDefaultParameters(_id);
  }

  Future<RouteResult> solveRoute(RouteParameters parameters) async {
    await _ensureCreated();
    return await RouteTaskFlutterPlatform.instance.solveRoute(_id, parameters);
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
    await RouteTaskFlutterPlatform.instance
        .createRouteTask(_id, url, _credential);
    _completer.complete(_id);
  }
}
