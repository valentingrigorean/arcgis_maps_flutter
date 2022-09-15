part of arcgis_maps_flutter;

class SyncLayerResult {
  const SyncLayerResult._({
    required this.editResults,
    required this.layerId,
    required this.tableName,
  });

  factory SyncLayerResult._fromJson(Map<dynamic, dynamic> json) {
    return SyncLayerResult._(
      editResults: (json['editResults'] as List<dynamic>)
          .map((e) => EditResult.fromJson(e as Map<dynamic, dynamic>))
          .toList(),
      layerId: json['layerId'] as int,
      tableName: json['tableName'] as String,
    );
  }

  final List<EditResult> editResults;

  final int layerId;

  final String tableName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncLayerResult &&
          runtimeType == other.runtimeType &&
          editResults == other.editResults &&
          layerId == other.layerId &&
          tableName == other.tableName;

  @override
  int get hashCode =>
      editResults.hashCode ^ layerId.hashCode ^ tableName.hashCode;

  @override
  String toString() {
    return 'SyncLayerResult{editResults: $editResults, layerId: $layerId, tableName: $tableName}';
  }
}

class SyncGeodatabaseJob extends Job {
  SyncGeodatabaseJob._({
    required String jobId,
  }) : super(
          objectId: jobId,
          isCreated: true,
        );

  @override
  String get type => 'SyncGeodatabaseJob';

  /// Returns information on geodatabase upload and download delta files.
  Future<GeodatabaseDeltaInfo?> get geodatabaseDeltaInfo async {
    final result =
        await invokeMethod('syncGeodatabaseJob#getGeodatabaseDeltaInfo');
    if (result == null) {
      return null;
    }
    return GeodatabaseDeltaInfo._fromJson(result);
  }

  /// For a successfully completed job, an array of [SyncLayerResult] is returned.
  /// If all edits to the geodatabase's tables and layers are synced successfully,
  /// an empty array is returned.
  Future<List<SyncLayerResult>?> get result async {
    final result = await invokeMethod('syncGeodatabaseJob#getResult');
    if (result == null) {
      return null;
    }
    return (result as List<dynamic>)
        .map((e) => SyncLayerResult._fromJson(e))
        .toList();
  }
}
