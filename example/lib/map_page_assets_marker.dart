// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageAssetsMarker extends StatefulWidget {
  const MapPageAssetsMarker({super.key});

  @override
  State<MapPageAssetsMarker> createState() => _MapPageAssetsMarkerState();
}

class _MapPageAssetsMarkerState extends State<MapPageAssetsMarker> {
  double _offsetY = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assets Marker"),
      ),
      body: Stack(
        children: [
          ArcgisMapView(
            map: const ArcGISMap.fromBasemap(
              Basemap.fromStyle(
                basemapStyle: BasemapStyle.arcGISCommunity,
              ),
            ),
            onMapCreated: (controller) {
              controller.createOrUpdateGraphicsOverlay(
                  const GraphicsOverlay(id: 'default'));
              controller.addGraphicsToOverlay(
                'default',
                [
                  Graphic(
                    graphicId: 'test',
                    geometry: Point.fromLatLng(
                      latitude: 0.0,
                      longitude: 0.0,
                    ),
                    symbol: const CompositeSymbol(
                      symbols: [
                        PictureMarkerSymbol.fromResource(
                          resource: 'ic_marker',
                          width: 36,
                          height: 40,
                          tintColor: Colors.white,
                        ),
                        PictureMarkerSymbol.fromResource(
                          resource: 'ic_marker',
                          width: 36,
                          height: 40,
                          tintColor: Colors.red,
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            left: 16,
            top: 16,
            child: SizedBox(
              width: 150,
              child: Slider(
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
            ),
          )
        ],
      ),
    );
  }
}
