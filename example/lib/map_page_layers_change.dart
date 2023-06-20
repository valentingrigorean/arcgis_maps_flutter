// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageLayersChange extends StatefulWidget {
  const MapPageLayersChange({Key? key}) : super(key: key);

  @override
  State<MapPageLayersChange> createState() => _MapPageLayersChangeState();
}

class _MapPageLayersChangeState extends State<MapPageLayersChange> {
  final FeatureLayer _featureLayer = FeatureLayer.fromUrl(
      'https://services3.arcgis.com/GVgbJbqm8hXASVYi/arcgis/rest/services/Trailheads/FeatureServer/0');

  bool _isFeatureVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layers Changed event.'),
      ),
      body: ArcgisMapView(
        map: const ArcGISMap.fromBasemap(
          Basemap.fromStyle(
            basemapStyle: BasemapStyle.arcGISCommunity,
          ),
        ),
        onMapCreated: (controller) {
          controller.addLayersChangedListener(_LayersChangedListener());
        },
        operationalLayers: _isFeatureVisible ? {_featureLayer} : const {},
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            _isFeatureVisible = !_isFeatureVisible;
          });
        },
      ),
    );
  }
}

class _LayersChangedListener implements LayersChangedListener {
  @override
  void onLayersChanged(LayerType onLayer, LayerChangeType layerChange) {
    print(
        'LayerType: $onLayer layerChange:$layerChange');
  }

}
