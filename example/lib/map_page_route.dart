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
        x: -117.15083257944445,
        y: 32.741123367963446,
        spatialReference: SpatialReference.wgs84(),
      ),
      icon: BitmapDescriptor.fromStyleMarker(
          style: SimpleMarkerSymbolStyle.circle, color: Colors.red, size: 30),
    ),
    Marker(
      markerId: const MarkerId('end'),
      position: AGSPoint(
        x: -117.15557279683529,
        y: 32.703360305883045,
        spatialReference: SpatialReference.wgs84(),
      ),
      icon: BitmapDescriptor.fromStyleMarker(
          style: SimpleMarkerSymbolStyle.square, color: Colors.green, size: 30),
    ),
  };

  final Set<Polyline> _routeLines = {};
  final List<DirectionManeuver> _directions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page Route'),
      ),
      body: Stack(
        children: [
          ArcgisMapView(
            map: ArcGISMap.openStreetMap(),
            viewpoint: Viewpoint.fromLatLng(
              latitude: 32.741123367963446,
              longitude: -117.15083257944445,
              scale: 200000,
            ),
            markers: _markers,
            polylines: _routeLines,
          ),
          if (_directions.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 300,
                color: Colors.white,
                child: _buildDirections(),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.alt_route),
        onPressed: _testRoute,
      ),
    );
  }

  Widget _buildDirections() {
    return ListView.builder(
      itemCount: _directions.length,
      itemBuilder: (BuildContext context, int index) {
        final DirectionManeuver maneuver = _directions[index];
        return ListTile(
          title: Text(maneuver.directionText),
        );
      },
    );
  }

  void _testRoute() async {
    final defaultParam = (await _routeTask.createDefaultParameters())
        .copyWith(returnDirections: true, stops: [
      Stop(
        point: AGSPoint(
          x: -117.15083257944445,
          y: 32.741123367963446,
          spatialReference: SpatialReference.wgs84(),
        ),
      ),
      Stop(
        point: AGSPoint(
          x: -117.15557279683529,
          y: 32.703360305883045,
          spatialReference: SpatialReference.wgs84(),
        ),
      )
    ]);
    final routeResults = await _routeTask.solveRoute(defaultParam);
    if (routeResults.routes.isNotEmpty) {
      final route = routeResults.routes.first;
      _routeLines.clear();
      _routeLines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: route.routeGeometry!.points
              .map((e) => e.copyWithSpatialReference(
                    route.routeGeometry!.spatialReference,
                  ))
              .toList(),
          color: Colors.green,
          width: 5,
        ),
      );
      _directions.clear();
      _directions.addAll(route.directionManeuvers);
      if (mounted) {
        setState(() {});
      }
    }
  }
}
