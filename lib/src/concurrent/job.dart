part of arcgis_maps_flutter;

enum JobStatus {
  notStarted(0),
  started(1),
  paused(2),
  succeeded(3),
  failed(4);

  const JobStatus(this.value);

  factory JobStatus.fromValue(int value) {
    return JobStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JobStatus.notStarted,
    );
  }

  final int value;
}

enum JobType {
  generateGeodatabase(0),
  syncGeodatabase(1),
  exportTileCache(2),
  estimateTileCacheSize(3),
  geoprocessingJob(4),
  generateOfflineMap(5),
  offlineMapSync(6),
  downloadPreplannedOfflineMapJob(7);

  const JobType(this.value);

  factory JobType.fromValue(int value) {
    return JobType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JobType.generateGeodatabase,
    );
  }

  final int value;
}

abstract class Job extends ArcgisNativeObject with RemoteResource {
  final StreamController<double> _progressController =
      StreamController<double>.broadcast();
  final StreamController<JobStatus> _statusController =
      StreamController<JobStatus>.broadcast();

  Job({
    String? objectId,
    bool isCreated = false,
  }) : super(
          objectId: objectId,
          isCreated: isCreated,
        );

  @override
  void dispose() {
    _progressController.close();
    _statusController.close();
    super.dispose();
  }

  Future<ArcgisError?> get error async {
    final result = await invokeMethod('job#getError');
    if (result == null) {
      return null;
    }
    return ArcgisError.fromJson(result);
  }

  Future<JobType> get jobType async {
    final result = await invokeMethod('job#getJobType');
    return JobType.fromValue(result);
  }

  Future<String> get serverJobId async {
    return await invokeMethod('job#serverJobId');
  }

  Future<JobStatus> get status async {
    final result = await invokeMethod('job#getStatus');
    return JobStatus.fromValue(result);
  }

  Future<double> get progress async {
    return await invokeMethod('job#getProgress');
  }

  Stream<double> get onProgressChanged => _progressController.stream;

  Stream<JobStatus> get onStatusChanged => _statusController.stream;

  Future<bool> start() async {
    final result = await invokeMethod('job#start');
    return result ?? false;
  }

  Future<bool> cancel() async {
    final result = await invokeMethod('job#cancel');
    return result ?? false;
  }

  Future<bool> pause() async {
    final result = await invokeMethod('job#pause');
    return result ?? false;
  }

  @override
  @protected
  Future<void> handleMethodCall(String method, dynamic arguments) async {
    switch (method) {
      case 'job#onProgressChanged':
        final double progress = arguments;
        _progressController.add(progress);
        break;
      case 'job#onStatusChanged':
        final int status = arguments;
        _statusController.add(JobStatus.fromValue(status));
        break;
      default:
        await super.handleMethodCall(method, arguments);
        break;
    }
  }
}
