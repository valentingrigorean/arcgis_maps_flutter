import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageASsetsMarker extends StatefulWidget {
  const MapPageASsetsMarker({Key? key}) : super(key: key);

  @override
  _MapPageASsetsMarkerState createState() => _MapPageASsetsMarkerState();
}

class _MapPageASsetsMarkerState extends State<MapPageASsetsMarker> {
  double _offsetY = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assets Marker"),
      ),
      body: Stack(
        children: [
          ArcgisMapView(
            map: ArcGISMap.imageryWithLabelsVector(),
            markers: {
              Marker(
                markerId: MarkerId('test'),
                position: Point.fromLatLng(
                  latitude: 0.0,
                  longitude: 0.0,
                ),
                iconOffsetY: _offsetY,
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
            child: Slider.adaptive(
              value: _offsetY,
              min: -5,
              max: 5,
              onChanged: (value) {
                print(_offsetY);
                setState(() {
                  _offsetY = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
