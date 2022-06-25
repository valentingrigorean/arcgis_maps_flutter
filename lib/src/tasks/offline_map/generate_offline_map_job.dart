part of arcgis_maps_flutter;

abstract class GenerateOfflineMapJob {
  String? get downloadDirectory;

  GenerateOfflineMapResult? get result;

  ArcGISMap? get onlineMap;

  GenerateOfflineMapParameters? get parameters;

  Future<double> get progress;

  Stream<double> get onProgressChanged;

  Future<JobStatus> get status;

  Stream<JobStatus> get onStatusChanged;

  Future<bool> start();

  Future<bool> cancel();

  Future<bool> pause();

  void dispose();
}
