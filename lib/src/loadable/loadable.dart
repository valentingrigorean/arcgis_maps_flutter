part of arcgis_maps_flutter;

enum LoadStatus {
  notLoaded(0),
  loading(1),
  loaded(2),
  failed(3),
  ;

  const LoadStatus(this.value);

  factory LoadStatus.fromValue(int value) {
    return LoadStatus.values.firstWhere(
      (e) => e.value == value,
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
    final result = await invokeMethod('loadable#getLoadStatus');
    return LoadStatus.fromValue(result);
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
        break;
      default:
        await super.handleMethodCall(method, arguments);
        break;
    }
  }
}
