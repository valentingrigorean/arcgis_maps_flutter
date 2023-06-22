import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MapPageMaxExtent extends StatefulWidget {
  const MapPageMaxExtent({Key? key}) : super(key: key);

  @override
  State<MapPageMaxExtent> createState() => _MapPageMaxExtentState();
}

class _MapPageMaxExtentState extends State<MapPageMaxExtent> {
  ArcgisMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Max Extent'),
      ),
      body: ArcgisMapView(
        map: ArcGISMap.fromPortalItem(
          PortalItem(
            portal: Portal.arcGISOnline(
              connection: PortalConnection.anonymous,
            ),
            itemId: 'acc027394bc84c2fb04d1ed317aac674',
          ),
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = _mapController;
          if (controller == null) {
            return;
          }
          final extent = await controller.getMapMaxExtend();
          if (kDebugMode) {
            print('Max extent: $extent');
          }
        },
        child: const Icon(Icons.info),
      ),
    );
  }
}
