import 'dart:async';

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
  final GenerateOfflineMapJobConfig _config;
  final MethodChannel _channel;

  GenerateOfflineMapJobImpl({
    required MethodChannel channel,
    required GenerateOfflineMapJobConfig config,
  })  : _id = config.jobId,
        _config = config,
        _channel = channel;

  @override
  String? get downloadDirectory => _config.downloadDirectory;

  @override
  ArcGISMap? get onlineMap => _config.onlineMap;

  @override
  GenerateOfflineMapParameters? get parameters => _config.parameters;

  @override
  Future<double> get progress async {
    final result = await _channel.invokeMethod<double>('getJobProgress', _id);
    return result ?? 0.0;
  }

  @override
  Stream<double> get onProgressChanged => _progressController.stream;

  @override
  GenerateOfflineMapResult? get result => _config.result;

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
}
