import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class MapPageAutoPanMode extends StatefulWidget {
  const MapPageAutoPanMode({Key? key}) : super(key: key);

  @override
  _MapPageAutoPanModeState createState() => _MapPageAutoPanModeState();
}

class _MapPageAutoPanModeState extends State<MapPageAutoPanMode> {
  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  AutoPanMode _autoPanMode = AutoPanMode.off;

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
        autoPanMode: _autoPanMode,
        myLocationEnabled: true,
        wanderExtentFactor: 0.0,
        onAutoPanModeChanged: (newPanMode) {
          setState(() {
            _autoPanMode = newPanMode;
          });
        },
      );
    } else {
      body = Center(
        child: ElevatedButton(
          onPressed: () {
            LocationPermissions().openAppSettings();
          },
          child: Text('Permission Required'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('AutoPanMode'),
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
                      _autoPanMode = AutoPanMode.compass_navigation;
                    });
                    break;
                  case AutoPanMode.compass_navigation:
                    setState(() {
                      _autoPanMode = AutoPanMode.off;
                    });
                    break;
                  default:
                    break;
                }
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
      case AutoPanMode.compass_navigation:
        iconData = Icons.near_me;
        rotation = 317;
        break;
    }

    final Widget icon = Icon(iconData);
    if (rotation == 0) {
      return icon;
    }
    return RotationTransition(
      turns: new AlwaysStoppedAnimation(rotation / 360),
      child: icon,
    );
  }

  Future<void> requestPermission(
      LocationPermissionLevel permissionLevel) async {
    final PermissionStatus permissionRequestResult = await LocationPermissions()
        .requestPermissions(permissionLevel: permissionLevel);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult;
      print(_permissionStatus);
    });
  }
}
