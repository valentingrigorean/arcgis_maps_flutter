part of arcgis_maps_flutter;

enum OfflineUpdateAvailability {
  /// There are updates available
  available(0),

  /// There are no updates available.
  none(1),

  /// It is not possible to determine whether updates are available,
  /// for example, because the operation is not supported.
  indeterminate(-1);

  const OfflineUpdateAvailability(this.value);

  factory OfflineUpdateAvailability.fromValue(int value) {
    return OfflineUpdateAvailability.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OfflineUpdateAvailability.indeterminate,
    );
  }

  final int value;
}

enum PreplannedScheduledUpdatesOption {
  /// No updates will be downloaded.
  noUpdates(0),

  /// All available updates for feature data will be downloaded.
  downloadAllUpdates(1);

  const PreplannedScheduledUpdatesOption(this.value);

  factory PreplannedScheduledUpdatesOption.fromValue(int value) {
    return PreplannedScheduledUpdatesOption.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PreplannedScheduledUpdatesOption.noUpdates,
    );
  }

  final int value;
}

class OfflineMapUpdateCapabilities {
  const OfflineMapUpdateCapabilities._(
    this.supportsScheduledUpdatesForFeatures,
    this.supportsSyncWithFeatureServices,
  );

  /// Whether an offline map supports downloading of read-only scheduled
  /// feature updates.
  /// If this property is true, updates are generated whenever
  /// the online map area is refreshed - for example according to its
  /// update schedule.
  final bool supportsScheduledUpdatesForFeatures;

  /// Whether an offline map references feature services which are sync enabled.
  final bool supportsSyncWithFeatureServices;

