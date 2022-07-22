// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPagePolygon extends StatefulWidget {
  const MapPagePolygon({Key? key}) : super(key: key);

  @override
  State<MapPagePolygon> createState() => _MapPagePolygonState();
}

class _MapPagePolygonState extends State<MapPagePolygon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Polygon"),
      ),
      body: ArcgisMapView(
        map: ArcGISMap.imagery(),
        viewpoint: Viewpoint.fromPoint(
          point: AGSPoint.fromLatLng(
            latitude: 60.443889,
            longitude: 6.413889,
          ),
          scale: ZoomLevel.city,
        ),
        polygons: {
          Polygon(
            polygonId: const PolygonId("test"),
            points: [
              AGSPoint.fromLatLng(
                latitude: 60.443889,
                longitude: 6.413889,
              ),
              AGSPoint.fromLatLng(
                latitude: 60.443889,
                longitude: 6.415278,
              ),
              AGSPoint.fromLatLng(
                latitude: 60.433333,
                longitude: 6.418611,
              ),
              AGSPoint.fromLatLng(
                latitude: 60.432778,
                longitude: 6.416667,
              ),
            ],
            consumeTapEvents: true,
            fillColor: Colors.green,
            strokeColor: Colors.red,
            strokeWidth: 1,
            onTap: () {
              print('Polygon click!');
            },
          ),
        },
      ),
    );
  }
}
