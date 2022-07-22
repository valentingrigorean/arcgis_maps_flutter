import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapPageScaleBar extends StatefulWidget {
  const MapPageScaleBar({
    Key? key,
  }) : super(key: key);

  @override
  State<MapPageScaleBar> createState() => _MapPageScaleBarState();
}

class _MapPageScaleBarState extends State<MapPageScaleBar> {
  final ScalebarConfiguration _defaultScaleConfiguration =
      const ScalebarConfiguration(
    inMapAlignment: ScalebarAlignment.center,
    style: ScalebarStyle.dualUnitLine,
  );
  static   ScalebarConfiguration _customScaleConfiguration = const ScalebarConfiguration(
    showInMap: false,
    autoHide: true,
    hideAfter: Duration(milliseconds: 500),
    units: ScalebarUnits.imperial,
    style: ScalebarStyle.dualUnitLineNauticalMile,
  );

  bool _useCustom = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScaleBar'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _useCustom = !_useCustom;
          });
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            ArcgisMapView(
              map: ArcGISMap.openStreetMap(),
              scalebarConfiguration: _useCustom
                  ? _customScaleConfiguration
                  : _defaultScaleConfiguration,
            ),
            if (_useCustom)
              Positioned(
                left: 16,
                bottom: 16,
                child: Column(
                  children: [
                    Slider(
                      value: _customScaleConfiguration.offset.dx,
                      min: 0,
                      max: constraints.maxWidth,
                      onChanged: (val) {
                        setState(
                          () {
                            _customScaleConfiguration =
                                _customScaleConfiguration.copyWith(
                              offset: Offset(
                                val,
                                _customScaleConfiguration.offset.dy,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Slider(
                      value: _customScaleConfiguration.offset.dy,
                      min: 0,
                      max: constraints.maxHeight,
                      onChanged: (val) {
                        setState(
                          () {
                            _customScaleConfiguration =
                                _customScaleConfiguration.copyWith(
                              offset: Offset(
                                _customScaleConfiguration.offset.dx,
                                val,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
