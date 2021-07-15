import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageLegend extends StatefulWidget {
  const MapPageLegend({Key? key}) : super(key: key);

  @override
  _MapPageLegendState createState() => _MapPageLegendState();
}

class _MapPageLegendState extends State<MapPageLegend> {
  final Layer _layer = WmsLayer.fromUrl(
      'https://wms.geonorge.no/skwms1/wms.dybdedata2?service=WMS&request=GetCapabilities',
      layersName: [
        'grunne',
        'flytedokk',
        'Dybdepunkt',
        'Dybdelag',
        'Dybdekontur'
      ]);

  ArcgisMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Legend'),
      ),
      body: ArcgisMapView(
        map: ArcGISMap.openStreetMap(),
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
                final result = await _controller!.getLegendInfos(_layer);
                print('LegendInfo:${result.length}');

                showDialog(
                  context: context,
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('Results'),
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
        child: Icon(Icons.info),
      ),
    );
  }
}
