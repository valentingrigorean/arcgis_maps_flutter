part of arcgis_maps_flutter;

enum OfflineMapAttachmentSyncDirection {
  /// There is no specified attachment sync direction.
  none(0),

  /// The attachment changes are uploaded only.
  birectional(1),

  /// The attachment changes are both uploaded and downloaded.
  upload(2);

  const OfflineMapAttachmentSyncDirection(this.value);

  factory OfflineMapAttachmentSyncDirection.fromValue(int value) {
    return OfflineMapAttachmentSyncDirection.values.firstWhere(
          (e) => e.value == value,
      orElse: () => OfflineMapAttachmentSyncDirection.none,
    );
  }

  final int value;
}

enum SyncDirection {
  /// No changes are synced.
  none(0),

  /// Only download changes from the service during sync.
  download(1),

  /// Only upload changes from the client to the service during sync.
  upload(2),

  /// Both download and upload changes.
  bidirectional(3);

  const SyncDirection(this.value);

  factory SyncDirection.fromValue(int value) {
    return SyncDirection.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SyncDirection.none,
    );
  }

  final int value;
}


enum OnlineOnlyServicesOption {
  /// Online layers and tables that cannot be taken offline will
  /// be excluded when taking a map offline.
  exclude(0),

  /// Online layers and tables that cannot be taken offline will be
  /// included when taking a map offline and will continue to reference the online service.
  include(1),

  /// A given layer or table will be taken offline, included as online content,
  /// or excluded according to the settings in the web map.
  useAuthoredSettings(2);

  const OnlineOnlyServicesOption(this.value);

  factory OnlineOnlyServicesOption.fromValue(int value) {
    return OnlineOnlyServicesOption.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OnlineOnlyServicesOption.exclude,
    );
  }

  final int value;
}

enum ReturnLayerAttachmentOption {
  /// Don't include attachments when taking feature layers offline.
  none(0),

  /// Include attachments with all feature layers when taking offline.
  allLayers(1),

  /// Only include attachments with read-only feature layers when taking offline.
  readOnlyLayers(2),

  /// Only include attachments with editable feature layers when taking offline.
  /// For offline maps, a feature layer is considered to be editable if the
  /// feature service has capabilities that include any of create, update,
  /// or delete. A read-only layer is one that supports sync
  /// , but does not have any of create, update, or delete capability.
  /// Service capabilities are accessible from service infos.
  /// See @c AGSArcGISFeatureServiceInfo#featureServiceCapabilities
  /// or @c AGSArcGISFeatureLayerInfo#capabilities.
  editableLayers(3);

  const ReturnLayerAttachmentOption(this.value);

  factory ReturnLayerAttachmentOption.fromValue(int value) {
    return ReturnLayerAttachmentOption.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReturnLayerAttachmentOption.none,
    );
  }

  final int value;
}

enum GenerateOfflineMapUpdateMode {
  /// Changes, including local edits, will be synced directly
  /// with the underlying feature services.
  syncWithFeatureServices(0),

  /// No feature updates will be performed.
  noUpdates(1);

  const GenerateOfflineMapUpdateMode(this.value);

  factory GenerateOfflineMapUpdateMode.fromValue(int value) {
    return GenerateOfflineMapUpdateMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GenerateOfflineMapUpdateMode.syncWithFeatureServices,
    );
  }

  final int value;
}

enum DestinationTableRowFilter {
  /// All rows of a table will be take offline.
  all(0),

  /// Where appropriate, a table will be filtered to only
  /// related rows when taking the table offline.
  relatedOnly(1);

  const DestinationTableRowFilter(this.value);

  factory DestinationTableRowFilter.fromValue(int value) {
    return DestinationTableRowFilter.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DestinationTableRowFilter.all,
    );
  }

  final int value;
}

enum EsriVectorTilesDownloadOption {
  /// The complete set of vector tile resources for the original service,
  /// including the full set of fonts, will be downloaded.
  useOriginalService(0),

  /// An alternative service that uses a reduced set of font resources,
  /// supporting a limited set of language characters, will be downloaded.
  useReducedFontsService(1);

  const EsriVectorTilesDownloadOption(this.value);

  factory EsriVectorTilesDownloadOption.fromValue(int value) {
    return EsriVectorTilesDownloadOption.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EsriVectorTilesDownloadOption.useOriginalService,
    );
  }

  final int value;
}

