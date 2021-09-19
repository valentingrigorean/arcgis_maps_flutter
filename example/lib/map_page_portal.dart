import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPagePortal extends StatelessWidget {
  const MapPagePortal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portal'),
      ),
      body: ArcgisMapView(
        map: ArcGISMap.openStreetMap(),
        operationalLayers: {
          FeatureLayer.fromPortalItem(
            layerId: LayerId('LayerId'),
            portalItem: PortalItem(
              portal: Portal.arcGISOnline(withLoginRequired: false),
              itemId: 'af1ad38816814b7eba3fe74a3b84412d',
            ),
            portalItemLayerId: 0,
          )
        },
      ),
    );
  }
}
