part of arcgis_maps_flutter;

// ignore_for_file: library_private_types_in_public_api
class ArcgisMapController {
  final _ArcgisMapViewState _arcgisMapState;
  late final _EventBaseHandler<ViewpointChangedListener>
      _viewpointChangedHandlers = _EventBaseHandler((register) {
    ArcgisMapsFlutterPlatform.instance
        .setViewpointChangedListenerEvents(mapId, register);
  });
  late final _EventBaseHandler<TimeExtentChangedListener>
      _timeExtentChangedHandlers = _EventBaseHandler((register) {
    ArcgisMapsFlutterPlatform.instance
        .setTimeExtentChangedListener(mapId, register);
  });

  bool _isDisposed = false;

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

  bool get isDisposed => _isDisposed;

  Future<LegendInfoResult?> getLegendInfosForLayer(Layer layer) async {
    return await ArcgisMapsFlutterPlatform.instance
        .getLegendInfos(mapId, layer);
  }

  Future<Uint8List?> exportImage() {
    return ArcgisMapsFlutterPlatform.instance.exportImage(mapId);
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

  Future<List<Feature>> queryFeatureTableFromLayer({
    required String layerName,
    Geometry? geometry,
    SpatialRelationship? spatialRelationship,
    int? maxResults,
    Map<String, dynamic>? queryValues,
  }) async {
    return ArcgisMapsFlutterPlatform.instance.queryFeatureTableFromLayer(
        mapId: mapId,
        layerName: layerName,
        queryValues: queryValues,
        geometry: geometry,
        spatialRelationship: spatialRelationship,
        maxResults: maxResults);
  }

  Future<List<LegendInfoResult>> getLegendInfosForLayers(
      Set<Layer> layers) async {
    var futures = <Future<LegendInfoResult?>>[];
    for (final layer in layers) {
      futures.add(getLegendInfosForLayer(layer));
    }
    final result = await Future.wait(futures);
    return result
        .where((element) => element != null)
        .cast<LegendInfoResult>()
        .toList();
  }

  Future<Envelope?> getMapMaxExtend() {
    return ArcgisMapsFlutterPlatform.instance.getMapMaxExtend(mapId);
  }

  Future<void> setMapMaxExtent(Envelope envelope) {
    return ArcgisMapsFlutterPlatform.instance.setMapMaxExtent(mapId, envelope);
  }

  void addViewpointChangedListener(ViewpointChangedListener listener) {
    if (_isDisposed) return;
    _viewpointChangedHandlers.addHandler(listener);
  }

  void removeViewpointChangedListener(ViewpointChangedListener listener) {
    if (_isDisposed) return;
    _viewpointChangedHandlers.removeHandler(listener);
  }

  void addTimeExtentChangedListener(TimeExtentChangedListener listener) {
    if (_isDisposed) return;
    _timeExtentChangedHandlers.addHandler(listener);
  }

  void removeTimeExtentChangedListener(TimeExtentChangedListener listener) {
    if (_isDisposed) return;
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

  Future<bool> setViewpointCenter(Point center, {double? scale}) async {
    scale ??= await getMapScale();
    return ArcgisMapsFlutterPlatform.instance
        .setViewpointCenter(mapId, center, scale);
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

  /// Gets the current viewpoint being displayed.
  /// For an [ArcgisMapView], this takes into account the attribution bar and
  /// any [ArcgisMapView.contentInsets] that has been specified to return only the unobscured
  /// portion of the map. Param [type] specifying how the viewpoint
  /// should be represented.
  Future<Viewpoint?> getCurrentViewpoint(ViewpointType type) {
    return ArcgisMapsFlutterPlatform.instance.getCurrentViewpoint(mapId, type);
  }

  Future<Viewpoint?> getInitialViewpoint() {
    return ArcgisMapsFlutterPlatform.instance.getInitialViewpoint(mapId);
  }

  Future<Offset?> locationToScreen(Point mapPoint) {
    return ArcgisMapsFlutterPlatform.instance.locationToScreen(mapId, mapPoint);
  }

  Future<Point?> screenToLocation(Offset screenPoint,
      {SpatialReference? spatialReference}) {
    return ArcgisMapsFlutterPlatform.instance.screenToLocation(
      mapId,
      screenPoint,
      spatialReference ?? SpatialReference.wgs84(),
    );
  }

  /// The current scale of the map. Will return 0 if it cannot be calculated. To change the scale see
  Future<double> getMapScale() =>
      ArcgisMapsFlutterPlatform.instance.getMapScale(mapId);

  /// The current rotation of the map. Will return 0 if it fails.
  Future<double> getMapRotation() =>
      ArcgisMapsFlutterPlatform.instance.getMapRotation(mapId);

  Future<SpatialReference?> getMapSpatialReference() =>
      ArcgisMapsFlutterPlatform.instance.getMapSpatialReference(mapId);

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
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    _viewpointChangedHandlers.clearAll();
    _timeExtentChangedHandlers.clearAll();
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

    ArcgisMapsFlutterPlatform.instance.onTap(mapId: mapId).listen(
        (MapTapEvent e) => _arcgisMapState.onTap(e.screenPoint, e.position));

    ArcgisMapsFlutterPlatform.instance.onLongPress(mapId: mapId).listen(
        (MapLongPressEvent e) =>
            _arcgisMapState.onLongPress(e.screenPoint, e.position));

    ArcgisMapsFlutterPlatform.instance.onLongPressEnd(mapId: mapId).listen(
        (MapLongPressEndEvent e) =>
            _arcgisMapState.onLongPressEnd(e.screenPoint, e.position));

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

    ArcgisMapsFlutterPlatform.instance.onTimeExtentChanged(mapId: mapId).listen(
      (TimeExtentChangedEvent e) {
        for (final listener in _timeExtentChangedHandlers.handlers) {
          listener.timeExtentChanged(e.value);
        }
      },
    );

    ArcgisMapsFlutterPlatform.instance.onIdentifyLayer(mapId: mapId).listen(
          (IdentifyLayerEvent e) => _arcgisMapState.onIdentifyLayer(
            e.value,
            e.screenPoint,
            e.position,
            e.result,
          ),
        );

    ArcgisMapsFlutterPlatform.instance.onIdentifyGraphics(mapId: mapId).listen(
          (IdentifyGraphicsEvent e) => _arcgisMapState.onIdentityGraphics(
            e.screenPoint,
            e.position,
            e.value,
          ),
        );

    ArcgisMapsFlutterPlatform.instance.onIdentifyLayers(mapId: mapId).listen(
          (IdentifyLayersEvent e) => _arcgisMapState.onIdentifyLayers(
            e.screenPoint,
            e.position,
            e.results,
          ),
        );

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

  void clearAll() {
    _handlers.clear();
    if (_isWired) {
      _isWired = false;
    }
  }
}
