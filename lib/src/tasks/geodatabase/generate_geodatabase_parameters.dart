part of arcgis_maps_flutter;

enum GeodatabaseAttachmentSyncDirection {
  /// There is no specified attachment sync direction.
  none(0),

  /// The attachment changes are uploaded only.
  upload(1),

  /// The attachment changes are both uploaded and downloaded.
  bidirectional(2);

  const GeodatabaseAttachmentSyncDirection(this.value);

  factory GeodatabaseAttachmentSyncDirection.fromValue(int value) {
    return GeodatabaseAttachmentSyncDirection.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GeodatabaseAttachmentSyncDirection.none,
    );
  }

  final int value;
}

enum UtilityNetworkSyncMode {
  /// No utility network resource will be synced.
  none(0),

  /// Utility Network system tables will be synced.
  syncSystemTables(1),
  syncSystemAndTopologyTables(2),
  ;

  const UtilityNetworkSyncMode(this.value);

  factory UtilityNetworkSyncMode.fromValue(int value) {
    return UtilityNetworkSyncMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UtilityNetworkSyncMode.none,
    );
  }

  final int value;
}

class GenerateGeodatabaseParameters {
  const GenerateGeodatabaseParameters({
    this.attachmentSyncDirection = GeodatabaseAttachmentSyncDirection.none,
    this.extent,
    this.layerOptions = const [],
    this.outSpatialReference,
    this.returnAttachments = false,
    this.shouldSyncContingentValues = true,
    this.syncModel = SyncModel.layer,
    this.utilityNetworkSyncMode = UtilityNetworkSyncMode.none,
  });

  factory GenerateGeodatabaseParameters.fromJson(Map<dynamic, dynamic> json) {
    return GenerateGeodatabaseParameters(
      attachmentSyncDirection: GeodatabaseAttachmentSyncDirection.fromValue(
          json['attachmentSyncDirection']),
      extent: Geometry.fromJson(json['extent']),
      layerOptions: (json['layerOptions'] as List)
          .map((e) => GenerateLayerOption.fromJson(e))
          .toList(),
      outSpatialReference:
          SpatialReference.fromJson(json['outSpatialReference']),
      returnAttachments: json['returnAttachments'] as bool,
      shouldSyncContingentValues: json['shouldSyncContingentValues'] as bool,
      syncModel: SyncModel.fromValue(json['syncModel'] as int),
      utilityNetworkSyncMode: UtilityNetworkSyncMode.fromValue(
          json['utilityNetworkSyncMode'] as int),
    );
  }

  /// Specifies how the geodatabase should be configured to sync attachment
  /// data with its originating service.
  final GeodatabaseAttachmentSyncDirection attachmentSyncDirection;

  /// The geographic extent within which features will be included in the
  /// sync-enabled geodatabase. To include non-spatial records, you must
  /// properly set up the [layerOptions] for that layer to include a
  /// [GenerateLayerOption.whereClause] and set [GenerateLayerOption.useGeometry]
  /// to false.
  final Geometry? extent;

  /// Options specifiying how to filter features for inclusion into the
  /// sync-enabled geodatabase on a layer-by-layer basis.
  /// If not specified, all features within the extent are included.
  /// For non-spatial records, you must set [GenerateLayerOption.useGeometry]
  /// to false and provide [GenerateLayerOption.whereClause].
  final List<GenerateLayerOption> layerOptions;

  /// The spatial reference in which you would like the generated geodatabase.
  /// If the data on the server is not in this spatial reference,
  /// it will be reprojected before being included in the geodatabase.
  final SpatialReference? outSpatialReference;

  /// Indicates whether or not the sync-enabled geodatabase should contain
  /// attachments for the features that are included. Only applicable
  /// if the feature service supports attachments.
  final bool returnAttachments;

  /// A Boolean value that indicates whether contingent value data is to be
  /// included from the service when either generating or synchronizing
  /// with an offline geodatabase.
  /// Feature layers and tables are always included in the generation and
  /// synchronization of the geodatabase.
  /// Contingent value data can be optionally included.
  ///
  /// The default value is true. Contingent Value data will be included.
  ///
  /// @c AGSSyncCapabilities#supportsContingentValues can be used to check
  /// whether vontingent value data is available from the service.
  ///
  /// This property can be used at the same time as specifying other
  /// additional data types to be included.
  final bool shouldSyncContingentValues;

  /// Specifies whether the geodatabase should be configured to sync with the
  /// originating service as a whole or individually on a per layer basis.
  final SyncModel syncModel;

  /// Specifies the generation and synchronization mode of Utility Network data
  /// from the service to an offline geodatabase.
  /// Feature layers and tables are always included in the generation and
  /// synchronization of the geodatabase.
  /// Utility Network System data can be optionally included.
  ///
  /// The default value is [UtilityNetworkSyncMode.none].
  /// Utility Network System data will not be included.
  ///
  /// This property can be used at the same time as specifying other
  /// additional data types to be included.
  final UtilityNetworkSyncMode utilityNetworkSyncMode;

  GenerateGeodatabaseParameters copyWith({
    GeodatabaseAttachmentSyncDirection? attachmentSyncDirection,
    Geometry? extent,
    List<GenerateLayerOption>? layerOptions,
    SpatialReference? outSpatialReference,
    bool? returnAttachments,
    bool? shouldSyncContingentValues,
    SyncModel? syncModel,
    UtilityNetworkSyncMode? utilityNetworkSyncMode,
  }) {
    return GenerateGeodatabaseParameters(
      attachmentSyncDirection:
          attachmentSyncDirection ?? this.attachmentSyncDirection,
      extent: extent ?? this.extent,
      layerOptions: layerOptions ?? this.layerOptions,
      outSpatialReference: outSpatialReference ?? this.outSpatialReference,
      returnAttachments: returnAttachments ?? this.returnAttachments,
      shouldSyncContingentValues:
          shouldSyncContingentValues ?? this.shouldSyncContingentValues,
      syncModel: syncModel ?? this.syncModel,
      utilityNetworkSyncMode:
          utilityNetworkSyncMode ?? this.utilityNetworkSyncMode,
    );
  }

  Object toJson() {
    return {
      'attachmentSyncDirection': attachmentSyncDirection.value,
      if (extent != null) 'extent': extent!.toJson(),
      'layerOptions': layerOptions.map((e) => e.toJson()).toList(),
      if (outSpatialReference != null)
        'outSpatialReference': outSpatialReference!.toJson(),
      'returnAttachments': returnAttachments,
      'shouldSyncContingentValues': shouldSyncContingentValues,
      'syncModel': syncModel.value,
      'utilityNetworkSyncMode': utilityNetworkSyncMode.value,
    };
  }
}
