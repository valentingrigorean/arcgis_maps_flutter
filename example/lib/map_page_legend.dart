// ignore_for_file: avoid_print

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageLegend extends StatefulWidget {
  const MapPageLegend({Key? key}) : super(key: key);

  @override
  State<MapPageLegend> createState() => _MapPageLegendState();
}

class _MapPageLegendState extends State<MapPageLegend> {
  // ignore: unused_field
  final Layer _layer = WmsLayer.fromUrl(
      'https://wms.geonorge.no/skwms1/wms.dybdedata2?service=WMS&request=GetCapabilities',
      layersName: [
        'grunne',
        'flytedokk',
        'Dybdepunkt',
        'Dybdelag',
        'Dybdekontur'
      ]);

  static Set<Layer> getLakeLayers() => {
    FeatureLayer.fromUrl(
      'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/1',
      opacity: 0.4,
    ),
    FeatureLayer.fromUrl(
      'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/2',
      opacity: 0.4,
    ),
    FeatureLayer.fromUrl(
      'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/3',
      opacity: 0.4,
    ),
    FeatureLayer.fromUrl(
      'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/4',
      opacity: 0.4,
    ),
    FeatureLayer.fromUrl(
      'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/5',
      opacity: 0.4,
    ),
    FeatureLayer.fromUrl(
      'https://nve.geodataonline.no/arcgis/rest/services/Innsjodatabase2/MapServer/6',
      opacity: 0.4,
    ),
  };

  ArcgisMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Legend'),
      ),
      body: ArcgisMapView(
        map:const ArcGISMap.fromBasemapStyle(BasemapStyle.arcGISImageryLabels),
        // operationalLayers: {_layer},
        onMapCreated: (controller) {
          _controller = controller;
          setState(() {});
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller == null
            ? null
            : () async {
                final result = await _controller!.getLegendInfosForLayers(getLakeLayers());
                print('LegendInfo:${result.length}');

                showDialog(
                  context: context,
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Results'),
                      ),
                      body: ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          final item = result[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(item.layerName),
                              ),
                              for (final legend in item.results) ...[
                                ListTile(
                                  title: Text(legend.name),
                                  trailing: legend.symbolImage != null
                                      ? Image.memory(
                                          legend.symbolImage!,
                                        )
                                      : null,
                                )
                              ]
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
        child: const Icon(Icons.info),
      ),
    );
  }
}
