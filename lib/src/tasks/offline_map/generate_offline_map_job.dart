part of arcgis_maps_flutter;

class GenerateOfflineMapJob extends Job {
  GenerateOfflineMapJob._({
    required String jobId,
    this.onlineMap,
    this.downloadDirectory,
    this.parameters,
  }) : super(
          objectId: jobId,
          isCreated: true,
        );

  @override
  String get type => 'GenerateOfflineMapJob';

  final ArcGISMap? onlineMap;

  final GenerateOfflineMapParameters? parameters;

  final String? downloadDirectory;
}
