import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MapPageofflineMap extends StatefulWidget {
  const MapPageofflineMap({Key? key}) : super(key: key);

  @override
  State<MapPageofflineMap> createState() => _MapPageofflineMapState();
}

class _MapPageofflineMapState extends State<MapPageofflineMap> {
  final _map = ArcGISMap.fromPortalItem(
    PortalItem(
      portal: Portal.arcGISOnline(withLoginRequired: false),
      itemId: 'acc027394bc84c2fb04d1ed317aac674',
    ),
  );

  late final OfflineMapTask _offlineMapTask =
      OfflineMapTask.onlineMap(map: _map);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OfflineMap'),
      ),
      body: ArcgisMapView(
        map: _map,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadMap,
        child: const Icon(Icons.download),
      ),
    );
  }

  void _downloadMap() async {
    try {
      final defaultParams =
          await _offlineMapTask.defaultGenerateOfflineMapParameters(
        areaOfInterest: AGSEnvelope(
          xMin: -88.1526,
          yMin: -88.1490,
          xMax: 41.7694,
          yMax: 41.7714,
          spatialReference: SpatialReference.wgs84(),
        ),
      );
      if (kDebugMode) {
        print(defaultParams);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
