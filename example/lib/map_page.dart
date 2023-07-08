// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';
// ignore_for_file: unused_field



class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> implements ViewpointChangedListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final bool _showLayers = false;

  final bool _trackCamera = false;

  ArcGISMap map = const ArcGISMap.fromBasemapStyle(BasemapStyle.arcGISImagery);

  ArcgisMapController? _mapController;

  CompassController? _compassController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        title: const Text("Map"),
      ),
      body: _buildMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController?.removeViewpointChangedListener(this);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMap() {
    var mapView = ArcgisMapView(
      map: map,
      scalebarConfiguration: const ScalebarConfiguration(style: ScalebarStyle.dualUnitLineNauticalMile),
      onMapCreated: onMapCreated,
      onMapLoaded: (error) {
        if (error != null) {
          print(error);
        } else {
          print('map loaded.');
        }
      },
      markers: {
        Marker(
          markerId: const MarkerId("markerId"),
          position: Point.fromLatLng(latitude: 0, longitude: 0),
          onTap: () => print('On marker tap'),
          consumeTapEvents: true,
          icon: BitmapDescriptor.fromStyleMarker(
            style: SimpleMarkerSymbolStyle.square,
            color: Colors.red,
            size: 30,
          ),
        )
      },
    );

    return Stack(
      children: [
        mapView,
        if (_compassController != null)
          Positioned(
            right: 16,
            top: 16,
            child: Compass(
              controller: _compassController!,
            ),
          )
      ],
    );
  }

  // ignore: unused_element
  Widget _buildMapsTypes(ScrollController scrollController) {
    var items = BasemapStyle.values;

    return Container(
      color: Colors.white,
      child: ListView.builder(
        controller: scrollController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              items[index].toString(),
            ),
            onTap: () {
              setState(() {
                map = ArcGISMap.fromBasemapStyle(
                 items[index],
                );
              });
              Navigator.pop(_scaffoldKey.currentContext!);
            },
          );
        },
      ),
    );
  }

  void onMapCreated(ArcgisMapController mapController) {
    _mapController = mapController;
    mapController.locationDisplay.autoPanMode = AutoPanMode.navigation;
    _compassController = CompassController.fromMapController(mapController);
    setState(() {});
  }

  @override
  void viewpointChanged() async {
    final rotation = await _mapController!.getMapRotation();
    print('viewpointChanged -> map rotation $rotation}');
  }
}
