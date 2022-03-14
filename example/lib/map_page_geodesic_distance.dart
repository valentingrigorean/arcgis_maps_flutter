import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class MapPageGeodeticDistance extends StatefulWidget {
  const MapPageGeodeticDistance({Key? key}) : super(key: key);

  @override
  _MapPageGeodeticDistanceState createState() =>
      _MapPageGeodeticDistanceState();
}

class _MapPageGeodeticDistanceState extends State<MapPageGeodeticDistance>
    implements LocationChangeListener {
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  ArcgisMapController? _controller;
  AGSPoint? _userLocation;

  @override
  void initState() {
    super.initState();

    requestPermission(LocationPermissionLevel.locationWhenInUse);
  }

  @override
  void dispose() {
    _controller?.removeLocationChangedListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Widget body;
    if (_permissionStatus == PermissionStatus.granted) {
      body = ArcgisMapView(
        map: ArcGISMap.topographic(),
        myLocationEnabled: true,
        wanderExtentFactor: 0.0,
        onMapCreated: (controller) {
          controller.addLocationChangedListener(this);
          _controller = controller;
          Future.delayed(const Duration(seconds: 1)).then((value) async {
            if (mounted) {
              _userLocation = await controller.getMapLocation();
            }
          });
        },
        onTap: (AGSPoint point) async {
          if (_userLocation == null) {
            return;
          }
          if (point.spatialReference?.wkId !=
              _userLocation?.spatialReference?.wkId) {
            if (_userLocation!.spatialReference == null) {
              _userLocation = await GeometryEngine.project(
                  _userLocation!, point.spatialReference!) as AGSPoint;
            } else {
              point = await GeometryEngine.project(
                  point, _userLocation!.spatialReference!) as AGSPoint;
            }
          }
          final result = await GeometryEngine.distanceGeodetic(
            point1: _userLocation!,
            point2: point,
            distanceUnitId: LinearUnitId.meters,
            azimuthUnitId: AngularUnitId.degrees,
            curveType: GeodeticCurveType.geodesic,
          );
          late String msg;
          if (result == null) {
            msg = 'Distance is null';
          } else {
            msg = 'Distance: ${result.distance.toStringAsFixed(2)} meters';
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(msg),
          ));
        },
      );
    } else {
      body = Center(
        child: ElevatedButton(
          onPressed: () {
            LocationPermissions().openAppSettings();
          },
          child: const Text('Permission Required'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geodesic Distance'),
      ),
      body: body,
    );
  }

  Future<void> requestPermission(
      LocationPermissionLevel permissionLevel) async {
    final PermissionStatus permissionRequestResult = await LocationPermissions()
        .requestPermissions(permissionLevel: permissionLevel);

    setState(() {
      _permissionStatus = permissionRequestResult;
    });
  }

  @override
  void onLocationChanged(Location location) {
    _userLocation = location.position;
  }
}
