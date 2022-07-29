import 'dart:io';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/utils/credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MapPageFeatureServiceOffline extends StatefulWidget {
  const MapPageFeatureServiceOffline({Key? key}) : super(key: key);

  @override
  State<MapPageFeatureServiceOffline> createState() =>
      _MapPageFeatureServiceOfflineState();
}

class _MapPageFeatureServiceOfflineState
    extends State<MapPageFeatureServiceOffline> {
  final GeodatabaseSyncTask _task = GeodatabaseSyncTask(
    url:
        'https://services2.arcgis.com/ZQgQTuoyBrtmoGdP/arcgis/rest/services/WaterDistributionNetwork/FeatureServer',
  );

  GenerateGeodatabaseJob? _job;

  late ArcgisMapController _mapController;

  bool _isDownloading = false;
  bool _isDownloaded = false;

  double _progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _job?.cancel();
    _job?.dispose();
    _task.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future service Cache'),
      ),
      body: ArcgisMapView(
        map: ArcGISMap.imagery(),
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isDownloading ? null : _downloadTileCache,
        child: _isDownloading
            ? CircularProgressIndicator(
                value: _progress,
                color: Colors.white,
              )
            : const Icon(
                Icons.file_download,
              ),
      ),
    );
  }

  void _downloadTileCache() async {
    setState(() {
      _isDownloading = true;
      _progress = 0;
    });

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = '${appDocDir.path}/offline_future_service.geodatabase';

    if (kDebugMode) {
      print('appDocPath: $appDocPath');
    }
    final viewPoint = await _mapController
        .getCurrentViewpoint(ViewpointType.boundingGeometry);
    if (viewPoint == null) {
      return;
    }

    if (kDebugMode) {
      print('viewPoint: ${viewPoint.targetGeometry.toJson()}');
    }

    final params = await _task.defaultGenerateGeodatabaseParameters(
      areaOfInterest: viewPoint.targetGeometry,
    );
    final job = await _task.generateJob(
      parameters: params,
      fileNameWithPath: appDocPath,
    );

    job.onMessageAdded.listen((event) {
      if (kDebugMode) {
        print('message: $event');
      }
    });

    _job = job;
    job.onStatusChanged.listen((status) async {
      if (kDebugMode) {
        print('status: $status');
      }

      if (status == JobStatus.succeeded) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _isDownloaded = true;
          });
        }
      }
      if (status == JobStatus.failed) {
        final error = await job.error;
        if (kDebugMode) {
          print('error: $error');
        }
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _isDownloaded = false;
          });
        }
      }
    });

    job.onProgressChanged.listen((progress) {
      if (kDebugMode) {
        print('progress: $progress');
      }
      if (mounted) {
        setState(() {
          _progress = progress;
        });
      }
    });

    final didStart = await job.start();
    if (kDebugMode) {
      print('didStart: $didStart');
    }
  }
}
