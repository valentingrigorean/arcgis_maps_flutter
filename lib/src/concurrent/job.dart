part of arcgis_maps_flutter;

enum JobStatus {
  /// A job that has not started.
  notStarted(0),

  /// A job that has started and is executing.
  started(1),

  /// A job that is paused. Use [Job.start] to re-start the job.
  paused(2),

  /// A job that has completed successfully.
  succeeded(3),

  /// A job that has completed and has failed.
  failed(4),
  canceling(5),
  ;

  const JobStatus(this.value);

  factory JobStatus.fromValue(int value) {
    return JobStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JobStatus.notStarted,
    );
  }

  final int value;
}

enum JobMessageSeverity {
  /// A message of unknown severity.
  unknown(-1),

  /// An informative message is generated during the job's execution,
  /// such as a job uploading data, job progressing on a server, or job results.
  /// This message type never indicates a problem.
  info(0),

  /// A warning message is generated when a job experiences a situation that
  /// may cause a problem during its execution or when the result may not be
  /// what you expect. For example, when the job has failed to take a layer
  /// offline from an online map. Generally the job will run to successful
  /// completion even if there are one or more warnings.
  warning(1),

  /// An error message indicates a critical event that caused the job to fail.
  /// The error instance is also available from the job's [Job.error] property.
  error(2);

  const JobMessageSeverity(this.value);

  factory JobMessageSeverity.fromValue(int value) {
    return JobMessageSeverity.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JobMessageSeverity.unknown,
    );
  }

  final int value;
}

enum JobMessageSource {
  /// A job message generated by the ArcGISRuntime client.
  client(0),

  /// A job message generated by a service.
  server(1);

  const JobMessageSource(this.value);

  factory JobMessageSource.fromValue(int value) {
    return JobMessageSource.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JobMessageSource.client,
    );
  }

  final int value;
}

class JobMessage {
  const JobMessage({
    required this.message,
    required this.severity,
    required this.source,
    required this.timestamp,
  });

  factory JobMessage.fromJson(Map<dynamic, dynamic> json) {
    return JobMessage(
      message: json['message'] as String,
      severity: JobMessageSeverity.fromValue(json['severity'] as int),
      source: JobMessageSource.fromValue(json['source'] as int),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// The message contents
  final String message;

  /// The job message's severity: information, warning or error.
  final JobMessageSeverity severity;

  /// The source of the job message, either from the service or
  /// from the ArcGISRuntime client.
  final JobMessageSource source;

  /// The date and time that the job message was created.
  /// This will be the current system
  final DateTime timestamp;

  @override
  String toString() {
    return 'JobMessage{message: $message, severity: $severity, source: $source, timestamp: $timestamp}';
  }
}

abstract class Job extends ArcgisNativeObject {
  final StreamController<double> _progressController =
      StreamController<double>.broadcast();
  final StreamController<JobStatus> _statusController =
      StreamController<JobStatus>.broadcast();
  final StreamController<JobMessage> _messageController =
      StreamController<JobMessage>.broadcast();

  bool _isStarted = false;

  Job({
    String? objectId,
    bool isCreated = false,
  }) : super(
          objectId: objectId,
          isCreated: isCreated,
        );

  @override
  void dispose() async {
    _progressController.close();
    _statusController.close();
    _messageController.close();
    if (_isStarted) {
      cancel();
    }
    super.dispose();
  }

  /// Error encountered during job execution, if any.
  Future<ArcgisError?> get error async {
    final result = await invokeMethod(
      'job#getError',
    );
    if (result == null) {
      return null;
    }
    return ArcgisError.fromJson(result);
  }

  /// Informational messages produced during execution of the job.
  Future<List<JobMessage>> get messages async {
    final result = await invokeMethod('job#getMessages');
    return (result as List<dynamic>)
        .map((e) => JobMessage.fromJson(e))
        .toList();
  }

  /// Unique ID of the job on the server on which it is executing.
  Future<String> get serverJobId async {
    return await invokeMethod('job#serverJobId');
  }

  /// Current status of the job.
  Future<JobStatus> get status async {
    final result = await invokeMethod('job#getStatus');
    return JobStatus.fromValue(result);
  }

  Future<double> get progress async {
    return await invokeMethod('job#getProgress');
  }

  Stream<double> get onProgressChanged => _progressController.stream;

  Stream<JobStatus> get onStatusChanged => _statusController.stream;

  Stream<JobMessage> get onMessageAdded => _messageController.stream;

  Future<bool> start() async {
    final result = await invokeMethod('job#start');
    _isStarted = result ?? false;
    return _isStarted;
  }

  Future<bool> cancel() async {
    final result = await invokeMethod('job#cancel');
    _isStarted = result ?? false;
    return result ?? false;
  }

  Future<bool> pause() async {
    final result = await invokeMethod('job#pause');
    _isStarted = result ?? false;
    return result ?? false;
  }

  @override
  @protected
  Future<void> handleMethodCall(String method, dynamic arguments) async {
    if (isDisposed) {
      return;
    }
    switch (method) {
      case 'job#onProgressChanged':
        final double progress = arguments;
        _progressController.add(progress);
        break;
      case 'job#onStatusChanged':
        final int status = arguments;
        _statusController.add(JobStatus.fromValue(status));
        break;
      case 'job#onMessageAdded':
        _messageController.add(JobMessage.fromJson(arguments));
        break;
      default:
        await super.handleMethodCall(method, arguments);
        break;
    }
  }
}
