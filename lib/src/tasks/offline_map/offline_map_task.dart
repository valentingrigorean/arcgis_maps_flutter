part of arcgis_maps_flutter;

class OfflineMapTask {
  /// Creates a task with the provided map to take offline.
  /// The map must be a web map either on ArcGIS Online
  /// or an on-premises ArcGIS Portal.
  OfflineMapTask.onlineMap({required this.map}) : portalItem = null;

  /// Creates a task with the provided portal item.
  /// The item must represent a web map (item type should be
  /// @c AGSPortalItemTypeWebMap)
  OfflineMapTask.portalItem({required this.portalItem}) : map = null;

  /// The map to take offline. The map must be a web map either on
  /// ArcGIS Online or an on-premises ArcGIS Portal.
  final ArcGISMap? map;

  /// Portal item specifying the map to take offline.
  /// The item must represent a web map
  /// (item type should be @c AGSPortalItemTypeWebMap)
  final PortalItem? portalItem;


  Future<GenerateOfflineMapParameters?> defaultGenerateOfflineMapParameters({
    required Geometry areaOfInterest,
    double? minScale,
    double? maxScale,
  }) async {
    assert(minScale != null && maxScale == null,
        'minScale and maxScale both need to be specified');
    assert(minScale == null && maxScale != null,
        'minScale and maxScale both need to be specified');
    return null;
  }
}
