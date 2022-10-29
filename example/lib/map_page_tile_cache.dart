// ignore_for_file: unused_field

import 'dart:io';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/utils/credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MapPageTileCache extends StatefulWidget {
  const MapPageTileCache({Key? key}) : super(key: key);

  @override
  State<MapPageTileCache> createState() => _MapPageTileCacheState();
}

class _MapPageTileCacheState extends State<MapPageTileCache> {
  final ExportTileCacheTask _tileCacheTask = ExportTileCacheTask(
    url:
        'https://services.geodataonline.no/arcgis/rest/services/Geocache_UTM33_EUREF89/GeocacheHelning/MapServer',
  );

  ExportTileCacheJob? _exportTileCacheJob;

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
    _exportTileCacheJob?.cancel();
    _exportTileCacheJob?.dispose();
    _tileCacheTask.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tile Cache'),
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
    String appDocPath = '${appDocDir.path}/offline_tile_cache.tpk';

    if (kDebugMode) {
      print('appDocPath: $appDocPath');
    }

    await _tileCacheTask.setCredential(geodataCredentials);

    final viewPoint = await _mapController
        .getCurrentViewpoint(ViewpointType.boundingGeometry);
    if (viewPoint == null) {
      return;
    }

    if (kDebugMode) {
      print('viewPoint: ${viewPoint.targetGeometry.toJson()}');
    }

    final params = await _tileCacheTask.createDefaultExportTileCacheParameters(
      areaOfInterest: viewPoint.targetGeometry,
      minScale: 0,
      maxScale: 0,
    );
    final job = await _tileCacheTask.exportTileCacheJob(
      parameters: params,
      fileNameWithPath: appDocPath,
    );

    job.onMessageAdded.listen((event) {
      if (kDebugMode) {
        print('message: $event');
      }
    });

    _exportTileCacheJob = job;
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
