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
      arguments: areaOfInterest.toJson(),
    );
    return GenerateGeodatabaseParameters.fromJson(result);
  }

  Future<GenerateGeodatabaseJob> generateJob({
    required GenerateGeodatabaseParameters parameters,
    required String fileNameWithPath,
  }) async {
    final jobId = await invokeMethod<String>(
      'geodatabaseSyncTask#generateJob',
      arguments: {
        'parameters': parameters.toJson(),
        'fileNameWithPath': fileNameWithPath,
      },
    );
    return GenerateGeodatabaseJob._(jobId: jobId!);
  }

  Future<SyncGeodatabaseParameters> defaultSyncGeodatabaseParameters({
    required Geodatabase geodatabase,
    SyncDirection? syncDirection,
  }) async {
    final result = await invokeMethod(
      'geodatabaseSyncTask#defaultSyncGeodatabaseParameters',
      arguments: geodatabase.toJson(),
    );
    return SyncGeodatabaseParameters.fromJson(result);
  }

  Future<SyncGeodatabaseJob> syncJob({
    required Geodatabase geodatabase,
    required SyncGeodatabaseParameters parameters,
  }) async {
    final jobId = await invokeMethod<String>(
      'geodatabaseSyncTask#syncJob',
      arguments: {
        'geodatabase': geodatabase.toJson(),
        'parameters': parameters.toJson(),
      },
    );
    return SyncGeodatabaseJob._(jobId: jobId!);
  }

  Future<SyncGeodatabaseJob> syncJobWithSyncDirection({
    required Geodatabase geodatabase,
    required SyncDirection syncDirection,
    required bool rollbackOnFailure,
  }) async {
    final jobId = await invokeMethod<String>(
      'geodatabaseSyncTask#syncJobWithSyncDirection',
      arguments: {
        'geodatabase': geodatabase.toJson(),
        'syncDirection': syncDirection.value,
        'rollbackOnFailure': rollbackOnFailure,
      },
    );
    return SyncGeodatabaseJob._(jobId: jobId!);
  }
}
