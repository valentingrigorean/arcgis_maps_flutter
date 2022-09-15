part of arcgis_maps_flutter;

class SyncLayerOption {
  const SyncLayerOption({
    this.layerId = 0,
    this.syncDirection = SyncDirection.bidirectional,
  });

  factory SyncLayerOption.fromJson(Map<dynamic, dynamic> json) {
    return SyncLayerOption(
      layerId: json['layerId'] as int,
      syncDirection: SyncDirection.fromValue(json['syncDirection'] as int),
    );
  }

  final int layerId;
  final SyncDirection syncDirection;

  SyncLayerOption copyWith({
    int? layerId,
    SyncDirection? syncDirection,
  }) {
    return SyncLayerOption(
      layerId: layerId ?? this.layerId,
      syncDirection: syncDirection ?? this.syncDirection,
    );
  }

  Object toJson() {
    return {
      'layerId': layerId,
      'syncDirection': syncDirection.value,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncLayerOption &&
          runtimeType == other.runtimeType &&
          layerId == other.layerId &&
          syncDirection == other.syncDirection;

  @override
  int get hashCode => layerId.hashCode ^ syncDirection.hashCode;

  @override
  String toString() {
    return 'SyncLayerOption{layerId: $layerId, syncDirection: $syncDirection}';
  }
}

class SyncGeodatabaseParameters {
  const SyncGeodatabaseParameters({
    this.keepGeodatabaseDeltas = false,
    this.geodatabaseSyncDirection = SyncDirection.bidirectional,
    this.layerOptions = const [],
    this.rollbackOnFailure = false,
  });

  factory SyncGeodatabaseParameters.fromJson(Map<dynamic, dynamic> json) {
    return SyncGeodatabaseParameters(
      keepGeodatabaseDeltas: json['keepGeodatabaseDeltas'] as bool,
      geodatabaseSyncDirection:
          SyncDirection.fromValue(json['geodatabaseSyncDirection'] as int),
      layerOptions: (json['layerOptions'] as List<dynamic>)
          .map((e) => SyncLayerOption.fromJson(e as Map<dynamic, dynamic>))
          .toList(),
      rollbackOnFailure: json['rollbackOnFailure'] as bool,
    );
  }

  /// Specifies the direction in which the entire geodatabase must sync
  /// changes with the service.
  /// Only applicable if the geodatabase uses a sync model
  /// of [GeodatabaseSyncTask].Otherwise, use [layerOptions].
  final SyncDirection geodatabaseSyncDirection;

  /// Indicates whether or not the upload or downloaded server delta
  /// geodatabases will be removed at the end of the sync job.
  final bool keepGeodatabaseDeltas;

  /// Options specifying the direction in which individual layers in the
  /// geodatabase must sync changes with the service.
  /// Not all layers need to be included in the sync operation.
  /// Some of them can be excluded by leaving them out of this array.
  final List<SyncLayerOption> layerOptions;

  /// Specifies whether all edits are rolled back (not applied)
  /// if a failure occurs while importing edits on the server. Otherwise,
  /// failed edits are skipped and other edits still applied.
  final bool rollbackOnFailure;

  SyncGeodatabaseParameters copyWith({
    bool? keepGeodatabaseDeltas,
    SyncDirection? geodatabaseSyncDirection,
    List<SyncLayerOption>? layerOptions,
    bool? rollbackOnFailure,
  }) {
    return SyncGeodatabaseParameters(
      keepGeodatabaseDeltas:
          keepGeodatabaseDeltas ?? this.keepGeodatabaseDeltas,
      geodatabaseSyncDirection:
          geodatabaseSyncDirection ?? this.geodatabaseSyncDirection,
      layerOptions: layerOptions ?? this.layerOptions,
      rollbackOnFailure: rollbackOnFailure ?? this.rollbackOnFailure,
    );
  }

  Object toJson() {
    return {
      'keepGeodatabaseDeltas': keepGeodatabaseDeltas,
      'geodatabaseSyncDirection': geodatabaseSyncDirection.value,
      'layerOptions': layerOptions.map((e) => e.toJson()).toList(),
      'rollbackOnFailure': rollbackOnFailure,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncGeodatabaseParameters &&
          runtimeType == other.runtimeType &&
          geodatabaseSyncDirection == other.geodatabaseSyncDirection &&
          keepGeodatabaseDeltas == other.keepGeodatabaseDeltas &&
          layerOptions == other.layerOptions &&
          rollbackOnFailure == other.rollbackOnFailure;

  @override
  int get hashCode =>
      geodatabaseSyncDirection.hashCode ^
      keepGeodatabaseDeltas.hashCode ^
      layerOptions.hashCode ^
      rollbackOnFailure.hashCode;

  @override
  String toString() {
    return 'SyncGeodatabaseParameters{geodatabaseSyncDirection: $geodatabaseSyncDirection, keepGeodatabaseDeltas: $keepGeodatabaseDeltas, layerOptions: $layerOptions, rollbackOnFailure: $rollbackOnFailure}';
  }
}