  factory OfflineMapUpdateCapabilities._fromJson(Map<dynamic, dynamic> json) {
    return OfflineMapUpdateCapabilities._(
      json['supportsScheduledUpdatesForFeatures'] as bool,
      json['supportsSyncWithFeatureServices'] as bool,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineMapUpdateCapabilities &&
          runtimeType == other.runtimeType &&
          supportsScheduledUpdatesForFeatures ==
              other.supportsScheduledUpdatesForFeatures &&
          supportsSyncWithFeatureServices ==
              other.supportsSyncWithFeatureServices;

  @override
  int get hashCode =>
      supportsScheduledUpdatesForFeatures.hashCode ^
      supportsSyncWithFeatureServices.hashCode;

  @override
  String toString() {
    return 'OfflineMapUpdateCapabilities{supportsScheduledUpdatesForFeatures: $supportsScheduledUpdatesForFeatures, supportsSyncWithFeatureServices: $supportsSyncWithFeatureServices}';
  }
}

class OfflineMapUpdatesInfo {
  const OfflineMapUpdatesInfo._({
    required this.downloadAvailability,
    required this.isMobileMapPackageReopenRequired,
    required this.scheduledUpdatesDownloadSize,
    required this.uploadAvailability,
  });

  factory OfflineMapUpdatesInfo._fromJson(Map<dynamic, dynamic> json) {
    return OfflineMapUpdatesInfo._(
      downloadAvailability: OfflineUpdateAvailability.fromValue(
          json['downloadAvailability'] as int),
      isMobileMapPackageReopenRequired:
          json['isMobileMapPackageReopenRequired'] as bool,
      scheduledUpdatesDownloadSize: json['scheduledUpdatesDownloadSize'] as int,
      uploadAvailability: OfflineUpdateAvailability.fromValue(
          json['uploadAvailability'] as int),
    );
  }

  /// Indicates whether there are changes available to download.
  final OfflineUpdateAvailability downloadAvailability;

  /// Indicates whether the mobile map package must be reopened after applying
  /// the available updates.
  /// In some cases, applying updates may require files, such as mobile
  /// geodatabases, to be replaced with a new version.
  /// When a reopen will be required after updating, this property will be true
  final bool isMobileMapPackageReopenRequired;

  /// The total size in bytes of update files to download for a scheduled
  /// updates workflow.
  /// The scheduled updates workflow allows read-only updates to be
  /// stored with the online map area and downloaded to your device at
  /// a later time.
  /// Updates can cover several sets of changes to the online geodatabase
  /// and can cover multiple geodatabases in an offline map.
  /// This property is the total download size of all files
  /// required to update your offline map.
  final int scheduledUpdatesDownloadSize;

  /// Indicates whether there are local changes to upload.
  /// If your offline map contains local edits that can be uploaded
  /// to online feature services
  final OfflineUpdateAvailability uploadAvailability;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineMapUpdatesInfo &&
          runtimeType == other.runtimeType &&
          downloadAvailability == other.downloadAvailability &&
          isMobileMapPackageReopenRequired ==
              other.isMobileMapPackageReopenRequired &&
          scheduledUpdatesDownloadSize == other.scheduledUpdatesDownloadSize &&
          uploadAvailability == other.uploadAvailability;

  @override
  int get hashCode =>
      downloadAvailability.hashCode ^
      isMobileMapPackageReopenRequired.hashCode ^
      scheduledUpdatesDownloadSize.hashCode ^
      uploadAvailability.hashCode;

  @override
  String toString() {
    return 'OfflineMapUpdatesInfo{downloadAvailability: $downloadAvailability, isMobileMapPackageReopenRequired: $isMobileMapPackageReopenRequired, scheduledUpdatesDownloadSize: $scheduledUpdatesDownloadSize, uploadAvailability: $uploadAvailability}';
  }
}

class OfflineMapSyncParameters {
  OfflineMapSyncParameters({
    this.keepGeodatabaseDeltas = false,
    this.preplannedScheduledUpdatesOption =
        PreplannedScheduledUpdatesOption.downloadAllUpdates,
    this.rollbackOnFailure = false,
    this.syncDirection = SyncDirection.birectional,
  });

  factory OfflineMapSyncParameters.fromJson(Map<dynamic, dynamic> json) {
    return OfflineMapSyncParameters(
      keepGeodatabaseDeltas: json['keepGeodatabaseDeltas'] as bool,
      preplannedScheduledUpdatesOption:
          PreplannedScheduledUpdatesOption.fromValue(
              json['preplannedScheduledUpdatesOption'] as int),
      rollbackOnFailure: json['rollbackOnFailure'] as bool,
      syncDirection: SyncDirection.fromValue(json['syncDirection'] as int),
    );
  }

  /// Indicates whether or not the upload or downloaded delta geodatabases
  /// should be removed at the end of the sync job.
  final bool keepGeodatabaseDeltas;

  /// Determines whether scheduled updates will be downloaded from an online
  /// map area and applied to the map's data.
  /// If the mobile geodatabases in your offline map were not registered
  /// for sync you can choose to download and apply those updates
  /// by setting this property to [PreplannedScheduledUpdatesOption.downloadAllUpdates].
  final PreplannedScheduledUpdatesOption preplannedScheduledUpdatesOption;

  /// Specifies whether all edits are rolled back (not applied)
  /// if a failure occurs while importing edits on the server.
  /// Otherwise, failed edits are skipped and other edits still applied.
  /// The default is false (no rollback on failure). @note It only applies
  /// to edits uploaded by the client to the server.
  /// Does not apply to edits imported by client.
  final bool rollbackOnFailure;

  /// The synchronization direction for geodatabases registered with feature services.
  final SyncDirection syncDirection;

  OfflineMapSyncParameters copyWith({
    bool? keepGeodatabaseDeltas,
    PreplannedScheduledUpdatesOption? preplannedScheduledUpdatesOption,
    bool? rollbackOnFailure,
    SyncDirection? syncDirection,
  }) {
    return OfflineMapSyncParameters(
      keepGeodatabaseDeltas:
          keepGeodatabaseDeltas ?? this.keepGeodatabaseDeltas,
      preplannedScheduledUpdatesOption: preplannedScheduledUpdatesOption ??
          this.preplannedScheduledUpdatesOption,
      rollbackOnFailure: rollbackOnFailure ?? this.rollbackOnFailure,
      syncDirection: syncDirection ?? this.syncDirection,
    );
  }

  Object toJson() {
    return {
      'keepGeodatabaseDeltas': keepGeodatabaseDeltas,
      'preplannedScheduledUpdatesOption':
          preplannedScheduledUpdatesOption.value,
      'rollbackOnFailure': rollbackOnFailure,
      'syncDirection': syncDirection.value,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineMapSyncParameters &&
          runtimeType == other.runtimeType &&
          keepGeodatabaseDeltas == other.keepGeodatabaseDeltas &&
          preplannedScheduledUpdatesOption ==
              other.preplannedScheduledUpdatesOption &&
          rollbackOnFailure == other.rollbackOnFailure &&
          syncDirection == other.syncDirection;

  @override
  int get hashCode =>
      keepGeodatabaseDeltas.hashCode ^
      preplannedScheduledUpdatesOption.hashCode ^
      rollbackOnFailure.hashCode ^
      syncDirection.hashCode;

  @override
  String toString() {
    return 'OfflineMapSyncParameters{keepGeodatabaseDeltas: $keepGeodatabaseDeltas, preplannedScheduledUpdatesOption: $preplannedScheduledUpdatesOption, rollbackOnFailure: $rollbackOnFailure, syncDirection: $syncDirection}';
  }
}

/// A task to sync an offline map.
/// Instances of this class represent a task that can be used to synchronize
/// changes between feature layers and tables of an offlinemap and
/// their originating ArcGIS feature services.
class OfflineMapSyncTask extends ArcgisNativeObject
    with Loadable, RemoteResource {
  Object? _error;

  OfflineMapSyncTask({
    required this.offlineMapPath,
  });

  /// The folder where mobile map package (.mmpk file),
  /// excluding the ".mmpk" extension, is located.
  final String offlineMapPath;

  @override
  String get type => "OfflineMapSyncTask";

  @protected
  @override
  dynamic getCreateArguments() => offlineMapPath;

  /// Describes the methods used for obtaining updates to the offline map
  /// that was used to create this task.
  /// You can use this property to determine whether an offline map
  /// is configured to use the preplanned scheduled updates workflow
  Future<OfflineMapUpdateCapabilities?> get updateCapabilities async {
    _checkIfHaveError();
    final capabilities =
        await invokeMethod('offlineMapSyncTask#getUpdateCapabilities');

    if (capabilities == null) {
      return null;
    }
    return OfflineMapUpdateCapabilities._fromJson(capabilities);
  }

  Future<OfflineMapUpdatesInfo?> checkForUpdates() async {
    _checkIfHaveError();
    final updatesInfo =
        await invokeMethod('offlineMapSyncTask#checkForUpdates');
    if (updatesInfo == null) {
      return null;
    }
    return OfflineMapUpdatesInfo._fromJson(updatesInfo);
  }

  Future<OfflineMapSyncParameters> defaultOfflineMapSyncParameters() async {
    _checkIfHaveError();
    final parameters = await invokeMethod(
        'offlineMapSyncTask#defaultOfflineMapSyncParameters');
    return OfflineMapSyncParameters.fromJson(parameters);
  }

  Future<OfflineMapSyncJob> offlineMapSyncJob({
    required OfflineMapSyncParameters parameters,
  }) async {
    _checkIfHaveError();
    final jobId = await invokeMethod(
      'offlineMapSyncTask#offlineMapSyncJob',
      arguments: parameters.toJson(),
    );
    return OfflineMapSyncJob._(
      objectId: jobId,
      parameters: parameters,
    );
  }

  @protected
  @mustCallSuper
  @override
  Future<void> handleMethodCall(String method, dynamic arguments) {
    switch (method) {
      case 'offlineMapSyncTask#loadError':
        _error = ArcgisError.fromJson(arguments);
        return Future.value();
      default:
        return super.handleMethodCall(method, arguments);
    }
  }

  void _checkIfHaveError() {
    if (_error != null) {
      throw _error!;
    }
  }
}
