part of arcgis_maps_flutter;

enum SyncModel {
  /// The geodatabase is not sync enabled.
  none(0),

  /// ayers within a geodatabase cannot be synchronized independently,
  /// the whole geodatabase must be synced. The sync operation and sync
  /// direction applies to all the layers in the geodatabase.
  geodatabase(1),

  /// Layers within a geodatabase can be synchronized independently of one another.
  /// Any subset of the layers can be synchronized when running the sync operation.
  /// Also, each layer's sync direction can be set independently.
  layer(2);

  const SyncModel(this.value);

  factory SyncModel.fromValue(int value) {
    return SyncModel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SyncModel.none,
    );
  }

  final int value;
}