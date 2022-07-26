part of arcgis_maps_flutter;

class ExportTileCacheTask extends ArcgisNativeObject
    with RemoteResource, ApiKeyResource {
  final String _url;

  ExportTileCacheTask({required String url}) : _url = url;

  @override
  String get type => 'ExportTileCacheTask';

  @override
  @protected
  dynamic getCreateArguments() => _url;

  Future<ExportTileCacheParameters> createDefaultExportTileCacheParameters({
    required Geometry areaOfInterest,
    required double minScale,
    required double maxScale,
  }) async {
    final result = await invokeMethod(
        'exportTileCacheTask#createDefaultExportTileCacheParameters', {
      'areaOfInterest': areaOfInterest.toJson(),
      'minScale': minScale,
      'maxScale': maxScale,
    });
    return ExportTileCacheParameters.fromJson(result);
  }

  Future<EstimateTileCacheSizeJob> estimateTileCacheSizeJob({
    required ExportTileCacheParameters parameters,
  }) async {
    final jobId = await invokeMethod<String>(
      'exportTileCacheTask#estimateTileCacheSizeJob',
      parameters.toJson(),
    );
    return EstimateTileCacheSizeJob._(jobId: jobId!);
  }

  Future<ExportTileCacheJob> exportTileCacheJob({
    required ExportTileCacheParameters parameters,
    required String fileNameWithPath,
  }) async {
    final jobId = await invokeMethod<String>(
      'exportTileCacheTask#exportTileCacheJob',
      {
        'parameters': parameters.toJson(),
        'fileNameWithPath': fileNameWithPath,
      },
    );
    return ExportTileCacheJob._(jobId: jobId!);
  }
}
