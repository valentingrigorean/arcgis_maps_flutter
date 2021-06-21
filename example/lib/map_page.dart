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

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Set<Layer> _lakeLayers = {
    FeatureLayer.fromUrl(
        'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/1'),
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

  bool _showLayers = true;

  bool _trackCamera = false;

  ArcGISMap map = ArcGISMap.openStreetMap();

  ArcgisMapController? _mapController;

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
          setState(() {
            _showLayers = !_showLayers;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMap() {
    return ArcgisMapView(
      map: map,
      onMapCreated: onMapCreated,
      onMapLoaded: (error) {
        if (error != null) {
          print(error);
        } else {
          print('map loaded.');
        }
      },
      referenceLayers: _showLayers ? _lakeLayers : const {},
      onIdentifyLayers: (layers) {
        for (var layer in layers) {
          print('LayerName:' + layer.layerName);
          for (var element in layer.elements) {
            print('geometry:' +
                (element.geometry?.toJson().toString() ?? 'null'));
            element.attributes.forEach((key, value) {
              print(key + ':' + (value?.toString() ?? 'null'));
            });
          }
        }
      },
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
  }

  void _fabPressed() {
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        minChildSize: 0.3,
        initialChildSize: 0.3,
        maxChildSize: 0.6,
        builder: (context, scrollController) =>
            _buildMapsTypes(scrollController),
      ),
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
    setState(() {});
  }
}
