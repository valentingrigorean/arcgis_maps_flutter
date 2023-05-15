import 'dart:math';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageMarkerFromWidget extends StatefulWidget {
  const MapPageMarkerFromWidget({Key? key}) : super(key: key);

  @override
  State<MapPageMarkerFromWidget> createState() =>
      _MapPageMarkerFromWidgetState();
}

class _MapPageMarkerFromWidgetState extends State<MapPageMarkerFromWidget> {
  final Set<Marker> _markers = <Marker>{};

  static final Random _random = Random();

  static final Map<int, Color> _colorMap = {
    0: Colors.red,
    1: Colors.blue,
    2: Colors.green,
    3: Colors.pinkAccent
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markers from widget'),
      ),
      body: ArcgisMapView(
        map: const ArcGISMap.fromBasemapStyle(BasemapStyle.arcGISImageryLabels),
        markers: _markers,
        onTap: (_,point) async {
          final bitmapDescriptor = await BitmapDescriptor.fromWidget(
            context: context,
            builder: (context) {
              return Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                color: _colorMap[_random.nextInt(4)],
                child: Text(_markers.length.toString()),
              );
            },
          );
          final marker = Marker(
            markerId: MarkerId(_markers.length.toString()),
            position: point!,
            icon: bitmapDescriptor,
          );
          setState(() {
            _markers.add(marker);
          });
        },
      ),
    );
  }
}
