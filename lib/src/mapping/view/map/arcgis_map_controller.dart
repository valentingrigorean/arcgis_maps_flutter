part of arcgis_maps_flutter;

// ignore_for_file: library_private_types_in_public_api
class ArcgisMapController {
  final _ArcgisMapViewState _arcgisMapState;
  late final _EventBaseHandler<ViewpointChangedListener>
      _viewpointChangedHandlers = _EventBaseHandler((register) {
    ArcgisMapsFlutterPlatform.instance
        .setViewpointChangedListenerEvents(mapId, register);
  });
  late final _EventBaseHandler<LayersChangedListener> _layersChangedHandlers =
      _EventBaseHandler((register) {
    ArcgisMapsFlutterPlatform.instance
        .setLayersChangedListener(mapId, register);
  });
  late final _EventBaseHandler<TimeExtentChangedListener>
      _timeExtentChangedHandlers = _EventBaseHandler((register) {
    ArcgisMapsFlutterPlatform.instance
        .setTimeExtentChangedListener(mapId, register);
  });

  final int mapId;

  ArcgisMapController._(
      this._arcgisMapState, this.mapId, this.locationDisplay) {
    _connectStream(mapId);
  }

  static Future<ArcgisMapController> init(
      int id, _ArcgisMapViewState arcgisMapState) async {
    await ArcgisMapsFlutterPlatform.instance.init(id);
    return ArcgisMapController._(
      arcgisMapState,
      id,
      LocationDisplayImpl(id),
    );
  }

  final LocationDisplay locationDisplay;

  Future<List<LegendInfoResult>> getLegendInfosForLayer(Layer layer) async {
    return await ArcgisMapsFlutterPlatform.instance
        .getLegendInfos(mapId, layer);
  }

  Set<T> getLayersOfType<T extends Layer>() {
    var layers = <T>{};
    for (final pair in _arcgisMapState._baseLayers.entries) {
      if (pair.value is T) {
        layers.add(pair.value as T);
      }
    }

    for (final pair in _arcgisMapState._referenceLayers.entries) {
      if (pair.value is T) {
        layers.add(pair.value as T);
      }
    }

    for (final pair in _arcgisMapState._operationalLayers.entries) {
      if (pair.value is T) {
        layers.add(pair.value as T);
      }
    }
    return layers;
  }

  Future<List<LegendInfoResult>> getLegendInfosForLayers(
      Set<Layer> layers) async {
    var futures = <Future<List<LegendInfoResult>>>[];
    for (final layer in layers) {
      futures.add(getLegendInfosForLayer(layer));
    }
    final result = await Future.wait(futures);
    return result.expand((e) => e).toList();
  }

  void addViewpointChangedListener(ViewpointChangedListener listener) {
    _viewpointChangedHandlers.addHandler(listener);
  }

  void removeViewpointChangedListener(ViewpointChangedListener listener) {
    _viewpointChangedHandlers.removeHandler(listener);
  }

  void addLayersChangedListener(LayersChangedListener listener) {
    _layersChangedHandlers.addHandler(listener);
  }

  void removeLayersChangedListener(LayersChangedListener listener) {
    _layersChangedHandlers.removeHandler(listener);
  }

  void addTimeExtentChangedListener(TimeExtentChangedListener listener) {
    _timeExtentChangedHandlers.addHandler(listener);
  }

  void removeTimeExtentChangedListener(TimeExtentChangedListener listener) {
    _timeExtentChangedHandlers.removeHandler(listener);
  }

  Future<TimeExtent?> getTimeExtent() {
    return ArcgisMapsFlutterPlatform.instance.getTimeExtent(mapId);
  }

  Future<void> setTimeExtent(TimeExtent? timeExtent) {
    return ArcgisMapsFlutterPlatform.instance.setTimeExtent(mapId, timeExtent);
  }

  Future<void> clearMarkerSelection() {
    return ArcgisMapsFlutterPlatform.instance.clearMarkerSelection(mapId);
  }

  Future<void> setViewpoint(Viewpoint viewpoint) {
    return ArcgisMapsFlutterPlatform.instance.setViewpoint(mapId, viewpoint);
  }

  /// True if the zoom animation completed, false if it was interrupted by another view navigation.
  Future<bool> setViewpointGeometry(Geometry geometry, {double? padding}) {
    return ArcgisMapsFlutterPlatform.instance
        .setViewpointGeometry(mapId, geometry, padding);
  }

  Future<bool> setViewpointCenter(AGSPoint center, {double? scale}) async {
    scale ??= await getMapScale();
    return ArcgisMapsFlutterPlatform.instance
        .setViewpointCenter(mapId, center, scale);
  }

