// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageMarkerRotation extends StatefulWidget {
  const MapPageMarkerRotation({Key? key}) : super(key: key);

  @override
  State<MapPageMarkerRotation> createState() => _MapPageMarkerRotationState();
}

class _MapPageMarkerRotationState extends State<MapPageMarkerRotation> {
  double _angle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marker Rotation"),
      ),
      body: Stack(
        children: [
          ArcgisMapView(
            map:const ArcGISMap.fromBasemapStyle(BasemapStyle.arcGISImageryLabels),
            markers: {
              Marker(
                markerId: const MarkerId('test'),
                position: Point.fromLatLng(
                  latitude: 0.0,
                  longitude: 0.0,
                ),
                iconOffsetY: 4,
                angle: _angle,
                icon: BitmapDescriptor.fromNativeAsset(
                  'ic_flight_hazard',
                  width: 24,
                  height: 24,
                  tintColor: Colors.red,
                ),
                backgroundImage: BitmapDescriptor.fromNativeAsset(
                  'ic_marker',
                  width: 36,
                  height: 40,
                  tintColor: Colors.white,
                ),
              ),
            },
          ),
          Positioned(
            left: 16,
            top: 16,
            child: SizedBox(
              width: 150,
              child: Slider(
                value: _angle / 360.0,
                onChanged: (value) {
                  print(_angle);
                  setState(() {
                    _angle = value * 360.0;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
