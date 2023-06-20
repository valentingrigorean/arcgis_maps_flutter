import 'dart:async';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPageGeodeticDistance extends StatefulWidget {
  const MapPageGeodeticDistance({Key? key}) : super(key: key);

  @override
  State<MapPageGeodeticDistance> createState() =>
      _MapPageGeodeticDistanceState();
}

class _MapPageGeodeticDistanceState extends State<MapPageGeodeticDistance> {
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  Point? _userLocation;

  StreamSubscription? _locationSubscription;

  @override
  void initState() {
    super.initState();

    requestPermission();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Widget body;
    if (_permissionStatus == PermissionStatus.granted) {
      body = ArcgisMapView(
        map: const ArcGISMap.fromBasemap(
          Basemap.fromStyle(
            basemapStyle: BasemapStyle.arcGISCommunity,
          ),
        ),
        myLocationEnabled: true,
        onMapCreated: (controller) {
          controller.locationDisplay.wanderExtentFactor = 0.0;
          _locationSubscription = controller.locationDisplay.onLocationChanged
              .listen((Location? location) {
            if (location != null) _userLocation = location.position;
          });
          Future.delayed(const Duration(seconds: 1)).then((value) async {
            if (mounted) {
              _userLocation = await controller.locationDisplay.mapLocation;
            }
          });
        },
        onTap: (_, Point? point) async {
          if (_userLocation == null) {
            return;
          }
          if(point == null)return;
          if (point.spatialReference?.wkId !=
              _userLocation?.spatialReference?.wkId) {
            if (_userLocation!.spatialReference == null) {
              _userLocation = await GeometryEngine.project(
                  _userLocation!, point.spatialReference!) as Point;
            } else {
              point = await GeometryEngine.project(
                  point, _userLocation!.spatialReference!) as Point;
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
          if (!mounted) {
            return;
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
            // LocationPermissions().openAppSettings();
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

  Future<void> requestPermission() async {
    var currentStatus = await Permission.locationWhenInUse.status;
    PermissionStatus newStatus;
    if (currentStatus != PermissionStatus.granted) {
      newStatus = PermissionStatus.granted;
    } else {
      newStatus = await Permission.locationWhenInUse.request();
    }

    if (mounted) {
      setState(() {
        _permissionStatus = newStatus;
      });
    }
  }
}
