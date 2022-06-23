part of arcgis_maps_flutter;

abstract class GenerateOfflineMapJob {
  String? get downloadDirectory;

  GenerateOfflineMapResult? get result;

  ArcGISMap? get onlineMap;

  GenerateOfflineMapParameters? get parameters;

  Future<double> get progress;

  Stream<double> get onProgressChanged;

  Future<bool> start();

  Future<bool> cancel();

  Future<bool> pause();
}
