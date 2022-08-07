part of arcgis_maps_flutter;

class OfflineMapTask extends ArcgisNativeObject with Loadable {
  /// Creates a task with the provided map to take offline.
  /// The map must be a web map either on ArcGIS Online
  /// or an on-premises ArcGIS Portal.
  OfflineMapTask.onlineMap({required this.map});

  /// Creates a task with the provided portal item.
  /// The item must represent a web map (item type should be
  /// @c AGSPortalItemTypeWebMap)
  OfflineMapTask.portalItem({required PortalItem portalItem})
      : map = ArcGISMap.fromPortalItem(portalItem);

  @override
  String get type => "OfflineMapTask";

  /// The map to take offline. The map must be a web map either on
  /// ArcGIS Online or an on-premises ArcGIS Portal.
  final ArcGISMap map;

  @override
  @protected
  dynamic getCreateArguments() => map.toJson();

  Future<GenerateOfflineMapParameters?> defaultGenerateOfflineMapParameters({
    required Geometry areaOfInterest,
    double? minScale,
    double? maxScale,
  }) async {
    assert(
        !((minScale != null && maxScale == null) ||
            (minScale == null && maxScale != null)),
        'minScale and maxScale both need to be specified');
    final parameters = await invokeMethod(
        'offlineMapTask#defaultGenerateOfflineMapParameters', {
      'areaOfInterest': areaOfInterest.toJson(),
      if (minScale != null) 'minScale': minScale,
      if (maxScale != null) 'maxScale': maxScale,
    });

    return parameters == null
        ? null
        : GenerateOfflineMapParameters.fromJson(parameters);
  }

  Future<GenerateOfflineMapJob> generateOfflineMap({
    required GenerateOfflineMapParameters parameters,
    required String downloadDirectory,
  }) async {
    final jobId = await invokeMethod<String>(
      'offlineMapTask#generateOfflineMap',
      {
        'parameters': parameters.toJson(),
        'downloadDirectory': downloadDirectory,
      },
    );

    return GenerateOfflineMapJob._(
      onlineMap: map,
      downloadDirectory: downloadDirectory,
      parameters: parameters,
      jobId: jobId!,
    );
  }
}
