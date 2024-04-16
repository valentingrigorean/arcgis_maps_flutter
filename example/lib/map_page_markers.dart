import 'dart:math';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageMarkers extends StatefulWidget {
  const MapPageMarkers({super.key});

  @override
  State<MapPageMarkers> createState() => _MapPageMarkersState();
}

class _MapPageMarkersState extends State<MapPageMarkers> {
  static final Random _random = Random();

  static final Map<int, SimpleMarkerSymbolStyle> _styleMap = {
    0: SimpleMarkerSymbolStyle.circle,
    1: SimpleMarkerSymbolStyle.cross,
    2: SimpleMarkerSymbolStyle.diamond,
    3: SimpleMarkerSymbolStyle.triangle
  };

  static final Map<int, Color> _colorMap = {
    0: Colors.red,
    1: Colors.blue,
    2: Colors.green,
    3: Colors.pinkAccent
  };

  late final ArcgisMapController _mapController;
  final List<Graphic> _markers = [];

  @override
  void initState() {
    super.initState();
    _generateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markers'),
      ),
      body: ArcgisMapView(
        onMapCreated: (controller){
          _mapController = controller;
          controller.createOrUpdateGraphicsOverlay(
            const GraphicsOverlay(id: 'default'),
          );
          controller.addGraphicsToOverlay('default', _markers);
        },
        map: const ArcGISMap.fromBasemap(
          Basemap.fromStyle(
            basemapStyle: BasemapStyle.arcGISCommunity,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          _generateMarkers();
          _mapController.clearGraphicsOverlay('default');
          _mapController.addGraphicsToOverlay('default', _markers);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _generateMarkers() {
    _markers.clear();
    for (int i = 0; i < 5000; i++) {
      final int style = _random.nextInt(4);
      final int color = _random.nextInt(4);
      final Graphic marker = Graphic(
        graphicId: i.toString(),
        geometry: Point.fromLatLng(
          latitude: _random.nextDouble() * 360 - 180,
          longitude: _random.nextDouble() * 180 - 90,
        ),
        symbol: SimpleMarkerSymbol(
          style: _styleMap[style]!,
          color: _colorMap[color]!,
          size: 30,
        ),
      );
      _markers.add(marker);
    }
  }
}
