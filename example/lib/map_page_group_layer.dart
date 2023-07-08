import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageGroupLayer extends StatefulWidget {
  const MapPageGroupLayer({Key? key}) : super(key: key);

  @override
  State<MapPageGroupLayer> createState() => _MapPageGroupLayerState();
}

class _MapPageGroupLayerState extends State<MapPageGroupLayer> {
  final _operationalLayers = {
    GroupLayer(
      layerId: const LayerId('Group'),
      layers: {
        FeatureLayer.fromUrl(
            'https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Trailheads_Styled/FeatureServer/0'),
        FeatureLayer.fromUrl(
            'https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Trails_Styled/FeatureServer/0'),
        FeatureLayer.fromUrl(
            'https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Parks_and_Open_Space_Styled/FeatureServer/0'),
      },
    ),
  };
  bool _showLayers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Layer'),
      ),
      body: ArcgisMapView(
        map: const ArcGISMap.fromBasemap(
          Basemap.fromStyle(
            basemapStyle: BasemapStyle.arcGISCommunity,
          ),
        ),
        operationalLayers: _showLayers ? _operationalLayers : const {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showLayers = !_showLayers;
          });
        },
        child: !_showLayers
            ? const Icon(Icons.layers_clear)
            : const Icon(Icons.layers),
      ),
    );
  }
}
