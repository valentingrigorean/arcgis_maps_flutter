import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MapPageMaxExtent extends StatelessWidget {
  const MapPageMaxExtent({Key? key}) : super(key: key);

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
              withLoginRequired: false,
            ),
            itemId: 'acc027394bc84c2fb04d1ed317aac674',
          ),
        ),
        onMapCreated: (controller) async {
          final extent = await controller.getMapMaxExtend();
          if (kDebugMode) {
            print('Max extent: $extent');
          }
        },
      ),
    );
  }
}
