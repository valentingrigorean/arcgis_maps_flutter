import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageTimeSlider extends StatefulWidget {
  const MapPageTimeSlider({Key? key}) : super(key: key);

  @override
  State<MapPageTimeSlider>  createState() => _MapPageTimeSliderState();
}

class _MapPageTimeSliderState extends State<MapPageTimeSlider> {
  final Set<WmsLayer> radarLayers = {
    WmsLayer.fromUrl(
      'https://public-wms.met.no/verportal/verportal.map',
      layersName: [
        'radar_precipitation_intensity_nordic',
      ],
    ),
    WmsLayer.fromUrl(
      'https://public-wms.met.no/verportal/verportal.map',
      layerId: const LayerId(
        'radar_precipitation_intensity',
      ),
      layersName: const [
        'radar_precipitation_intensity',
      ],
    ),
    // WmsLayer.fromUrl(
    //   'https://wts2.smhi.se/tile/baltrad',
    //   layerId: const LayerId(
    //     'baltrad:radarcomp-lightning_scandinavia_wpt',
    //   ),
    //   layersName: const [
    //     'baltrad:radarcomp-lightning_scandinavia_wpt',
    //   ],
    // ),
    // WmsLayer.fromUrl(
    //   'https://wts2.smhi.se/tile/baltrad',
    //   layerId: const LayerId(
    //     'baltrad:radarcomp-lightning_sweden_wpt',
    //   ),
    //   layersName: const ['baltrad:radarcomp-lightning_sweden_wpt'],
    // ),
  };

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
      operationalLayers: radarLayers,
      onMapCreated: (controller) async {
        _controller = TimeSliderController(
          mapController: controller,
          dataProvider: TimeSliderWmsServiceDataProvider(
            mapController: controller,
            layers: radarLayers,
          ),
          minDate: DateTime.now().toUtc().subtract(const Duration(hours: 12)),
          maxDate: DateTime.now().toUtc().add(const Duration(hours: 12)),
          timeStepInterval:
              const TimeValue(duration: 1, unit: TimeUnit.minutes),
        );

        setState(() {});
      },
    );
  }
}
