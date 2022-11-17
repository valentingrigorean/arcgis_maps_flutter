import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageViewInsets extends StatefulWidget {
  const MapPageViewInsets({Key? key}) : super(key: key);

  @override
  State<MapPageViewInsets> createState() => _MapPageViewInsetsState();
}

class _MapPageViewInsetsState extends State<MapPageViewInsets> {
  late final ArcgisMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ArcgisMapView(
            map: ArcGISMap.imagery(),
            isAttributionTextVisible: false,
            insetsContentInsetFromSafeArea: false,
            contentInsets: const EdgeInsets.only(bottom: 200),
            onTap: (_,point) {
              _mapController.setViewpointCenter(point);
            },
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              height: 200,
              color: Colors.amberAccent.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
  }
}
