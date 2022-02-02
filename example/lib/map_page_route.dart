import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageRoute extends StatefulWidget {
  const MapPageRoute({Key? key}) : super(key: key);

  @override
  _MapPageRouteState createState() => _MapPageRouteState();
}

class _MapPageRouteState extends State<MapPageRoute> {
  final RouteTask _routeTask = RouteTask(
    url:
        'https://sampleserver6.arcgisonline.com/arcgis/rest/services/NetworkAnalysis/SanDiego/NAServer/Route',
  );
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('start'),
      position: AGSPoint(
        x: -117.16,
        y: 32.74,
        spatialReference: SpatialReference.wgs84(),
      ),
      icon: BitmapDescriptor.fromStyleMarker(
          style: SimpleMarkerSymbolStyle.circle, color: Colors.red, size: 30),
    ),
    Marker(
      markerId: const MarkerId('end'),
      position: AGSPoint(
        x: -117.15,
        y: 32.70,
        spatialReference: SpatialReference.wgs84(),
      ),
      icon: BitmapDescriptor.fromStyleMarker(
          style: SimpleMarkerSymbolStyle.square, color: Colors.green, size: 30),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page Route'),
      ),
      body: ArcgisMapView(
        map: ArcGISMap.openStreetMap(),
        viewpoint: Viewpoint.fromPoint(
          point: AGSPoint.fromLatLng(latitude: 32.71, longitude: -117.1611),
          scale: 20000,
        ),
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.alt_route),
        onPressed: _testRoute,
      ),
    );
  }

  void _testRoute() async {
    final routeInfo = await _routeTask.geRouteTaskInfo();
    final defaultParam = (await _routeTask.createDefaultParameters())
        .copyWith(returnRoutes: true);
    final routeResults = await _routeTask.solveRoute(defaultParam);
    print(routeResults);
  }
}
