part of arcgis_maps_flutter;

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
