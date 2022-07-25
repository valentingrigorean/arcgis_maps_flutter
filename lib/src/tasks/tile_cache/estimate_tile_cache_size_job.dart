part of arcgis_maps_flutter;

class EstimateTileCacheSizeResult {
  const EstimateTileCacheSizeResult({
    required this.fileSize,
    required this.tileCount,
  });

  factory EstimateTileCacheSizeResult.fromJson(Map<dynamic, dynamic> json) {
    return EstimateTileCacheSizeResult(
      fileSize: json['fileSize'] as int,
      tileCount: json['tileCount'] as int,
    );
  }

  final int fileSize;
  final int tileCount;
}

class EstimateTileCacheSizeJob extends ArcgisNativeObject with Job {
  EstimateTileCacheSizeJob._({required String jobId}) : super(objectId: jobId);

  Future<EstimateTileCacheSizeResult?> get result async {
    final resultJson = await invokeMethod("estimateTileCacheSizeJob#getResult");
    return resultJson == null ? null : EstimateTileCacheSizeResult.fromJson(resultJson);
  }

  @override
  String get type => "EstimateTileCacheSizeJob";
}
