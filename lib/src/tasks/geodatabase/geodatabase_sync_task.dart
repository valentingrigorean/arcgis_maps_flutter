part of arcgis_maps_flutter;

class GeodatabaseSyncTask extends ArcgisNativeObject
    with Loadable, RemoteResource, ApiKeyResource {
  final String _url;

  GeodatabaseSyncTask({required String url}) : _url = url;

  @override
  String get type => 'GeodatabaseSyncTask';

  @override
  @protected
  dynamic getCreateArguments() => _url;

  Future<GenerateGeodatabaseParameters> defaultGenerateGeodatabaseParameters({
    required Geometry areaOfInterest,
  }) async {
    final result = await invokeMethod(
      'geodatabaseSyncTask#defaultGenerateGeodatabaseParameters',
      areaOfInterest.toJson(),
    );
    return GenerateGeodatabaseParameters.fromJson(result);
  }

  Future<GenerateGeodatabaseJob> generateJob({
    required GenerateGeodatabaseParameters parameters,
    required String fileNameWithPath,
  }) async {
    final jobId = await invokeMethod<String>(
      'geodatabaseSyncTask#generateJob',
      {
        'parameters': parameters.toJson(),
        'fileNameWithPath': fileNameWithPath,
      },
    );
    return GenerateGeodatabaseJob._(jobId: jobId!);
  }
}
