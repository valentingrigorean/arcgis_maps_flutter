// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageScreenLocation extends StatefulWidget {
  const MapPageScreenLocation({Key? key}) : super(key: key);

  @override
  State<MapPageScreenLocation> createState() => _MapPageScreenLocationState();
}

class _MapPageScreenLocationState extends State<MapPageScreenLocation> {
  ArcgisMapController? _arcgisMapController;
  AGSPoint? _onLastClickDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen location'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTapDown: (e) async {
              if (_arcgisMapController == null) {
                return;
              }
              _onLastClickDetails =
                  await _arcgisMapController!.screenToLocation(e.localPosition);
              await _arcgisMapController!.locationToScreen(_onLastClickDetails!);
              print(e);
              setState(() {});
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: ArcgisMapView(
                    map: ArcGISMap.openStreetMap(),
                    onMapCreated: (controller) async {
                      _arcgisMapController = controller;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    color: Colors.grey.withOpacity(0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'ScreenSize:${constraints.maxWidth.toStringAsFixed(0)}x${constraints.maxHeight.toStringAsFixed(0)},'),
                        if (_onLastClickDetails != null)
                          Text(
                              'Current LatLng:${_onLastClickDetails!.y.toStringAsFixed(2)},${_onLastClickDetails!.x.toStringAsFixed(2)}')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
