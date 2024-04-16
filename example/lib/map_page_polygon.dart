// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPagePolygon extends StatefulWidget {
  const MapPagePolygon({super.key});

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
        onMapCreated: (controller) {
          controller.createOrUpdateGraphicsOverlay(
            const GraphicsOverlay(id: 'default'),
          );

          controller.addGraphicsToOverlay('default', [
            Graphic(
              graphicId: 'test',
              geometry: Polygon(points: [
                [
                  Point.fromLatLng(latitude: 60.443889, longitude: 6.413889),
                  Point.fromLatLng(latitude: 60.443889, longitude: 6.413889),
                  Point.fromLatLng(latitude: 60.443889, longitude: 6.413889)
                ],
              ]),
              symbol: const SimpleFillSymbol(
                style: SimpleFillSymbolStyle.solid,
                color: Colors.green,
                outline: SimpleLineSymbol(
                  color: Colors.red,
                  width: 1,
                ),
              ),
            ),
          ]);
        },
        map: const ArcGISMap.fromBasemap(
          Basemap.fromStyle(
            basemapStyle: BasemapStyle.arcGISImageryStandard,
          ),
        ),
        viewpoint: Viewpoint.fromPoint(
          point: Point.fromLatLng(
            latitude: 60.443889,
            longitude: 6.413889,
          ),
          scale: ZoomLevel.city,
        ),
      ),
    );
  }
}
