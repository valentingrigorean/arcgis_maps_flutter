import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapPageBuffer extends StatefulWidget {
  const MapPageBuffer({super.key});

  @override
  State<MapPageBuffer> createState() => _MapPageBufferState();
}

class _MapPageBufferState extends State<MapPageBuffer> {
  late final ArcgisMapController _mapController;
  int _currentBufferType = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buffer'),
      ),
      body: Stack(
        children: [
          ArcgisMapView(
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController.createOrUpdateGraphicsOverlay(
                  const GraphicsOverlay(id: 'default'));
            },
            map: const ArcGISMap.fromBasemap(
              Basemap.fromStyle(
                basemapStyle: BasemapStyle.arcGISCommunity,
              ),
            ),
            onTap: (screenPoint) async {
              final position = await _mapController.screenToLocation(screenPoint);
              Polygon? polygon;
              if (position == null) return;
              if (_currentBufferType == 0) {
                polygon = await GeometryEngine.bufferGeometry(
                    geometry: position, distance: 1000);
              } else {
                polygon = await GeometryEngine.geodeticBufferGeometry(
                  geometry: position,
                  distance: 1000,
                  distanceUnit: LinearUnitId.meters,
                  maxDeviation: double.nan,
                  curveType: GeodeticCurveType.shapePreserving,
                );
              }
              _mapController.clearGraphicsOverlay('default');

              if (polygon == null) {
                return;
              }
              _mapController.addGraphicsToOverlay(
                'default',
                [
                  Graphic(
                    graphicId: 'buffer',
                    geometry: polygon,
                    symbol: const SimpleLineSymbol(
                      style: SimpleLineSymbolStyle.dash,
                      color: Colors.red,
                      width: 2,
                      markerStyle: SimpleLineSymbolMarkerStyle.none,
                      markerPlacement:
                          SimpleLineSymbolMarkerPlacement.beginAndEnd,
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            child: CupertinoSegmentedControl(
              onValueChanged: (int newValue) {
                setState(() {
                  _currentBufferType = newValue;
                });
              },
              groupValue: _currentBufferType,
              children: const {
                0: Text('Buffer'),
                1: Text('GeodeticBuffer'),
              },
            ),
          )
        ],
      ),
    );
  }
}
