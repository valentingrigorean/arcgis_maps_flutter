// ignore_for_file: avoid_print

import 'dart:async';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPageAutoPanMode extends StatefulWidget {
  const MapPageAutoPanMode({Key? key}) : super(key: key);

  @override
  State<MapPageAutoPanMode> createState() => _MapPageAutoPanModeState();
}

class _MapPageAutoPanModeState extends State<MapPageAutoPanMode> {
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  late LocationDisplay _locationDisplay;
  StreamSubscription? _onAutoPanModeChangedSubscription;
  AutoPanMode _autoPanMode = AutoPanMode.off;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  void dispose() {
    _onAutoPanModeChangedSubscription?.cancel();
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
          _locationDisplay = controller.locationDisplay;
          controller.locationDisplay.wanderExtentFactor = 0.0;
          controller.locationDisplay.autoPanMode = _autoPanMode;

          _onAutoPanModeChangedSubscription = controller
              .locationDisplay.onAutoPanModeChanged
              .listen((newPanMode) {
            setState(() {
              _autoPanMode = newPanMode;
            });
          });
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
        title: const Text('AutoPanMode'),
      ),
      body: body,
      floatingActionButton: _permissionStatus != PermissionStatus.granted
          ? null
          : FloatingActionButton(
              child: _getLocationWidget(),
              onPressed: () {
                switch (_autoPanMode) {
                  case AutoPanMode.off:
                    setState(() {
                      _autoPanMode = AutoPanMode.recenter;
                    });
                    break;
                  case AutoPanMode.recenter:
                    setState(() {
                      _autoPanMode = AutoPanMode.compassNavigation;
                    });
                    break;
                  case AutoPanMode.compassNavigation:
                    setState(() {
                      _autoPanMode = AutoPanMode.off;
                    });
                    break;
                  default:
                    break;
                }
                _locationDisplay.autoPanMode = _autoPanMode;
              },
            ),
    );
  }

  Widget _getLocationWidget() {
    int rotation = 0;
    late IconData iconData;

    switch (_autoPanMode) {
      case AutoPanMode.off:
        iconData = Icons.near_me_outlined;
        break;
      case AutoPanMode.recenter:
        iconData = Icons.near_me;
        break;
      case AutoPanMode.navigation:
        return const SizedBox();
      case AutoPanMode.compassNavigation:
        iconData = Icons.near_me;
        rotation = 317;
        break;
    }

    final Widget icon = Icon(iconData);
    if (rotation == 0) {
      return icon;
    }
    return RotationTransition(
      turns: AlwaysStoppedAnimation(rotation / 360),
      child: icon,
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

    if(mounted){
      setState(() {
        print(newStatus);
        _permissionStatus = newStatus;
        print(_permissionStatus);
      });
    }
  }
}