class GenerateOfflineMapParameters {
  const GenerateOfflineMapParameters({
    required this.areaOfInterest,
    this.minScale = 0,
    this.maxScale = 0,
    this.onlineOnlyServicesOption = OnlineOnlyServicesOption.exclude,
    this.itemInfo,
    this.attachmentSyncDirection = OfflineMapAttachmentSyncDirection.birectional,
    this.continueOnErrors = true,
    this.includeBasemap = true,
    this.isDefinitionExpressionFilterEnabled = true,
    this.returnLayerAttachmentOption = ReturnLayerAttachmentOption.allLayers,
    this.returnSchemaOnlyForEditableLayers = false,
    this.updateMode = GenerateOfflineMapUpdateMode.syncWithFeatureServices,
    this.destinationTableRowFilter = DestinationTableRowFilter.relatedOnly,
    this.esriVectorTilesDownloadOption =
        EsriVectorTilesDownloadOption.useOriginalService,
    this.referenceBasemapDirectory = '',
    this.referenceBasemapFilename = '',
  });

  factory GenerateOfflineMapParameters.fromJson(Map<dynamic, dynamic> json) {
    return GenerateOfflineMapParameters(
      areaOfInterest: Geometry.fromJson(json['areaOfInterest'])!,
      minScale: (json['minScale'] as num).toDouble(),
      maxScale: (json['maxScale'] as num).toDouble(),
      onlineOnlyServicesOption: OnlineOnlyServicesOption.fromValue(
          (json['onlineOnlyServicesOption'] as num).toInt()),
      itemInfo: json.containsKey('itemInfo')
          ? OfflineMapItemInfo.fromJson(
              json['itemInfo'] as Map<dynamic, dynamic>)
          : null,
      attachmentSyncDirection: OfflineMapAttachmentSyncDirection.fromValue(
          (json['attachmentSyncDirection'] as num).toInt()),
      continueOnErrors: json['continueOnErrors'] as bool,
      includeBasemap: json['includeBasemap'] as bool,
      isDefinitionExpressionFilterEnabled:
          json['isDefinitionExpressionFilterEnabled'] as bool,
      returnLayerAttachmentOption: ReturnLayerAttachmentOption.fromValue(
          (json['returnLayerAttachmentOption'] as num).toInt()),
      returnSchemaOnlyForEditableLayers:
          json['returnSchemaOnlyForEditableLayers'] as bool,
      updateMode: GenerateOfflineMapUpdateMode.fromValue(
          (json['updateMode'] as num).toInt()),
      destinationTableRowFilter: DestinationTableRowFilter.fromValue(
          (json['destinationTableRowFilter'] as num).toInt()),
      esriVectorTilesDownloadOption: EsriVectorTilesDownloadOption.fromValue(
          (json['esriVectorTilesDownloadOption'] as num).toInt()),
      referenceBasemapDirectory:
          (json['referenceBasemapDirectory'] as String?) ?? '',
      referenceBasemapFilename: json['referenceBasemapFilename'] as String,
    );
  }

  /// An [AGSPolygon] or [AGSEnvelope] geometry that defines the geographic area
  /// for which the map data (features and tiles) should be taken offline.
  /// Where an [AGSPolygon] object supplied, features and tiles will be filtered
  /// according to the polygon geometry, which can help
  /// reduce the size of the resulting offline map. Note that the filtered set
  /// of tiles may vary, depending on the underlying service.
  final Geometry areaOfInterest;

  /// The minimum scale for how far out data will be in tile caches.
  /// The [minScale] 0 default means extract all the available detailed levels to global scales.
  final double minScale;

  /// The maximum scale for how far in to extract tiles from tile caches.
  /// The [maxScale] 0 default means extract the levels down to the most detailed.
  ///
  final double maxScale;

  /// Describes how data that requires an online service will be handled
  /// when taking a map offline.
  final OnlineOnlyServicesOption onlineOnlyServicesOption;

  /// Metadata about the map that should be persisted when it is taken offline.
  /// hen using the convenience method
  /// [OfflineMapTask.defaultGenerateOfflineMapParameters] to get the
  /// default parameters, this metadata is initialized based on the map's portal item.
  final OfflineMapItemInfo? itemInfo;

