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
        operationalLayers: {_layer},
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
                print('LegendInfo:${result.results.length}');
              },
        child: Icon(Icons.info),
      ),
    );
  }
}
