part of arcgis_maps_flutter;

class ArcgisMapController {
  final _ArcgisMapViewState _arcgisMapState;
  final List<ViewpointChangedListener> _viewpointChangedListeners = [];

  bool _viewPointChangedWired = false;

  final int mapId;

  ArcgisMapController._(this._arcgisMapState, this.mapId) {
    _connectStream(mapId);
  }

  static Future<ArcgisMapController> init(
      int id, _ArcgisMapViewState arcgisMapState) async {
    await ArcgisMapsFlutterPlatform.instance.init(id);
    return ArcgisMapController._(arcgisMapState, id);
  }

  void addViewpointChangedListener(ViewpointChangedListener listener) {
    if (!_viewpointChangedListeners.contains(listener)) {
      _viewpointChangedListeners.add(listener);
    }
    if (_viewPointChangedWired) return;
    _viewPointChangedWired = true;
    ArcgisMapsFlutterPlatform.instance
        .setViewpointChangedListenerEvents(mapId, true);
  }

  void removeViewpointChangedListener(ViewpointChangedListener listener) {
    _viewpointChangedListeners.remove(listener);
    if (_viewPointChangedWired && _viewpointChangedListeners.isEmpty) {
      _viewPointChangedWired = false;
      ArcgisMapsFlutterPlatform.instance
          .setViewpointChangedListenerEvents(mapId, false);
    }
  }

  Future<void> clearMarkerSelection() {
    return ArcgisMapsFlutterPlatform.instance.clearMarkerSelection(mapId);
  }

  Future<void> setViewpoint(Viewpoint viewpoint) {
    return ArcgisMapsFlutterPlatform.instance.setViewpoint(mapId, viewpoint);
  }

  Future<void> setViewpointRotation(double angleDegrees) {
    return ArcgisMapsFlutterPlatform.instance
        .setViewpointRotation(mapId, angleDegrees);
  }

  Future<Viewpoint?> getCurrentViewpoint(ViewpointType type) {
    return ArcgisMapsFlutterPlatform.instance.getCurrentViewpoint(mapId, type);
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
    ///ArcgisMapsFlutterPlatform.instance.dispose(mapId);
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

    ArcgisMapsFlutterPlatform.instance.onLayerLoad(mapId: mapId).listen(
        (LayerLoadedEvent e) =>
            _arcgisMapState.onLayerLoaded(e.value, e.error));

    ArcgisMapsFlutterPlatform.instance
        .onCameraMove(mapId: mapId)
        .listen((CameraMoveEvent e) => _arcgisMapState.onCameraMove());

    ArcgisMapsFlutterPlatform.instance
        .onViewpointChangedListener(mapId: mapId)
        .listen((ViewpointChangedListenerEvent event) {
      for (final listener in _viewpointChangedListeners) {
        listener.viewpointChanged();
      }
    });

    ArcgisMapsFlutterPlatform.instance
        .onAutoPanModeChanged(mapId: mapId)
        .listen((AutoPanModeChangedEvent e) =>
            _arcgisMapState.onAutoPanModeChanged(e.value));

    ArcgisMapsFlutterPlatform.instance.onIdentifyLayer(mapId: mapId).listen(
        (IdentifyLayerEvent e) =>
            _arcgisMapState.onIdentifyLayer(e.value, e.result));

    ArcgisMapsFlutterPlatform.instance.onIdentifyLayers(mapId: mapId).listen(
        (IdentifyLayersEvent e) => _arcgisMapState.onIdentifyLayers(e.results));
  }
}
