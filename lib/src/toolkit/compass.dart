part of arcgis_maps_flutter;

class CompassController extends ChangeNotifier
    implements ViewpointChangedListener {
  ArcgisMapController? _mapController;
  double _rotation = 0;

  CompassController._(this._rotation, this._mapController) {
    _mapController?.addViewpointChangedListener(this);
  }

  CompassController({double rotation = 0})
      : _rotation = rotation,
        _mapController = null;

  factory CompassController.fromMapController(
      ArcgisMapController mapController) {
    return CompassController._(0, mapController);
  }

  @override
  void dispose() {
    _mapController?.removeViewpointChangedListener(this);
    super.dispose();
  }

  double get rotation => _rotation;

  set rotation(double newValue) {
    if (_rotation == newValue) return;
    _rotation = newValue;
    notifyListeners();
  }

  void setMapController(ArcgisMapController? mapController) {
    if (_mapController != null) {
      if (_mapController == mapController) return;
      _mapController?.removeViewpointChangedListener(this);
    }
    _mapController = mapController;
    mapController?.addViewpointChangedListener(this);
  }

  @override
  void viewpointChanged() async {
    final controller = _mapController;
    if (controller == null) return;
    rotation = await controller.getMapRotation();
  }
}

class Compass extends StatefulWidget {
  const Compass({
    Key? key,
    required this.controller,
    this.width = 50,
    this.height = 50,
    this.autohide = true,
    this.child,
  }) : super(key: key);

  final double width;
  final double height;

  final bool autohide;

  final CompassController controller;

  final Widget? child;

  @override
  _CompassState createState() => _CompassState();
}

class _CompassState extends State<Compass> with SingleTickerProviderStateMixin {
  late final CompassController _compassController = widget.controller
    ..addListener(_handleRotationChange);

  late double _rotation = _degreesToRadians(_compassController.rotation);

  late bool _visible = _compassController.rotation != 0;

  @override
  void dispose() {
    _compassController.removeListener(_handleRotationChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child ??
        Image.asset(
          'assets/ic_compass.png',
          package: 'arcgis_maps_flutter',
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
        );

    child = SizedBox(
      width: widget.width,
      height: widget.height,
      child: Transform.rotate(
        angle: _rotation,
        child: child,
      ),
    );

    if (_compassController._mapController != null) {
      child = GestureDetector(
        onTap: () async {
          await _compassController._mapController?.setViewpointRotation(0);
        },
        child: child,
      );
    }

    if (widget.autohide) {
      child = AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: child,
      );
    }

    return child;
  }

  void _handleRotationChange() {
    _visible = _compassController.rotation != 0;
    _rotation = _degreesToRadians(_compassController.rotation);
    if (mounted) {
      setState(() {});
    }
  }

  double _degreesToRadians(double degrees) {
    return (math.pi * (360 - degrees) / 180);
  }
}