  Future<List<SecondaryLayerContent>> getSecondaryLayers(String layerId) async {
    return ArcgisMapsFlutterPlatform.instance
        .getSecondaryLayers(mapId, layerId);
  }

  Future<bool> updateSecondaryLayerVisibility(
      String layerId, SecondaryLayerContent secondaryLayerContent) async {
    return ArcgisMapsFlutterPlatform.instance
        .updateSecondaryLayerVisibility(mapId, layerId, secondaryLayerContent);
  }

  Future<void> setViewpointRotation(double angleDegrees) {
    return ArcgisMapsFlutterPlatform.instance
        .setViewpointRotation(mapId, angleDegrees);
  }

  /// Asynchronously zooms the map, with animation, to the given scale.
  /// The map center point does not change.
  /// The map scale is the number of map units per unit of physical device size.
  /// It expresses the relationship between a distance in the MapView and the corresponding distance on the ground.
  /// A smaller value will zoom the map in and produce a larger map display area (features appear larger).
  /// A larger value will zoom the map out and produce a smaller map display area (features appear smaller).
  Future<bool> setViewpointScale(double scale) async {
    assert(scale >= 0);
    return await ArcgisMapsFlutterPlatform.instance
        .setViewpointScale(mapId, scale);
  }

  Future<Viewpoint?> getCurrentViewpoint(ViewpointType type) {
    return ArcgisMapsFlutterPlatform.instance.getCurrentViewpoint(mapId, type);
  }

  Future<Offset?> locationToScreen(AGSPoint mapPoint) {
    return ArcgisMapsFlutterPlatform.instance.locationToScreen(mapId, mapPoint);
  }

  Future<AGSPoint?> screenToLocation(Offset screenPoint,
      {SpatialReference? spatialReference}) {
    return ArcgisMapsFlutterPlatform.instance.screenToLocation(
      mapId,
      screenPoint,
      spatialReference ?? SpatialReference.wgs84(),
    );
  }

  Future<void> setInitialViewpoint() async {
    return ArcgisMapsFlutterPlatform.instance.setInitialViewpoint(mapId);
  }

  Future<void> recenter() async {
    return ArcgisMapsFlutterPlatform.instance.recenter(mapId);
  }

  Future<num?> sendMeasureDistanceAction(MeasureAction action) async {
    return ArcgisMapsFlutterPlatform.instance
        .sendMeasureDistanceAction(mapId, action);
  }

  Future<num?> sendMeasureAreaAction(MeasureAction action) async {
    return ArcgisMapsFlutterPlatform.instance
        .sendMeasureAreaAction(mapId, action);
  }

  Future<void> invalidatePlatformView() async {
    if (Platform.isAndroid) {
      return await ArcgisMapsFlutterPlatform.instance.invalidatePlatformView(
        mapId
      );
    } else {
      return Future.value();
    }
  }

  /// The current scale of the map. Will return 0 if it cannot be calculated. To change the scale see
  Future<double> getMapScale() =>
      ArcgisMapsFlutterPlatform.instance.getMapScale(mapId);

  /// The current rotation of the map. Will return 0 if it fails.
  Future<double> getMapRotation() =>
      ArcgisMapsFlutterPlatform.instance.getMapRotation(mapId);

  /// Gets the factor of map extent within which the location symbol may move
  /// before causing auto-panning to re-center the map on the current location.
  /// Applies only to [AutoPanMode.recenter] mode.
  /// The default value is 0.5, indicating the location may wander up to
  /// half of the extent before re-centering occurs.
  Future<double> getWanderExtentFactor() =>
      ArcgisMapsFlutterPlatform.instance.getWanderExtentFactor(mapId);

  /// Sets a time offset for this object. The time offset is subtracted from
  /// the time extent set on the owning GeoView. This allows for data from
  /// different periods of time to be compared. Can be null if there is
  /// no time offset.
  Future<void> setLayerTimeOffset(LayerId layerId, TimeValue? timeValue) =>
      ArcgisMapsFlutterPlatform.instance
          .setLayerTimeOffset(mapId, layerId, timeValue);

  /// Return all time aware layers from Operational layers.
  Future<List<TimeAwareLayerInfo>> getTimeAwareLayerInfos() =>
      ArcgisMapsFlutterPlatform.instance.getTimeAwareLayerInfos(mapId);

  Future<void> _setMap(ArcGISMap map) {
    return ArcgisMapsFlutterPlatform.instance.setMap(mapId, map);
  }

