import 'dart:typed_data';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageExportImage extends StatefulWidget {
  const MapPageExportImage({Key? key}) : super(key: key);

  @override
  State<MapPageExportImage> createState() => _MapPageExportImageState();
}

class _MapPageExportImageState extends State<MapPageExportImage> {
  late final ArcgisMapController _mapController;
  bool _didLoad = false;

  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Screenshot'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ArcgisMapView(
              map: ArcGISMap.imagery(),
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              onMapLoaded: (error) {
                setState(() {
                  _didLoad = true;
                });
              },
            ),
          ),
          if (_image != null)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 200,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Image.memory(
                  _image!,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _didLoad
          ? FloatingActionButton(
              child: const Icon(Icons.camera_alt),
              onPressed: () async {
                _image = await _mapController.exportImage();
                if (mounted) {
                  setState(() {});
                }
              },
            )
          : null,
    );
  }
}
