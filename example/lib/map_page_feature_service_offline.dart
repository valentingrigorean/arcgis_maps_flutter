import 'dart:io';
import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
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

  late final DisposeScope _disposeScope = DisposeScope()..add(_task);

  GenerateGeodatabaseJob? _job;

  late ArcgisMapController _mapController;
  GeodatabaseLayer? _downloadedFeatureLayer;

  bool _isDownloading = false;

  bool _isDownloaded = false;

  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _downloadTileCache();
  }

  @override
  void dispose() {
    _disposeScope.dispose();
    _mapController.dispose();
    _job?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future service Cache'),
      ),
      body: ArcgisMapView(
        map: const ArcGISMap.fromBasemap(
          Basemap.fromStyle(
            basemapStyle: BasemapStyle.arcGISCommunity,
          ),
        ),
        viewpoint: Viewpoint.fromPoint(
          point: Point.fromLatLng(
            latitude: 41.774317,
            longitude: -88.149655,
          ),
          scale: 18055.954822,
        ),
        operationalLayers: _downloadedFeatureLayer != null
            ? {_downloadedFeatureLayer!}
            : const {},
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isDownloaded)
            FloatingActionButton(
              onPressed: _syncLayer,
              heroTag: 'sync',
              child: const Icon(Icons.sync),
            ),
          if (_isDownloading)
            FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(
                value: _progress,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  void _downloadTileCache() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = '${appDocDir.path}/gdb.geodatabase';

    if (kDebugMode) {
      print('appDocPath: $appDocPath');
    }

    if (await File(appDocPath).exists()) {
      _downloadedFeatureLayer = GeodatabaseLayer(
        layerId: LayerId(appDocPath),
        path: appDocPath,
      );

      _isDownloaded = true;
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {});
      }
      return;
    }

    setState(() {
      _isDownloading = true;
      _progress = 0;
    });

    final params = await _task.defaultGenerateGeodatabaseParameters(
      areaOfInterest: Polygon(
        points: [
          [
            Point.fromLatLng(
              latitude: 41.778064,
              longitude: -88.153245,
            ),
            Point.fromLatLng(
              latitude: 41.778870,
              longitude: -88.146708,
            ),
            Point.fromLatLng(
              latitude: 41.769764,
              longitude: -88.145878,
            ),
            Point.fromLatLng(
              latitude: 41.770330,
              longitude: -88.153431,
            ),
          ],
        ],
        spatialReference: SpatialReference.wgs84(),
      ),
    );
    final job = await _task.generateJob(
      parameters: params.copyWith(
        returnAttachments: false,
      ),
      fileNameWithPath: appDocPath,
    );
    _disposeScope.add(job);

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
            _isDownloaded = true;
            _downloadedFeatureLayer = GeodatabaseLayer(
              layerId: LayerId(appDocPath),
              path: appDocPath.replaceAll(
                '.geodatabase',
                '',
              ),
            );
            _isDownloading = false;
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

  void _syncLayer() async {
    final path = _downloadedFeatureLayer!.path;
    final geodatabase = Geodatabase(path: path);

    try {
      await geodatabase.loadAsync();

      final params = await _task.defaultSyncGeodatabaseParameters(
          geodatabase: geodatabase);
      if (kDebugMode) {
        print('params: $params');
      }

      final job = await _task.syncJob(
        geodatabase: geodatabase,
        parameters: params,
      );

      _disposeScope.add(job);

      final job2 = await _task.syncJob(
        geodatabase: geodatabase,
        parameters: params,
      );

      _disposeScope.add(job2);

      final deltas = await job.geodatabaseDeltaInfo;
      if (kDebugMode) {
        print('deltas: $deltas');
      }

      job.onMessageAdded.listen((event) {
        if (kDebugMode) {
          print('message: $event');
        }
      });

      job.onProgressChanged.listen((progress) {
        if (kDebugMode) {
          print('progress: $progress');
        }
      });

      job.onStatusChanged.listen((event) async {
        if (kDebugMode) {
          print('status: $event');
        }
        if(event == JobStatus.failed){
          final error = await job.error;
          if (kDebugMode) {
            print('error: $error');
          }
          await geodatabase.close();
        }
        if (event == JobStatus.succeeded) {
          final result = await job.result;
          if (kDebugMode) {
            print('result: $result');
          }
          await geodatabase.close();
        }
      });

      await job.start();
    } catch (ex, stackTrace) {
      if (kDebugMode) {
        print('ex: $ex');
        print('stackTrace: $stackTrace');
      }
    }
  }
}
