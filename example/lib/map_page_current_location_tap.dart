import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class MapPageCurrentLocationTap extends StatefulWidget {
  const MapPageCurrentLocationTap({Key? key}) : super(key: key);

  @override
  State<MapPageCurrentLocationTap> createState() =>
      _MapPageCurrentLocationTapState();
}

class _MapPageCurrentLocationTapState extends State<MapPageCurrentLocationTap> {
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  late LocationDisplay _locationDisplay;

  @override
  void initState() {
    super.initState();
    requestPermission(LocationPermissionLevel.locationWhenInUse);
  }

  @override
  Widget build(BuildContext context) {
    late Widget body;

    if (_permissionStatus == PermissionStatus.granted) {
      body = ArcgisMapView(
        map: ArcGISMap.topographic(),
        myLocationEnabled: true,
        onUserLocationTap: () async {
          final point = await _locationDisplay.mapLocation;
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('You tapped current location. $point'),
                ],
              ),
            ),
          );
        },
        onMapCreated: (controller) {
          _locationDisplay = controller.locationDisplay;
          _locationDisplay.onLocationChanged.listen((event) {
            if (kDebugMode) {
              print('Location changed: $event');
            }
          });
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
        title: const Text('Current Location Tap'),
      ),
      body: body,
    );
  }

  Future<void> requestPermission(
      LocationPermissionLevel permissionLevel) async {
    final PermissionStatus permissionRequestResult = await LocationPermissions()
        .requestPermissions(permissionLevel: permissionLevel);
    _permissionStatus = permissionRequestResult;
    if (kDebugMode) {
      print(permissionRequestResult);
    }
    if (mounted) {
      setState(() {});
    }
  }
}