  /// Specifies how sync-enabled feature layers in the offline map should be
  /// configured to sync attachment data with their originating service.
  /// This property should be used in conjunction with the [returnLayerAttachmentOption]
  /// property to determine which layers should be taken offline with attachments included.
  /// This property is valid when the service resource sync capabilities includes
  /// supportsAttachmentsSyncDirection otherwise it is ignored.
  /// This property works in conjunction with the [returnLayerAttachmentOption]
  /// property and in some cases may have its value overridden as shown below:
  /// | Layer Attachment Option      | Valid Attachment Sync Direction   | Note                                                                                  |
  /// | ----------------------       | --------------------------------- | ---------------------------                                                           |
  /// | None                         | None                              |                                                                                       |
  /// |                              | Upload                            |                                                                                       |
  /// | All Layers                   | Upload                            |                                                                                       |
  /// |                              | Bidirectional                     |                                                                                       |
  /// | Read Only Layers             | None                              | Layers *with* attachments will treat this as attachmentSyncDirection = Bidirectional  |
  /// |                              | Upload                            |                                                                                       |
  /// |                              | Bidirectional                     | Layers *without* attachments will treat this as attachmentSyncDirection = None        |
  /// | Editable Layers              | None                              | Layers *with* attachments will treat this as attachmentSyncDirection = Bidirectional  |
  /// |                              | Upload                            |                                                                                       |
  /// |                              | Bidirectional                     | Layers *without* attachments will treat this as attachmentSyncDirection = None        |
  /// If [GenerateOfflineMapParameters] is used in conjunction with  [GenerateOfflineMapParameterOverrides]
  /// this property is superseded.
  final OfflineMapAttachmentSyncDirection attachmentSyncDirection;

  /// Indicates whether or not the job should continue running in the event of
  /// a failure to take a layer offline.
  /// If this property is [true], failure to take a layer or table offline will
  /// not fail the job, the failure will be exposed in the job result.
  /// If this property is [false], failure to take a layer or table offline
  /// will fail the job and no more layers or tables will be taken offline.
  /// The layer or table's error will be available as the job's error.
  /// Default value is [true].
  final bool continueOnErrors;

  /// Indicates whether or not a basemap will be included in the offline map.
  /// If you do not want a basemap in the offline map, then set this property to [false].
  /// After loading the offline map, your application can programmatically insert a basemap into the map.
  /// Note that a programmatically inserted basemap will not be persisted in the map.
  ///
  /// If you want a basemap in the offline map, then set this property to [true]. You can choose to either:
  /// Generate and download the online basemap using the [GenerateOfflineMapJob] object. This is the default.
  /// Use a local basemap on the device by setting the [GenerateOfflineMapParameters.referenceBasemapDirectory] property
  ///
  /// The default value is [true].
  /// This property is superseded if the [GenerateOfflineMapParameters] object
  /// is used in conjunction with an [AGSGenerateOfflineMapParameterOverrides] object.
  final bool includeBasemap;

  /// A value of [true] allows the[GenerateOfflineMapJob] object to use the SQL where clause in the
  /// AGSFeatureLayer#definitionExpression propety as a filter when generating offline geodatabases.
  /// Applying the definition expression may reduce the number of features
  /// taken offline for display and sync.
  /// If the value is [false] this could result in a larger
  /// geodatabase than is required to display the feature layer.
  /// The default value is [true]. For tables, the definition expression is taken from the property
  /// AGSServiceFeatureTable#definitionExpression.
  /// If the [GenerateOfflineMapParameters] object is used in conjunction with the
  /// [AGSGenerateOfflineMapParameterOverrides] object, this property is superseded.
  final bool isDefinitionExpressionFilterEnabled;

  /// Specifies whether or not to include attachments for feature layers when taking the map offline.
  /// Attachments can be included with none of the layers, all of the layers,
  /// read only layers or editable layers. This option should be used in conjunction
  /// with the [attachmentSyncDirection] proprety to control how the attachments are synced.
  final ReturnLayerAttachmentOption returnLayerAttachmentOption;

  /// Specifies whether to only include the schema or also include data for feature
  /// layers when taking the map offline.
  /// If the [GenerateOfflineMapParameters] object is used in conjunction with the [GenerateOfflineMapParameterOverrides]
  /// object this property is superseded.
  final bool returnSchemaOnlyForEditableLayers;

  /// Describes how the offline map will support synchronization with online services.
  /// A value of [GenerateOfflineMapUpdateMode.syncWithFeatureServices] instructs [GenerateOfflineMapJob]
  /// object to create offline geodatabases that support syncing with online feature services.
  /// A value of [GenerateOfflineMapUpdateMode.noUpdates] instructs the [GenerateOfflineMapJob] object to disable
  /// data synchronization for generated offline geodatabases. In this case, no synchronization replicas will be
  /// created on corresponding feature services. This reduces the load on the feature server and frees
  /// the developer from needing to unregister server replicas when they are no longer needed.
  /// The default value is [GenerateOfflineMapUpdateMode.syncWithFeatureServices].
  final GenerateOfflineMapUpdateMode updateMode;

