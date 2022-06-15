import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MapPageLocator extends StatefulWidget {
  const MapPageLocator({Key? key}) : super(key: key);

  @override
  _MapPageLocatorState createState() => _MapPageLocatorState();
}

class _MapPageLocatorState extends State<MapPageLocator> {
  final LocatorTask _locatorTask =  LocatorTask(
      url:
          'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer');
  List<GeocodeResult> _results = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _locatorTask.getLocatorInfo().then((value) {
      if(kDebugMode){
        print(value);
      }
    });
  }

  @override
  void dispose() {
    _locatorTask.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locator'),
      ),
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: _isLoading,
            child: ArcgisMapView(
              map: ArcGISMap.imageryWithLabelsVector(),
              onTap: (point) async {
                setState(() {
                  _isLoading = true;
                });
                _results.clear();
                try {
                  final results = await _locatorTask.reverseGeocode(point);
                  setState(() {
                    _results = results;
                    _isLoading = false;
                  });
                } catch (ex) {
                  if (kDebugMode) {
                    print(ex);
                  }
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_results.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                height: 300,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    return ListTile(
                      title: Text(result.label),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
