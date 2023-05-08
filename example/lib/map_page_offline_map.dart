import 'dart:io';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MapPageOfflineMap extends StatefulWidget {
  const MapPageOfflineMap({Key? key}) : super(key: key);

  @override
  State<MapPageOfflineMap> createState() => _MapPageOfflineMapState();
}

class _MapPageOfflineMapState extends State<MapPageOfflineMap> {
  // final _map = ArcgisMapsUtils.createMap(
  //   ArcgisMapsUtils.defaultMap,
  //   Brightness.light,
  // );

  // final _map = ArcGISMap.fromPortalItem(
  //   PortalItem(
  //     portal: Portal(
  //       postalUrl: 'https://snla.maps.arcgis.com/',
  //       loginRequired: false,
  //       credential: snlaCredentials,
  //     ),
  //     itemId: '81a73308a0a449a4b8549a0c294fc544',
  //   ),
  // );

  final DisposeScope _disposeScope = DisposeScope();

  final _map = ArcGISMap.fromPortalItem(
    PortalItem(
      portal: Portal.arcGISOnline(connection: PortalConnection.anonymous),
      itemId: 'acc027394bc84c2fb04d1ed317aac674',
    ),
  );

  ArcGISMap? _offlineMap;

  bool _mapDownloadedAlready = false;

  late final ArcgisMapController _mapController;

  late final OfflineMapTask _offlineMapTask =
      OfflineMapTask.onlineMap(map: _map).disposeWith(_disposeScope);

  bool _isDownloading = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _loadOfflineMap();
  }

  @override
  void dispose() {
    _disposeScope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget floatingActionButton = _offlineMap != null
        ? FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      MapDownloadedOfflineMap(map: _offlineMap!),
                ),
              );
            },
            child: const Icon(Icons.download_for_offline),
          )
        : FloatingActionButton(
            onPressed: _isDownloading ? null : _downloadMap,
            child: _isDownloading
                ? CircularProgressIndicator(
                    value: _progress,
                    color: Colors.white,
                  )
                : const Icon(Icons.download),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('OfflineMap'),
      ),
      body: ArcgisMapView(
        map: _map,
        //baseLayers: _baseLayers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: _mapDownloadedAlready
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_mapDownloadedAlready) ...[
                  FloatingActionButton(
                    heroTag: 'sync',
                    onPressed: _syncDownloadedMap,
                    child: const Icon(Icons.sync),
                  ),
                  const SizedBox(height: 8),
                ],
                FloatingActionButton(
                  heroTag: 'delete',
                  onPressed: () async {
                    Directory appDocDir =
                        await getApplicationDocumentsDirectory();
                    String appDocPath = '${appDocDir.path}/offline_map_example';
                    try {
                      Directory directory = Directory(appDocPath);
                      await directory.delete(recursive: true);
                    } catch (_) {}
                    _mapDownloadedAlready = false;
                    _offlineMap = null;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: const Icon(Icons.delete_forever),
                ),
                const SizedBox(height: 8),
                floatingActionButton,
              ],
            )
          : floatingActionButton,
    );
  }

  Future<void> _loadOfflineMap() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = '${appDocDir.path}/offline_map_example';
    String packageInfo = '$appDocPath/package.info';
    final File downloadDir = File(appDocPath);
    _mapDownloadedAlready = await downloadDir.exists();

    final File package = File(packageInfo);
    if (await package.exists()) {
      _offlineMap = ArcGISMap.offlineMap(appDocPath);
    }

    _mapDownloadedAlready = true;

    if (mounted) {
      setState(() {});
    }
  }

  void _syncDownloadedMap() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final offlineMapPath = '${appDocDir.path}/offline_map_example';
      final offlineMapSync = OfflineMapSyncTask(offlineMapPath: offlineMapPath)
          .disposeWith(_disposeScope);

      final updateCapabilities = await offlineMapSync.updateCapabilities;
      if (kDebugMode) {
        print('updateCapabilities: $updateCapabilities');
      }

      final checkForUpdates = await offlineMapSync.checkForUpdates();

      if (kDebugMode) {
        print('checkForUpdates: $checkForUpdates');
      }

      final defaultParams =
          await offlineMapSync.defaultOfflineMapSyncParameters();

      if (kDebugMode) {
        print('defaultParams: $defaultParams');
      }

      final job =
          await offlineMapSync.offlineMapSyncJob(parameters: defaultParams);

      job.onStatusChanged.listen((event) {
        if (kDebugMode) {
          print('onStatusChanged: $event');
        }
      });

      job.onMessageAdded.listen((event) {
        if (kDebugMode) {
          print('onMessageAdded: $event');
        }
      });

      job.onProgressChanged.listen((event) {
        if (kDebugMode) {
          print('onProgressChanged: $event');
        }
      });

      final geodatabaseDeltaInfos = await job.geodatabaseDeltaInfos;
      if (kDebugMode) {
        print('geodatabaseDeltaInfos: $geodatabaseDeltaInfos');
      }

      job.disposeWith(_disposeScope);
      await job.start();

      final geodatabase = await job.result;
      if (kDebugMode) {
        print('geodatabase: $geodatabase');
      }
    } catch (ex, stackTrace) {
      if (kDebugMode) {
        print(ex);
        print(stackTrace);
      }
    }
  }

  void _downloadMap() async {
    try {
      final areaOfInterest = await _mapController
          .getCurrentViewpoint(ViewpointType.boundingGeometry);
      if (areaOfInterest == null) {
        return;
      }

      final defaultParams =
          await _offlineMapTask.defaultGenerateOfflineMapParameters(
        areaOfInterest: areaOfInterest.targetGeometry,
      );
      if (defaultParams == null) {
        return;
      }

      if (kDebugMode) {
        print(defaultParams);
      }

      final sw = Stopwatch();
      sw.start();

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = '${appDocDir.path}/offline_map_example';

      if (kDebugMode) {
        print('Downloading map to $appDocPath');
      }

      final job = await _offlineMapTask.generateOfflineMap(
        parameters: defaultParams,
        downloadDirectory: appDocPath,
      );
      job.disposeWith(_disposeScope);
      job.onStatusChanged.listen((event) async {
        if (kDebugMode) {
          print(event);
        }
        if (event == JobStatus.succeeded) {
          _loadOfflineMap();
          sw.stop();
          if (kDebugMode) {
            print('Downloaded map in ${sw.elapsed}');
          }
          setState(() {
            _isDownloading = false;
          });
        }
        if (event == JobStatus.failed) {
          if (kDebugMode) {
            final error = await job.error;
            print(error);
          }
        }
      });

      job.onProgressChanged.listen((event) {
        if (kDebugMode) {
          print('Progress: $event');
        }
        if (mounted) {
          setState(() {
            _progress = event;
          });
        }
      });

      _isDownloading = await job.start();
      if (!mounted) {
        return;
      }
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

class MapDownloadedOfflineMap extends StatelessWidget {
  const MapDownloadedOfflineMap({
    Key? key,
    required this.map,
  }) : super(key: key);

  final ArcGISMap map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloaded map'),
      ),
      body: ArcgisMapView(
        map: map,
      ),
    );
  }
}
