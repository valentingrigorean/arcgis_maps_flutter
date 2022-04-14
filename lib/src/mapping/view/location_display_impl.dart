import 'dart:async';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/services.dart';

class LocationDisplayImpl extends LocationDisplay {
  final StreamController<AutoPanMode> _autoPanModeStream =
      StreamController<AutoPanMode>.broadcast();
  final StreamController<Location> _locationStream =
      StreamController<Location>.broadcast();
  late final MethodChannel _channel;

  AutoPanMode _autoPanMode = AutoPanMode.off;
  double _initialZoomScale = 10000;
  double _navigationPointHeightFactor = 0.125;
  double _wanderExtentFactor = 0.5;
  bool _useCourseSymbolOnMovement = false;
  double _opacity = 1.0;
  bool _showAccuracy = true;
  bool _showLocation = true;
  bool _showPingAnimationSymbol = true;

  LocationDisplayImpl(int mapId) {
    _channel = MethodChannel(
        'plugins.flutter.io/arcgis_maps_${mapId}_location_display');
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  Stream<AutoPanMode> get onAutoPanModeChanged =>
      _autoPanModeStream.stream.distinct();

  @override
  Stream<Location> get onLocationChanged => _locationStream.stream.distinct();

  @override
  Future<bool> get started =>
      _channel.invokeMethod('getStarted').then((value) => value as bool);

  @override
  AutoPanMode get autoPanMode => _autoPanMode;

  @override
  set autoPanMode(AutoPanMode mode) {
    if (_autoPanMode == mode) {
      return;
    }
    _autoPanMode = mode;
    _channel.invokeMethod('setAutoPanMode', mode.index);
  }

  @override
  double get initialZoomScale => _initialZoomScale;

  @override
  set initialZoomScale(double scale) {
    if (_initialZoomScale == scale) {
      return;
    }
    _initialZoomScale = scale;
    _channel.invokeMethod('setInitialZoomScale', scale);
  }

  @override
  double get navigationPointHeightFactor => _navigationPointHeightFactor;

  @override
  set navigationPointHeightFactor(double factor) {
    if (_navigationPointHeightFactor == factor) {
      return;
    }
    _navigationPointHeightFactor = factor;
    _channel.invokeMethod('setNavigationPointHeightFactor', factor);
  }

  @override
  double get wanderExtentFactor => _wanderExtentFactor;

  @override
  set wanderExtentFactor(double factor) {
    if (_wanderExtentFactor == factor) {
      return;
    }
    _wanderExtentFactor = factor;
    _channel.invokeMethod('setWanderExtentFactor', factor);
  }

  @override
  Future<Location?> get location => _channel
      .invokeMethod('getLocation')
      .then((value) => value == null ? null : Location.fromJson(value));

  @override
  Future<AGSPoint?> get mapLocation => _channel
      .invokeMethod('getMapLocation')
      .then((value) => value == null ? null : AGSPoint.fromJson(value));

  @override
  Future<double> get heading => _channel
      .invokeMethod('getHeading')
      .then((value) => (value as num?)?.toDouble() ?? -1);

  @override
  bool get useCourseSymbolOnMovement => _useCourseSymbolOnMovement;

  @override
  set useCourseSymbolOnMovement(bool useCourseSymbolOnMovement) {
    if (_useCourseSymbolOnMovement == useCourseSymbolOnMovement) {
      return;
    }
    _useCourseSymbolOnMovement = useCourseSymbolOnMovement;
    _channel.invokeMethod(
        'setUseCourseSymbolOnMovement', useCourseSymbolOnMovement);
  }

  @override
  double get opacity => _opacity;

  @override
  set opacity(double opacity) {
    if (_opacity == opacity) {
      return;
    }
    _opacity = opacity;
    _channel.invokeMethod('setOpacity', opacity);
  }

  @override
  bool get showAccuracy => _showAccuracy;

  @override
  set showAccuracy(bool showAccuracy) {
    if (_showAccuracy == showAccuracy) {
      return;
    }
    _showAccuracy = showAccuracy;
    _channel.invokeMethod('setShowAccuracy', showAccuracy);
  }

  @override
  bool get showLocation => _showLocation;

  @override
  set showLocation(bool showLocation) {
    if (_showLocation == showLocation) {
      return;
    }
    _showLocation = showLocation;
    _channel.invokeMethod('setShowLocation', showLocation);
  }

  @override
  bool get showPingAnimationSymbol => _showPingAnimationSymbol;

  @override
  set showPingAnimationSymbol(bool showPingAnimationSymbol) {
    if (_showPingAnimationSymbol == showPingAnimationSymbol) {
      return;
    }
    _showPingAnimationSymbol = showPingAnimationSymbol;
    _channel.invokeMethod(
        'setShowPingAnimationSymbol', showPingAnimationSymbol);
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
  }

  @override
  Future<void> start() {
    return _channel.invokeMethod('start');
  }

  @override
  Future<void> stop() {
    return _channel.invokeMethod('stop');
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAutoPanModeChanged':
        _autoPanModeStream.add(AutoPanMode.values[call.arguments]);
        break;
      case 'onLocationChanged':
        _locationStream.add(Location.fromJson(call.arguments));
        break;
    }
  }
}
