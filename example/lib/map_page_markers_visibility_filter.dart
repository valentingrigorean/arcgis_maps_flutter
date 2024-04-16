import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/utils.dart';
import 'package:flutter/material.dart';

class MapPageMarkersVisibilityFilter extends StatefulWidget {
  const MapPageMarkersVisibilityFilter({super.key});

  @override
  State<MapPageMarkersVisibilityFilter> createState() =>
      _MapPageMarkersVisibilityFilterState();
}

class _MapPageMarkersVisibilityFilterState
    extends State<MapPageMarkersVisibilityFilter> {
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

  static const Map<int, GraphicsOverlay> _filterOverlay = {
    0: GraphicsOverlay(
      id: 'filter0',
      minScale: ZoomLevel.vilage,
      maxScale: ZoomLevel.city,
    ),
    1: GraphicsOverlay(
      id: 'filter1',
      minScale: ZoomLevel.largeMetropolitanArea,
      maxScale: ZoomLevel.smallCountry,
    ),
    2: GraphicsOverlay(
      id: 'filter2',
      minScale: ZoomLevel.level23,
      maxScale: ZoomLevel.level15,
    ),
  };

  final Set<Graphic> _markers = List.generate(
    100,
    (index) {
      return Graphic(
          graphicId: index.toString(),
          geometry: Utils.getRandomLocation(
              Point.fromLatLng(latitude: 59.91, longitude: 10.76), 200000),
          symbol: SimpleMarkerSymbol(
            style: _styleMap[index % 4]!,
            color: _colorMap[index % 4]!,
            size: 40,
          ));
    },
  ).toSet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visibility Filter'),
      ),
      body: ArcgisMapView(
        onMapCreated: (controller) {
          controller.createOrUpdateGraphicsOverlay(
              const GraphicsOverlay(id: 'default'));
          controller
              .createOrUpdateGraphicsOverlays(_filterOverlay.values.toList());
          final Map<String, List<Graphic>> map = {
            'default': [],
            for (int i = 0; i < 3; i++)
              'filter$i': _markers.toList().sublist(i * 33, (i + 1) * 33)
          };
          for (final pair in map.entries) {
            controller.addGraphicsToOverlay(pair.key, pair.value);
          }
        },
        map: const ArcGISMap.fromBasemap(
          Basemap.fromStyle(
            basemapStyle: BasemapStyle.arcGISCommunity,
          ),
        ),
      ),
    );
  }
}
