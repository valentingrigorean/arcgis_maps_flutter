part of '../../../arcgis_maps_flutter.dart';

class GenerateGeodatabaseJob extends Job {
  GenerateGeodatabaseJob._({
    required String jobId,
  }) : super(
          objectId: jobId,
          isCreated: true,
        );

  @override
  String get type => 'GenerateGeodatabaseJob';
}
