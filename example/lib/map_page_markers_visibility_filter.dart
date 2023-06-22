import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter_example/utils.dart';
import 'package:flutter/material.dart';

class MapPageMarkersVisibilityFilter extends StatefulWidget {
  const MapPageMarkersVisibilityFilter({Key? key}) : super(key: key);

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

  static const Map<int, SymbolVisibilityFilter> _filterMap = {
    0: SymbolVisibilityFilter(
      maxZoom: ZoomLevel.level16,
      minZoom: ZoomLevel.level23,
    ),
    1: SymbolVisibilityFilter(
      maxZoom: ZoomLevel.level9,
      minZoom: ZoomLevel.level15,
    ),
    2: SymbolVisibilityFilter(
      maxZoom: ZoomLevel.largeCountry,
      minZoom: ZoomLevel.level23,
    ),
  };

  final Set<Marker> _markers = List.generate(
    100,
    (index) {
      return Marker(
        markerId: MarkerId(index.toString()),
        position: Utils.getRandomLocation(
            Point.fromLatLng(latitude: 59.91, longitude: 10.76), 200000),
        icon: BitmapDescriptor.fromStyleMarker(
          style: _styleMap[index % 4]!,
          color: _colorMap[index % 4]!,
          size: 40,
        ),
        visibilityFilter: index % 4 == 0 ? null : _filterMap[index % 3],
      );
    },
  ).toSet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visibility Filter'),
      ),
      body: ArcgisMapView(
        map: const ArcGISMap.fromBasemap(
          Basemap.fromStyle(
            basemapStyle: BasemapStyle.arcGISCommunity,
          ),
        ),
        markers: _markers,
      ),
    );
  }
}
