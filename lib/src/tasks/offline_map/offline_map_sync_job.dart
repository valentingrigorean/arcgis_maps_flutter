part of arcgis_maps_flutter;

class OfflineMapSyncResult {
  OfflineMapSyncResult._({
    required this.hasErrors,
    required this.isMobileMapPackageReopenRequired,
  });

  factory OfflineMapSyncResult.fromJson(Map<dynamic, dynamic> json) {
    return OfflineMapSyncResult._(
      hasErrors: json['hasErrors'] as bool,
      isMobileMapPackageReopenRequired:
          json['isMobileMapPackageReopenRequired'] as bool,
    );
  }

  final bool hasErrors;

  /// Indicates whether the mobile map package must be closed and reopened with
  /// a new instance to allow the updates to take effect.
  final bool isMobileMapPackageReopenRequired;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineMapSyncResult &&
          runtimeType == other.runtimeType &&
          hasErrors == other.hasErrors &&
          isMobileMapPackageReopenRequired ==
              other.isMobileMapPackageReopenRequired;

  @override
  int get hashCode =>
      hasErrors.hashCode ^ isMobileMapPackageReopenRequired.hashCode;

  @override
  String toString() {
    return 'OfflineMapSyncResult{hasErrors: $hasErrors, isMobileMapPackageReopenRequired: $isMobileMapPackageReopenRequired}';
  }
}



class OfflineMapSyncJob extends Job {
  OfflineMapSyncJob._({
    required this.parameters,
    required super.objectId,
  }) : super(isCreated: true);

  final OfflineMapSyncParameters parameters;

  Future<List<GeodatabaseDeltaInfo>> get geodatabaseDeltaInfos async{
    final result = await invokeMethod('offlineMapSyncJob#getGeodatabaseDeltaInfos');
    if(result == null){
      return const [];
    }
    return (result as List<dynamic>).map((e) => GeodatabaseDeltaInfo._fromJson(e)).toList();
  }

  Future<OfflineMapSyncResult?> get result async {
    final res = await invokeMethod('offlineMapSyncJob#getResult');
    if (res == null) {
      return null;
    }
    return OfflineMapSyncResult.fromJson(res);
  }

  @override
  String get type => 'OfflineMapSyncJob';
}
