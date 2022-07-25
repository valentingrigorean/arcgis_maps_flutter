part of arcgis_maps_flutter;

enum LoadStatus {
  loaded(0),
  loading(1),
  failedToLoad(2),
  notLoaded(3),
  unknown(-1);

  const LoadStatus(this.value);

  factory LoadStatus.fromValue(int value) {
    return LoadStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LoadStatus.unknown,
    );
  }

  final int value;
}

mixin Loadable on ArcgisNativeObject {
  final StreamController<LoadStatus> _loadStatusController =
      StreamController<LoadStatus>.broadcast();

  @override
  void dispose() {
    _loadStatusController.close();
    super.dispose();
  }

  Future<LoadStatus> get loadStatus async {
    final result = await invokeMethod('getLoadStatus');
    return LoadStatus.fromValue(result ?? LoadStatus.unknown.value);
  }

  Future<ArcgisError?> get loadError async {
    final result = await invokeMethod('getLoadError');
    if (result == null) {
      return null;
    }
    return ArcgisError.fromJson(result);
  }

  Stream<LoadStatus> get onLoadStatusChanged => _loadStatusController.stream;

  Future<void> cancelLoad() async {
    await invokeMethod('cancelLoad');
  }

  Future<void> loadAsync() async {
    await invokeMethod('loadAsync');
  }

  Future<void> retryLoadAsync() async {
    await invokeMethod('retryLoadAsync');
  }

  @protected
  @override
  Future<void> handleMethodCall(String method, dynamic arguments) async {
    switch (method) {
      case 'onLoadStatusChanged':
        final int status = arguments;
        _loadStatusController.add(LoadStatus.fromValue(status));
        return;
    }
    super.handleMethodCall(method, arguments);
  }
}
