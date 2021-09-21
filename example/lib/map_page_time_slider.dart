import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:another_xlider/another_xlider.dart';

class MapPageTimeSlider extends StatefulWidget {
  const MapPageTimeSlider({Key? key}) : super(key: key);

  @override
  _MapPageTimeSliderState createState() => _MapPageTimeSliderState();
}

class _MapPageTimeSliderState extends State<MapPageTimeSlider> {
  final WmsService _wmsService = WmsService();
  ArcgisMapController? _controller;
  List<DateTime> _dates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Slider'),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: _buildMap()),
          if (_dates.length > 2)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: FlutterSlider(
                values: [_dates.first.millisecondsSinceEpoch.toDouble()],
                min: _dates.first.millisecondsSinceEpoch.toDouble(),
                max: _dates.last.millisecondsSinceEpoch.toDouble(),
                step: FlutterSliderStep(
                    step: const Duration(minutes: 5).inMilliseconds.toDouble()),
                tooltip: FlutterSliderTooltip(
                  custom: (value) {
                    DateTime dtValue =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());

                    return Text(dtValue.toString());
                  },
                ),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  DateTime dtValue =
                      DateTime.fromMillisecondsSinceEpoch(lowerValue.toInt());
                  print(dtValue.toIso8601String());
                  _controller?.setTimeExtent(
                    TimeExtent(
                      startTime: dtValue,
                      endTime: dtValue,
                    ),
                  );
                },
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
      },
      onMapCreated: (controller) async {
        final info = await controller.getTimeAwareLayerInfos();
        _controller = controller;
        if (info.isNotEmpty) {
          var controller = TimeSliderController();
          controller.fullExtent = info.first.fullTimeExtent;
          setState(() {
            _dates = controller.timeSteps;
          });
          print(info.first);
        }
      },
    );
  }
}
