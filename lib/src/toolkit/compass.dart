import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class CompassController extends ChangeNotifier {
  final ArcgisMapController? mapController;
  double _rotation = 0;

  CompassController._(this._rotation, this.mapController){
    if(mapController != null){

    }
  }

  CompassController({double rotation = 0})
      : _rotation = rotation,
        mapController = null;

  factory CompassController.fromMapController(
      ArcgisMapController mapController) {
    return CompassController._(0, mapController);
  }

  double get rotation => _rotation;


  @override
  void dispose() {
    super.dispose();
  }
}

class Compass extends StatelessWidget {
  const Compass({
    Key? key,
    this.width = 30,
    this.height = 30,
    this.autohide = true,
  }) : super(key: key);

  final double width;
  final double height;

  final bool autohide;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
