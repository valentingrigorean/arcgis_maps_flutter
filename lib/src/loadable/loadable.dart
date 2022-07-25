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
  void disposeInternal() {
    _loadStatusController.close();
    super.disposeInternal();
  }

  Future<LoadStatus> get loadStatus async {
    final result = await invokeMethod('loadable#getLoadStatus');
    return LoadStatus.fromValue(result ?? LoadStatus.unknown.value);
  }

  Future<ArcgisError?> get loadError async {
    final result = await invokeMethod('loadable#getLoadError');
    if (result == null) {
      return null;
    }
    return ArcgisError.fromJson(result);
  }

  Stream<LoadStatus> get onLoadStatusChanged => _loadStatusController.stream;

  Future<void> cancelLoad() async {
    await invokeMethod('loadable#cancelLoad');
  }

  Future<void> loadAsync() async {
    await invokeMethod('loadable#loadAsync');
  }

  Future<void> retryLoadAsync() async {
    await invokeMethod('loadable#retryLoadAsync');
  }

  @protected
  @override
  Future<void> handleMethodCall(String method, dynamic arguments) async {
    switch (method) {
      case 'loadable#onLoadStatusChanged':
        final int status = arguments;
        _loadStatusController.add(LoadStatus.fromValue(status));
        return;
    }
    super.handleMethodCall(method, arguments);
  }
}