  /// Updates configuration options of the map user interface.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  Future<void> _updateMapOptions(Map<String, dynamic> optionsUpdate) {
    return ArcgisMapsFlutterPlatform.instance
        .updateMapOptions(mapId, optionsUpdate);
  }

  Future<void> _updateLayers(LayerUpdates layerUpdates) {
    return ArcgisMapsFlutterPlatform.instance.updateLayers(mapId, layerUpdates);
  }

  Future<void> _updateMarkers(MarkerUpdates markerUpdates) {
    return ArcgisMapsFlutterPlatform.instance
        .updateMarkers(mapId, markerUpdates);
  }

  Future<void> _updatePolygons(PolygonUpdates polygonUpdates) {
    return ArcgisMapsFlutterPlatform.instance
        .updatePolygons(mapId, polygonUpdates);
  }

  Future<void> _updatePolylines(PolylineUpdates polylineUpdates) {
    return ArcgisMapsFlutterPlatform.instance
        .updatePolylines(mapId, polylineUpdates);
  }

  Future<void> _updateIdentifyLayerListeners(Set<LayerId> layers) {
    return ArcgisMapsFlutterPlatform.instance
        .updateIdentifyLayerListeners(mapId, layers);
  }

  /// Disposes of the platform resources
  void dispose() {
    locationDisplay.dispose();
    ArcgisMapsFlutterPlatform.instance.dispose(mapId);
  }

  void _connectStream(int mapId) {
    ArcgisMapsFlutterPlatform.instance
        .onMarkerTap(mapId: mapId)
        .listen((MarkerTapEvent e) => _arcgisMapState.onMarkerTap(e.value));

    ArcgisMapsFlutterPlatform.instance
        .onPolygonTap(mapId: mapId)
        .listen((PolygonTapEvent e) => _arcgisMapState.onPolygonTap(e.value));

    ArcgisMapsFlutterPlatform.instance
        .onPolylineTap(mapId: mapId)
        .listen((PolylineTapEvent e) => _arcgisMapState.onPolylineTap(e.value));

    ArcgisMapsFlutterPlatform.instance
        .onMapLoad(mapId: mapId)
        .listen((MapLoadedEvent e) => _arcgisMapState.onMapLoaded(e.value));

    ArcgisMapsFlutterPlatform.instance
        .onTap(mapId: mapId)
        .listen((MapTapEvent e) => _arcgisMapState.onTap(e.position));

    ArcgisMapsFlutterPlatform.instance.onLongPress(mapId: mapId).listen(
        (MapLongPressEvent e) => _arcgisMapState.onLongPress(e.position));

    ArcgisMapsFlutterPlatform.instance.onLayerLoad(mapId: mapId).listen(
        (LayerLoadedEvent e) =>
            _arcgisMapState.onLayerLoaded(e.value, e.error));

    ArcgisMapsFlutterPlatform.instance
        .onViewpointChanged(mapId: mapId)
        .listen((ViewpointChangedEvent event) {
      for (final listener in _viewpointChangedHandlers.handlers) {
        listener.viewpointChanged();
      }
    });

    ArcgisMapsFlutterPlatform.instance
        .onLayersChanged(mapId: mapId)
        .listen((LayersChangedEvent event) {
      for (final listener in _layersChangedHandlers.handlers) {
        listener.onLayersChanged(
          event.value,
          event.layerChangeType,
        );
      }
    });

    ArcgisMapsFlutterPlatform.instance.onTimeExtentChanged(mapId: mapId).listen(
      (TimeExtentChangedEvent e) {
        for (final listener in _timeExtentChangedHandlers.handlers) {
          listener.timeExtentChanged(e.value);
        }
      },
    );

    ArcgisMapsFlutterPlatform.instance.onIdentifyLayer(mapId: mapId).listen(
        (IdentifyLayerEvent e) =>
            _arcgisMapState.onIdentifyLayer(e.value, e.result));

    ArcgisMapsFlutterPlatform.instance.onIdentifyLayers(mapId: mapId).listen(
        (IdentifyLayersEvent e) => _arcgisMapState.onIdentifyLayers(e.results));

    ArcgisMapsFlutterPlatform.instance.onUserLocationTap(mapId: mapId).listen(
          (UserLocationTapEvent e) => _arcgisMapState.onUserLocationTap(),
        );
  }
}

typedef _RegisterHandlerCallback = void Function(bool register);

class _EventBaseHandler<T> {
  final List<T> _handlers = [];

  bool _isWired = false;

  _EventBaseHandler(this.registerHandlerCallback);

  final _RegisterHandlerCallback registerHandlerCallback;

  List<T> get handlers => List.unmodifiable(_handlers);

  void addHandler(T handler) {
    if (!_handlers.contains(handler)) {
      _handlers.add(handler);
    }
    if (_isWired) {
      return;
    }
    _isWired = true;
    registerHandlerCallback(true);
  }

  void removeHandler(T handler) {
    _handlers.remove(handler);
    if (_isWired && _handlers.isEmpty) {
      _isWired = false;
      registerHandlerCallback(false);
    }
  }
}
