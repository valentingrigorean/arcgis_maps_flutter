part of arcgis_maps_flutter;

class ExportTileCacheJob extends ArcgisNativeObject with Job {
  ExportTileCacheJob._({required String jobId}) : super(objectId: jobId);

  @override
  String get type => "ExportTileCacheJob";
}
