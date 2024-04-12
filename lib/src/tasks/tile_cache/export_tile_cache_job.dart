part of '../../../arcgis_maps_flutter.dart';

class ExportTileCacheJob extends Job {
  ExportTileCacheJob._({required String jobId})
      : super(
          objectId: jobId,
          isCreated: true,
        );

  @override
  String get type => "ExportTileCacheJob";
}
