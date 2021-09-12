import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageTimeSlider extends StatefulWidget {
  const MapPageTimeSlider({Key? key}) : super(key: key);

  @override
  _MapPageTimeSliderState createState() => _MapPageTimeSliderState();
}

class _MapPageTimeSliderState extends State<MapPageTimeSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Slider'),
      ),
      body: ArcgisMapView(
        map: ArcGISMap.imageryWithLabelsVector(),
        operationalLayers: {
          WmsLayer.fromUrl(
            'https://public-wms.met.no/verportal/verportal.map?request=GetCapabilities&service=WMS&version=1.3.0',
            layersName: [
              'radar_precipitation_intensity_nordic',
            ],
          ),
        },
        onMapCreated: (controller) async {
          final info = await controller.getTimeAwareLayerInfos();
          if (info.isNotEmpty) {
            print(info.first);
          }
        },
      ),
    );
  }
}
