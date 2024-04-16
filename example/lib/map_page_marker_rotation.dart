// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageMarkerRotation extends StatefulWidget {
  const MapPageMarkerRotation({super.key});

  @override
  State<MapPageMarkerRotation> createState() => _MapPageMarkerRotationState();
}

class _MapPageMarkerRotationState extends State<MapPageMarkerRotation> {
  late final ArcgisMapController _mapController;
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
            onMapCreated: (controller) {
              _mapController = controller;
              controller.createOrUpdateGraphicsOverlay(
                  const GraphicsOverlay(id: 'default'));
              controller.addGraphicsToOverlay('default', [
                Graphic(
                  graphicId: 'test',
                  geometry: Point.fromLatLng(
                    latitude: 0.0,
                    longitude: 0.0,
                  ),
                  symbol: const CompositeSymbol(
                    symbols: [
                      PictureMarkerSymbol.fromResource(
                        resource: 'ic_flight_hazard',
                        width: 24,
                        height: 24,
                        tintColor: Colors.red,
                      ),
                      PictureMarkerSymbol.fromResource(
                        resource: 'ic_marker',
                        width: 36,
                        height: 40,
                        tintColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ]);
            },
            map: const ArcGISMap.fromBasemap(
              Basemap.fromStyle(
                basemapStyle: BasemapStyle.arcGISCommunity,
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: SizedBox(
              width: 150,
              child: Slider(
                value: _angle / 360.0,
                onChanged: (value) {
                  _angle = value * 360.0;

                  _mapController.updateGraphicSymbol(
                    overlayId: 'default',
                    graphicId: 'test',
                    symbol: CompositeSymbol(
                      symbols: [
                        PictureMarkerSymbol.fromResource(
                          resource: 'ic_flight_hazard',
                          width: 24,
                          height: 24,
                          tintColor: Colors.red,
                          angle: _angle,
                        ),
                        PictureMarkerSymbol.fromResource(
                          resource: 'ic_marker',
                          width: 36,
                          height: 40,
                          tintColor: Colors.white,
                          angle: _angle,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
