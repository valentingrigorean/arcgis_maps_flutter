import 'dart:io';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

class MapPageofflineMap extends StatefulWidget {
  const MapPageofflineMap({Key? key}) : super(key: key);

  @override
  State<MapPageofflineMap> createState() => _MapPageofflineMapState();
}

class _MapPageofflineMapState extends State<MapPageofflineMap> {
  // final _map = ArcgisMapsUtils.createMap(
  //   ArcgisMapsUtils.defaultMap,
  //   Brightness.light,
  // );

  final _map = ArcGISMap.fromPortalItem(
    PortalItem(
      portal: Portal(
        postalUrl: 'https://snla.maps.arcgis.com/',
        loginRequired: false,
        credential: Credential.creteUserCredential(
          username: dotenv.env['snla_maps_arcgis_username'] ?? '',
          password: dotenv.env['snla_maps_arcgis_password'] ?? '',
        ),
      ),
      itemId: '81a73308a0a449a4b8549a0c294fc544',
    ),
  );

  // final _map = ArcGISMap.fromPortalItem(
  //   PortalItem(
  //     portal: Portal.arcGISOnline(
  //       withLoginRequired: false,
  //     ),
  //     itemId: 'acc027394bc84c2fb04d1ed317aac674',
  //   ),
  // );

  ArcGISMap? _offlineMap;

  bool _mapDownloadedAlready = false;

  late final ArcgisMapController _mapController;

  late final OfflineMapTask _offlineMapTask =
      OfflineMapTask.onlineMap(map: _map);

  bool _isDownloading = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _loadOfflineMap();
  }

  @override
  void dispose() {
    _offlineMapTask.dispose();
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
                FloatingActionButton(
                  onPressed: () async {
                    Directory appDocDir =
                        await getApplicationDocumentsDirectory();
                    String appDocPath = '${appDocDir.path}/offline_map_example';
                    File file = File(appDocPath);
                    await file.delete(recursive: true);
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