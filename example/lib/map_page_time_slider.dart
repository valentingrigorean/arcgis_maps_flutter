import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageTimeSlider extends StatefulWidget {
  const MapPageTimeSlider({Key? key}) : super(key: key);

  @override
  _MapPageTimeSliderState createState() => _MapPageTimeSliderState();
}

class _MapPageTimeSliderState extends State<MapPageTimeSlider> {
  TimeSliderController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Slider'),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: _buildMap()),
          if (_controller != null)
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: TimeSlider(
                controller: _controller!,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return ArcgisMapView(
      map: ArcGISMap.imageryWithLabelsVector(),
      operationalLayers: {
        WmsLayer.fromUrl(
          'https://public-wms.met.no/verportal/verportal.map?request=GetCapabilities&service=WMS&version=1.3.0',
          layersName: [
            'radar_precipitation_intensity_nordic',
          ],
        ),
        // WmsLayer.fromUrl(
        //   'https://view.eumetsat.int/geoserver/wms',
        //   layersName: ['msg_fes:rgb_naturalenhncd'],
        // ),

        // WmsLayer.fromUrl(
        //   'https://halo-wms.met.no/halo/default.map',
        //   layersName: [
        //     'freezing_level_altitude_feet',
        //   ],
        // ),
      },
      onMapCreated: (controller) async {
        _controller = TimeSliderController(
          minDate: DateTime.now().toUtc().subtract(const Duration(hours: 12)),
          maxDate: DateTime.now().toUtc().add(const Duration(hours: 12)),
        );
        _controller!.setMapController(
          controller,
          autoUpdateLayersInterval: const Duration(minutes: 3),
        );
        setState(() {});
      },
    );
  }
}
