part of arcgis_maps_flutter;

int _offlineMapTaskHandlerId = 0;

class OfflineMapTask {
  final Completer<int> _completer = Completer<int>();

  final int _id;
  final Credential? _credential;
  bool _isDisposed = false;
  bool _created = false;

  /// Creates a task with the provided map to take offline.
  /// The map must be a web map either on ArcGIS Online
  /// or an on-premises ArcGIS Portal.
  OfflineMapTask.onlineMap({required this.map, Credential? credential})
      : portalItem = null,
        _credential = credential,
        _id = _offlineMapTaskHandlerId++;

  /// Creates a task with the provided portal item.
  /// The item must represent a web map (item type should be
  /// @c AGSPortalItemTypeWebMap)
  OfflineMapTask.portalItem({required this.portalItem, Credential? credential})
      : map = null,
        _credential = credential,
        _id = _offlineMapTaskHandlerId++;

  /// The map to take offline. The map must be a web map either on
  /// ArcGIS Online or an on-premises ArcGIS Portal.
  final ArcGISMap? map;

  /// Portal item specifying the map to take offline.
  /// The item must represent a web map
  /// (item type should be @c AGSPortalItemTypeWebMap)
  final PortalItem? portalItem;

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    if (!_created) return;
    OfflineMapTaskFlutterPlatform.instance.destroyOfflineMapTask(_id);
  }

  Future<GenerateOfflineMapParameters?> defaultGenerateOfflineMapParameters({
    required Geometry areaOfInterest,
    double? minScale,
    double? maxScale,
  }) async {
    assert(
        !((minScale != null && maxScale == null) ||
            (minScale == null && maxScale != null)),
        'minScale and maxScale both need to be specified');
    await _ensureCreated();
    return await OfflineMapTaskFlutterPlatform.instance
        .defaultGenerateOfflineMapParameters(
      _id,
      areaOfInterest: areaOfInterest,
      minScale: minScale,
      maxScale: maxScale,
    );
  }

  Future<GenerateOfflineMapJob> generateOfflineMap({
    required GenerateOfflineMapParameters parameters,
    required String downloadDirectory
  }) async {
    await _ensureCreated();
    throw UnimplementedError();
  }

  Future<void> _ensureCreated() async {
    if (_isDisposed) {
      throw Exception('OfflineMapTask is disposed');
    }
    if (_created) {
      await _completer.future;
      return;
    }
    _created = true;
    await OfflineMapTaskFlutterPlatform.instance.createOfflineMapTask(
      _id,
      map: map,
      portalItem: portalItem,
      credential: _credential,
    );
    _completer.complete(_id);
  }
}
