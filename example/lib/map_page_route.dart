import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MapPageRoute extends StatefulWidget {
  const MapPageRoute({Key? key}) : super(key: key);

  @override
  State<MapPageRoute> createState() => _MapPageRouteState();
}

class _MapPageRouteState extends State<MapPageRoute> {
  final RouteTask _routeTask = RouteTask(
    url:
        'https://route-api.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World',
  );

  final List<Stop> _demoStops = [
    Stop(
      point: Point(
        x: -122.690176,
        y: 45.522054,
        spatialReference: SpatialReference.wgs84(),
      ),
    ),
    Stop(
      point: Point(
        x: -122.614995,
        y: 45.526201,
        spatialReference: SpatialReference.wgs84(),
      ),
    ),
    Stop(
      point: Point(
        x: -122.68782,
        y: 45.51238,
        spatialReference: SpatialReference.wgs84(),
      ),
    )
  ];

  final Set<Marker> _markers = {};

  final Set<PolylineMarker> _routeLines = {};
  final List<DirectionManeuver> _directions = [];

  late final ArcgisMapController _mapController;

  @override
  void initState() {
    super.initState();
    _makeMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page Route'),
      ),
      body: Stack(
        children: [
          ArcgisMapView(
            map: const ArcGISMap.fromBasemap(
              Basemap.fromStyle(
                basemapStyle: BasemapStyle.arcGISNavigation,
              ),
            ),
            viewpoint: Viewpoint.fromLatLng(
              latitude: 45.526201,
              longitude: -122.65,
              scale: 144447.638572,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
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
        onPressed: _testRoute,
        child: const Icon(Icons.alt_route),
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

  void _makeMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('origin'),
        position: _demoStops[0].geometry!,
        icon: BitmapDescriptor.fromStyleMarker(
          style: SimpleMarkerSymbolStyle.circle,
          color: Colors.green,
          size: 24,
        ),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('stop'),
        position: _demoStops[1].geometry!,
        icon: BitmapDescriptor.fromStyleMarker(
          style: SimpleMarkerSymbolStyle.diamond,
          color: Colors.red,
          size: 12,
        ),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: _demoStops[2].geometry!,
        icon: BitmapDescriptor.fromStyleMarker(
          style: SimpleMarkerSymbolStyle.circle,
          color: Colors.black,
          size: 24,
        ),
      ),
    );
  }

  void _testRoute() async {
    try {
      final parameters = await _routeTask.createDefaultParameters();

      final routeResults = await _routeTask.solveRoute(parameters.copyWith(
        stops: _demoStops,
        returnDirections: true,
        directionsLanguage: 'es',
      ));
      if (routeResults.routes.isNotEmpty) {
        final route = routeResults.routes.first;
        if (route.routeGeometry != null) {
          final didSetViewPoint = await _mapController
              .setViewpointGeometry(route.routeGeometry!, padding: 50);
          if (kDebugMode) {
            print('didSetViewPoint: $didSetViewPoint');
          }
        }
        _routeLines.clear();
        _routeLines.add(
          PolylineMarker(
            polylineId: const PolylineId('route'),
            points: route.routeGeometry!.points.first
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
    } catch (ex, stackTrace) {
      debugPrint('ex: $ex\nstackTrace:\n$stackTrace');
    }
  }
}
