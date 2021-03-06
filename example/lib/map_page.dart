import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore_for_file: unused_field

final geodataCredentials = Credential.creteUserCredential(
  username: dotenv.env['username']!,
  password: dotenv.env['password']!,
);

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> implements ViewpointChangedListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Set<Layer> _lakeLayers = {
    FeatureLayer.fromUrl(
      'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/1',
      opacity: 0.4,
    ),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/2'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/3'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/4'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/5'),
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/6'),
  };

  bool _showLayers = false;

  bool _trackCamera = false;

  ArcGISMap map = ArcGISMap.openStreetMap();

  ArcgisMapController? _mapController;

  CompassController? _compasController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        title: Text("Map"),
      ),
      body: _buildMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController?.removeViewpointChangedListener(this);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMap() {
    var mapView = ArcgisMapView(
      map: map,
      onMapCreated: onMapCreated,
      autoPanMode: AutoPanMode.navigation,
      onMapLoaded: (error) {
        if (error != null) {
          print(error);
        } else {
          print('map loaded.');
        }
      },
      markers: {
        Marker(
          markerId: MarkerId("markerId"),
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
      referenceLayers: _showLayers ? _lakeLayers : const {},
      // operationalLayers: {
      //   WmsLayer.fromUrl(
      //       'https://wms.geonorge.no/skwms1/wms.dybdedata2?service=WMS&request=GetCapabilities',
      //       layersName: [
      //         'grunne',
      //         'flytedokk',
      //         'Dybdepunkt',
      //         'Dybdelag',
      //         'Dybdekontur'
      //       ]),
      // },
      // onIdentifyLayers: (layers) {
      //   for (var layer in layers) {
      //     print('LayerName:' + layer.layerName);
      //     for (var element in layer.elements) {
      //       print('geometry:' +
      //           (element.geometry?.toJson().toString() ?? 'null'));
      //       element.attributes.forEach((key, value) {
      //         print(key + ':' + (value?.toString() ?? 'null'));
      //       });
      //     }
      //   }
      // },
      onLayerLoaded: (layer, error) {
        if (error != null) {
          print('Failed to load $layer:$error');
        } else {
          print('Loaded layer $layer');
        }
      },
      onCameraMove: _trackCamera
          ? () {
              print('onCameraMove');
            }
          : null,
    );

    return Stack(
      children: [
        mapView,
        if (_compasController != null)
          Positioned(
            right: 16,
            top: 16,
            child: Compass(
              controller: _compasController!,
            ),
          )
      ],
    );
  }

  Widget _buildMapsTypes(ScrollController scrollController) {
    var items = BasemapType.values;

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
                map = ArcGISMap.fromBasemapType(
                  basemapType: items[index],
                  longitude: 41.3678,
                  latitude: 28.5588,
                  levelOfDetail: 10,
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
    _compasController = CompassController.fromMapController(mapController);
    setState(() {});
  }

  @override
  void viewpointChanged() async {
    final rotation = await _mapController!.getMapRotation();
    print('viewpointChanged -> map rotation $rotation}');
  }
}
