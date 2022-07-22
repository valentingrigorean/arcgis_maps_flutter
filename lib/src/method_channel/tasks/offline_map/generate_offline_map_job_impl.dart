import 'dart:async';
import 'dart:ui';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/services.dart';

class GenerateOfflineMapJobConfig {
  final int jobId;
  final String? downloadDirectory;
  final ArcGISMap? onlineMap;
  final GenerateOfflineMapParameters? parameters;
  final GenerateOfflineMapResult? result;

  GenerateOfflineMapJobConfig({
    required this.jobId,
    required this.downloadDirectory,
    required this.onlineMap,
    required this.parameters,
    required this.result,
  });
}

class GenerateOfflineMapJobImpl extends GenerateOfflineMapJob {
  final int _id;
  final StreamController<double> _progressController =
      StreamController<double>.broadcast();
  final StreamController<JobStatus> _statusController =
      StreamController<JobStatus>.broadcast();
  final GenerateOfflineMapJobConfig _config;
  final MethodChannel _channel;

  final VoidCallback? _onDispose;

  bool _isDisposed = false;

  GenerateOfflineMapJobImpl({
    required GenerateOfflineMapJobConfig config,
    VoidCallback? onDispose,
  })  : _id = config.jobId,
        _config = config,
        _onDispose = onDispose,
        _channel = MethodChannel(
            'plugins.flutter.io/arcgis_channel/offline_map_task/job_${config.jobId}') {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    _onDispose?.call();
    _channel.setMethodCallHandler(null);
    _progressController.close();
  }

  @override
  String? get downloadDirectory => _config.downloadDirectory;

  @override
  ArcGISMap? get onlineMap => _config.onlineMap;

  @override
  GenerateOfflineMapParameters? get parameters => _config.parameters;

  @override
  Future<ArcgisError?> get error async{
    final result = await _channel.invokeMethod('getError');
    if (result == null) {
      return null;
    }
    return ArcgisError.fromJson(result);
  }

  @override
  Future<double> get progress async {
    final result = await _channel.invokeMethod<double>('getJobProgress', _id);
    return result ?? 0.0;
  }

  @override
  Stream<double> get onProgressChanged => _progressController.stream;

  @override
  Future<JobStatus> get status async {
    final result = await _channel.invokeMethod<int>('getJobStatus', _id);
    return JobStatus.fromValue(result ?? JobStatus.notStarted.value);
  }

  @override
  Stream<JobStatus> get onStatusChanged => _statusController.stream;

  // @override
  // GenerateOfflineMapResult? get result => _config.result;

  @override
  Future<bool> start() async {
    final result = await _channel.invokeMethod<bool>('startJob', _id);
    return result ?? false;
  }

  @override
  Future<bool> cancel() async {
    final result = await _channel.invokeMethod<bool>('cancelJob', _id);
    return result ?? false;
  }

  @override
  Future<bool> pause() async {
    final result = await _channel.invokeMethod<bool>('pauseJob', _id);
    return result ?? false;
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onProgressChanged':
        final double progress = call.arguments;
        _progressController.add(progress);
        break;
      case 'onStatusChanged':
        final int status = call.arguments;
        _statusController.add(JobStatus.fromValue(status));
        break;
      default:
        throw UnsupportedError('Unrecognized method ${call.method}');
    }
  }
}