  /// Specifies whether tables in relationships will contain all rows or can
  /// be filtered to a smaller set of related rows
  final DestinationTableRowFilter destinationTableRowFilter;

  /// Describes how Esri vector tiled basemap layers will be downloaded.
  /// This property lets you choose how to download Esri vector tiled basemap layers. This
  /// property only applies when taking an Esri vector tile basemap service offline.
  final EsriVectorTilesDownloadOption esriVectorTilesDownloadOption;

  /// The path to a directory on the device where the local basemap file is located.
  /// Set this property to use a basemap that is already on the device (rather than downloading it).
  /// The directory should only be set when the parameters have an [referenceBasemapFilename] defined.
  /// This property supports any directory specified as either:
  /// - An absolute path
  /// - A path relative to the parent directory of the generated mobile map package
  /// If the directory does not exist, or does not contain the specified basemap,
  /// the [GenerateOfflineMapJob] will fail.
  final String referenceBasemapDirectory;

  /// The name of a local basemap file on the device that can be used rather than downloading an online basemap.
  /// The local basemap filename must end with .tpk, .tpkx or .vtpk since these are the supported file formats. This property can be read directly
  /// from settings applied by the author of the online web map (see @c AGSOfflineSettings) or set by user code to a file known to be
  /// on the device. This property will be populated from online settings when created with @c AGSOfflineMapTask#defaultGenerateOfflineMapParametersWithAreaOfInterest:minScale:maxScale:completion.
  /// If you wish to use the specified local basemap rather than downloading, you must also set @c AGSGenerateOfflineMapParameters#referenceBasemapDirectory.
  /// If the directory does not exist, or does not contain the specified basemap, the @c AGSGenerateOfflineMapJob will fail.
  /// The spatial reference of the reference basemap is used for the offline map when it is different to the online map's spatial reference.
  /// Note that this property is ignored if @c AGSGenerateOfflineMapParameters#includeBasemap is [false].
  final String referenceBasemapFilename;

  Object toJson() {
    final Map<String, dynamic> json = {};
    json['areaOfInterest'] = areaOfInterest.toJson();
    json['minScale'] = minScale;
    json['maxScale'] = maxScale;
    json['onlineOnlyServicesOption'] = onlineOnlyServicesOption.value;
    if(itemInfo != null){
      json['itemInfo'] = itemInfo!.toJson();
    }
    json['attachmentSyncDirection'] = attachmentSyncDirection.value;
    json['continueOnErrors'] = continueOnErrors;
    json['includeBasemap'] = includeBasemap;
    json['isDefinitionExpressionFilterEnabled'] = isDefinitionExpressionFilterEnabled;
    json['returnLayerAttachmentOption'] = returnLayerAttachmentOption.value;
    json['returnSchemaOnlyForEditableLayers'] = returnSchemaOnlyForEditableLayers;
    json['updateMode'] = updateMode.value;
    json['destinationTableRowFilter'] = destinationTableRowFilter.value;
    json['esriVectorTilesDownloadOption'] = esriVectorTilesDownloadOption.value;
    json['referenceBasemapDirectory'] = referenceBasemapDirectory;
    json['referenceBasemapFilename'] = referenceBasemapFilename;
    return json;
  }

  @override
  String toString() {
    return 'GenerateOfflineMapParameters{areaOfInterest: $areaOfInterest, minScale: $minScale, maxScale: $maxScale, onlineOnlyServicesOption: $onlineOnlyServicesOption, itemInfo: $itemInfo, attachmentSyncDirection: $attachmentSyncDirection, continueOnErrors: $continueOnErrors, includeBasemap: $includeBasemap, isDefinitionExpressionFilterEnabled: $isDefinitionExpressionFilterEnabled, returnLayerAttachmentOption: $returnLayerAttachmentOption, returnSchemaOnlyForEditableLayers: $returnSchemaOnlyForEditableLayers, updateMode: $updateMode, destinationTableRowFilter: $destinationTableRowFilter, esriVectorTilesDownloadOption: $esriVectorTilesDownloadOption, referenceBasemapDirectory: $referenceBasemapDirectory, referenceBasemapFilename: $referenceBasemapFilename}';
  }
}
