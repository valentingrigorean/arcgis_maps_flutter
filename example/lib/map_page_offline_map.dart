import 'dart:io';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/utils/arcgis_maps_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      portal: Portal.arcGISOnline(withLoginRequired: false),
      itemId: 'acc027394bc84c2fb04d1ed317aac674',
    ),
  );

  final Set<Layer> _baseLayers = {
    ...ArcgisMapsUtils.getAvalancheLayers(),
  };

  late final ArcgisMapController _mapController;

  late final OfflineMapTask _offlineMapTask =
      OfflineMapTask.onlineMap(map: _map);

  bool _isDownloading = false;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OfflineMap'),
      ),
      body: ArcgisMapView(
        map: _map,
        baseLayers: _baseLayers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isDownloading ? null : _downloadMap,
        child: _isDownloading
            ? CircularProgressIndicator(
                value: _progress,
                color: Colors.white,
              )
            : const Icon(Icons.download),
      ),
    );
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
      String appDocPath = appDocDir.path + '/offline_map_example';

      if (kDebugMode) {
        print('Downloading map to $appDocPath');
      }

      final job = await _offlineMapTask.generateOfflineMap(
        parameters: defaultParams,
        downloadDirectory: appDocPath,
      );
      job.onStatusChanged.listen((event) {
        if (kDebugMode) {
          print(event);
        }
        if (event == JobStatus.succeeded) {
          sw.stop();
          if(kDebugMode){
            print('Downloaded map in ${sw.elapsedMilliseconds}ms');
          }
          setState(() {
            _isDownloading = false;
          });
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
