part of arcgis_maps_flutter;

/// Callback method for when the map is ready to be used.
///
/// Pass to [ArcgisMapView.onMapCreated] to receive a [ArcgisMapController] when the
/// map is created.
typedef MapCreatedCallback = void Function(ArcgisMapController controller);

typedef MapLoadedCallback = void Function(ArcgisError? error);

typedef LayerLoadedCallback = void Function(Layer layer, ArcgisError? error);

typedef IdentifyLayerCallback = void Function(IdentifyLayerResult result);

typedef IdentifyLayersCallback = void Function(List<IdentifyLayerResult> results);

/// Callback function taking a single argument.
typedef ArgumentCallback<T> = void Function(T argument);

/// Callback that receives updates to the camera position.
///
/// This callback is triggered when the platform Google Map
/// registers a camera movement.
///
/// This is used in [ArcgisMapView.onCameraMove].
typedef CameraPositionCallback = void Function();

// This counter is used to provide a stable "constant" initialization id
// to the buildView function, so the web implementation can use it as a
// cache key. This needs to be provided from the outside, because web
// views seem to re-render much more often that mobile platform views.
int _nextMapCreationId = 0;

/// Error thrown when an unknown map object ID is provided to a method.
class UnknownMapObjectIdError extends Error {
  /// Creates an assertion error with the provided [message].
  UnknownMapObjectIdError(this.objectType, this.objectId, [this.context]);

  /// The name of the map object whose ID is unknown.
  final String objectType;

  /// The unknown maps object ID.
  final MapsObjectId objectId;

  /// The context where the error occurred.
  final String? context;

  @override
  String toString() {
    if (context != null) {
      return 'Unknown $objectType ID "${objectId.value}" in $context';
    }
    return 'Unknown $objectType ID "${objectId.value}"';
  }
}

class ArcgisMapView extends StatefulWidget {
  ArcgisMapView({
    Key? key,
    required this.map,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.onMapCreated,
    this.onMapLoaded,
    this.onLayerLoaded,
    this.viewpoint,
    this.scalebarConfiguration,
    this.interactionOptions = const InteractionOptions(),
    this.operationalLayers = const <Layer>{},
    this.baseLayers = const <Layer>{},
    this.referenceLayers = const <Layer>{},
    this.markers = const <Marker>{},
    this.polygons = const <Polygon>{},
    this.polylines = const <Polyline>{},
    this.myLocationEnabled = false,
    this.autoPanMode = AutoPanMode.off,
    this.wanderExtentFactor = 0.5,
    this.onAutoPanModeChanged,
    this.onTap,
    this.onCameraMove,
    this.onIdentifyLayer = const {},
    this.onIdentifyLayers,
  })  : assert(onIdentifyLayer.isNotEmpty ? onIdentifyLayers == null : true,
            'You can use only onIdentifyLayer or onIdentifyLayers'),
        assert(onIdentifyLayers != null ? onIdentifyLayer.isEmpty : true,
            'You can use only onIdentifyLayer or onIdentifyLayers'),
        assert(wanderExtentFactor >= 0.0 && wanderExtentFactor <= 1.0,
            'wanderExtendFactor can be between >= 0.0  && <= 1.0'),
        super(key: key);

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [ArcgisMapController] for this [ArcgisMapView].
  final MapCreatedCallback? onMapCreated;

  final ArcGISMap map;

  final Viewpoint? viewpoint;

  final ScalebarConfiguration? scalebarConfiguration;

  /// The map's operational layers.
  /// These layers are displayed in a mapview sandwiched between
  /// a basemap's `baseLayers` at the bottom and
  /// `referenceLayers` at the top. The layers are drawn in a bottom-up fashion
  /// with the 0th layer in the list drawn first, next layer drawn on top of
  /// the previous one, and so on.
  final Set<Layer> operationalLayers;

  /// The base layers of this basemap.
  /// Base layers are displayed at the bottom in a mapview, and
  /// reference layers are displayed at the top,
  /// with the map's operational layers sandwiched between them.
  /// The layers are drawn in a bottom-up fashion with the 0th layer
  /// in the list drawn first, next layer drawn on top of the previous one,
  /// and so on.
  final Set<Layer> baseLayers;

  /// The reference layers of this basemap.
  /// Base layers are displayed at the bottom in a mapview,
  /// and reference layers are displayed at the top, with the
  /// map's operational layers sandwiched between them.
  /// The layers are drawn in a bottom-up fashion with the 0th layer
  /// in the list drawn first, next layer drawn on top of the previous one,
  /// and so on.
  final Set<Layer> referenceLayers;

  /// Markers to be placed on the map.
  final Set<Marker> markers;

  /// Polygons to be placed on the map.
  final Set<Polygon> polygons;

  /// Polylines to be placed on the map.
  final Set<Polyline> polylines;

  final MapLoadedCallback? onMapLoaded;

  final LayerLoadedCallback? onLayerLoaded;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On Android add either
  /// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  /// or `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
  /// to your `AndroidManifest.xml` file. `ACCESS_COARSE_LOCATION` returns a
  /// location with an accuracy approximately equivalent to a city block, while
  /// `ACCESS_FINE_LOCATION` returns as precise a location as possible, although
  /// it consumes more battery power. You will also need to request these
  /// permissions during run-time. If they are not granted, the My Location
  /// feature will fail silently.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  final bool myLocationEnabled;

  /// Defines how to automatically pan the map when new location updates are received.
  /// Default is [AutoPanMode.off]
  final AutoPanMode autoPanMode;

  ///  The factor of map extent within which the location symbol may move
  ///  before causing auto-panning to re-center the map on the current location.
  ///  Applies only to [AutoPanMode.recenter] mode.
  ///  Permitted values are between 1 (indicating the symbol may move within
  ///  the current extent of the MapView without causing re-centering),
  ///  and 0 (indicating that any location movement will re-center the map).
  ///  Lower values within this range will cause the map to re-center more often,
  ///  leading to higher CPU and battery consumption.
  ///  The default value is 0.5, indicating the location may wander up
  ///  to half of the extent before re-centering occurs.
  final double wanderExtentFactor;

  final ArgumentCallback<AutoPanMode>? onAutoPanModeChanged;

  /// Called every time a [ArcgisMapView] is tapped.
  final ArgumentCallback<Point>? onTap;

  /// Called repeatedly as the camera continues to move after an
  /// onCameraMoveStarted call.
  ///
  /// This may be called as often as once every frame and should
  /// not perform expensive operations.
  final CameraPositionCallback? onCameraMove;

  /// Options to configure user interactions with the view.
  final InteractionOptions interactionOptions;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  final Map<LayerId, IdentifyLayerCallback> onIdentifyLayer;

  final IdentifyLayersCallback? onIdentifyLayers;

  @override
  _ArcgisMapViewState createState() => _ArcgisMapViewState();
}

class _ArcgisMapViewState extends State<ArcgisMapView> {
  final _mapId = _nextMapCreationId++;

  final Completer<ArcgisMapController> _controller =
      Completer<ArcgisMapController>();

  late ArcGISMap _map = widget.map;

  Map<LayerId, Layer> _operationalLayers = <LayerId, Layer>{};
  Map<LayerId, Layer> _baseLayers = <LayerId, Layer>{};
  Map<LayerId, Layer> _referenceLayers = <LayerId, Layer>{};
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolygonId, Polygon> _polygons = <PolygonId, Polygon>{};
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  Set<LayerId> _identifyLayerAsync = <LayerId>{};

  late _ArcgisMapOptions _arcgisMapOptions;

  @override
  void initState() {
    super.initState();
    _arcgisMapOptions = _ArcgisMapOptions.fromWidget(widget);
    _operationalLayers = keyByLayerId(widget.operationalLayers);
    _baseLayers = keyByLayerId(widget.baseLayers);
    _referenceLayers = keyByLayerId(widget.referenceLayers);
    _markers = keyByMarkerId(widget.markers);
    _polygons = keyByPolygonId(widget.polygons);
    _polylines = keyByPolylineId(widget.polylines);
    _identifyLayerAsync = widget.onIdentifyLayer.keys.toSet();
  }

  @override
  void dispose() async {
    super.dispose();
    ArcgisMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  void didUpdateWidget(covariant ArcgisMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateMap();
    _updateOptions();
    _updateOperationalLayers();
    _updateBaseLayers();
    _updateReferenceLayers();
    _updateMarkers();
    _updatePolygons();
    _updatePolylines();
    _updateIdentifyLayerListeners();
  }

  @override
  Widget build(BuildContext context) {
    return ArcgisMapsFlutterPlatform.instance.buildView(
      _mapId,
      onPlatformViewCreated,
      map: _map,
      mapOptions: _arcgisMapOptions.toMap(),
      viewpoint: widget.viewpoint,
      operationalLayers: widget.operationalLayers,
      baseLayers: widget.baseLayers,
      referenceLayers: widget.referenceLayers,
      markers: widget.markers,
      polygons: widget.polygons,
      polylines: widget.polylines,
    );
  }

  Future<void> onPlatformViewCreated(int id) async {
    final ArcgisMapController controller =
        await ArcgisMapController.init(id, this);

    _controller.complete(controller);

    final MapCreatedCallback? onMapCreated = widget.onMapCreated;
    if (onMapCreated != null) {
      onMapCreated(controller);
    }
  }

  void onMapLoaded(ArcgisError? error) {
    final completion = widget.onMapLoaded;
    if (completion != null) {
      completion(error);
    }
  }

  void onLayerLoaded(LayerId layerId, ArcgisError? error) {
    Layer? layer;

    final layers = [_operationalLayers, _baseLayers, _referenceLayers];

    for (var i = 0; i < layers.length; i++) {
      layer = layers[i][layerId];
      if (layer != null) break;
    }

    if (layer == null) {
      //throw UnknownMapObjectIdError('layer', layerId, 'onLayerLoaded');
      return;
    }
    final completion = widget.onLayerLoaded;
    if (completion != null) {
      completion(layer, error);
    }
  }

  void onAutoPanModeChanged(AutoPanMode autoPanMode) {
    final callback = widget.onAutoPanModeChanged;
    if (callback == null) return;
    callback(autoPanMode);
  }

  void onMarkerTap(MarkerId markerId) {
    final Marker? marker = _markers[markerId];
    if (marker == null) {
      throw UnknownMapObjectIdError('marker', markerId, 'onTap');
    }
    final VoidCallback? onTap = marker.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onPolygonTap(PolygonId polygonId) {
    final Polygon? polygon = _polygons[polygonId];
    if (polygon == null) {
      throw UnknownMapObjectIdError('polygon', polygonId, 'onTap');
    }
    final VoidCallback? onTap = polygon.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onPolylineTap(PolylineId polylineId) {
    final Polyline? polyline = _polylines[polylineId];
    if (polyline == null) {
      throw UnknownMapObjectIdError('polyline', polylineId, 'onTap');
    }
    final VoidCallback? onTap = polyline.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  void onTap(Point point) {
    final onTap = widget.onTap;
    if (onTap != null) {
      onTap(point);
    }
  }

  void onCameraMove() {
    final onCameraMove = widget.onCameraMove;
    if (onCameraMove != null) {
      onCameraMove();
    }
  }

  void onIdentifyLayer(LayerId layerId, IdentifyLayerResult result) {
    final callback = widget.onIdentifyLayer[layerId];
    if (callback != null) {
      callback(result);
    }
  }

  void onIdentifyLayers(List<IdentifyLayerResult> results) {
    final callback = widget.onIdentifyLayers;
    if (callback != null) {
      callback(results);
    }
  }

  void _updateMap() async {
    if (widget.map == _map) return;
    _map = widget.map;
    final ArcgisMapController controller = await _controller.future;
    controller._setMap(_map);
  }

  void _updateOptions() async {
    final _ArcgisMapOptions newOptions = _ArcgisMapOptions.fromWidget(widget);
    final Map<String, dynamic> updates =
        _arcgisMapOptions.updatesMap(newOptions);
    if (updates.isEmpty) {
      return;
    }
    final ArcgisMapController controller = await _controller.future;
    controller._updateMapOptions(updates);
    _arcgisMapOptions = newOptions;
  }

  void _updateOperationalLayers() async {
    final ArcgisMapController controller = await _controller.future;
    final layersUpdate = LayerUpdates.from(_operationalLayers.values.toSet(),
        widget.operationalLayers, 'operationalLayer');
    if (layersUpdate.isEmpty) return;
    controller._updateLayers(layersUpdate);
    _operationalLayers = keyByLayerId(widget.operationalLayers);
  }

  void _updateBaseLayers() async {
    final ArcgisMapController controller = await _controller.future;
    final layersUpdate = LayerUpdates.from(
        _baseLayers.values.toSet(), widget.baseLayers, 'baseLayer');
    if (layersUpdate.isEmpty) return;
    controller._updateLayers(layersUpdate);
    _baseLayers = keyByLayerId(widget.baseLayers);
  }

  void _updateReferenceLayers() async {
    final ArcgisMapController controller = await _controller.future;
    final layersUpdate = LayerUpdates.from(_referenceLayers.values.toSet(),
        widget.referenceLayers, 'referenceLayer');
    if (layersUpdate.isEmpty) return;
    controller._updateLayers(layersUpdate);
    _referenceLayers = keyByLayerId(widget.referenceLayers);
  }

  void _updateMarkers() async {
    final ArcgisMapController controller = await _controller.future;
    final markerUpdate =
        MarkerUpdates.from(_markers.values.toSet(), widget.markers);
    if (markerUpdate.isEmpty) return;
    controller._updateMarkers(markerUpdate);
    _markers = keyByMarkerId(widget.markers);
  }

  void _updatePolygons() async {
    final ArcgisMapController controller = await _controller.future;
    final polygonUpdates =
        PolygonUpdates.from(_polygons.values.toSet(), widget.polygons);
    if (polygonUpdates.isEmpty) return;
    controller._updatePolygons(polygonUpdates);
    _polygons = keyByPolygonId(widget.polygons);
  }

  void _updatePolylines() async {
    final ArcgisMapController controller = await _controller.future;
    final polylinesUpdate =
        PolylineUpdates.from(_polylines.values.toSet(), widget.polylines);
    if (polylinesUpdate.isEmpty) return;
    controller._updatePolylines(polylinesUpdate);
    _polylines = keyByPolylineId(widget.polylines);
  }

  void _updateIdentifyLayerListeners() async {
    final Set<LayerId> oldLayers = _identifyLayerAsync;
    final Set<LayerId> layers = widget.onIdentifyLayer.keys.toSet();
    if (setEquals(oldLayers, layers)) {
      return;
    }
    final ArcgisMapController controller = await _controller.future;
    controller._updateIdentifyLayerListeners(layers);
    _identifyLayerAsync = layers;
  }
}

class _ArcgisMapOptions {
  _ArcgisMapOptions.fromWidget(ArcgisMapView map)
      : interactionOptions = map.interactionOptions,
        myLocationEnabled = map.myLocationEnabled,
        trackCameraPosition = map.onCameraMove != null,
        trackIdentifyLayers = map.onIdentifyLayers != null,
        autoPanMode = map.autoPanMode,
        wanderExtentFactor = map.wanderExtentFactor,
        scalebarConfiguration = map.scalebarConfiguration;

  final InteractionOptions interactionOptions;
  final bool myLocationEnabled;
  final bool trackCameraPosition;
  final bool trackIdentifyLayers;
  final AutoPanMode autoPanMode;
  final double wanderExtentFactor;
  final ScalebarConfiguration? scalebarConfiguration;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'interactionOptions': interactionOptions.toJson(),
      'myLocationEnabled': myLocationEnabled,
      'trackCameraPosition': trackCameraPosition,
      'trackIdentifyLayers': trackIdentifyLayers,
      'autoPanMode': autoPanMode.index,
      'wanderExtentFactor': wanderExtentFactor,
      'haveScalebar': scalebarConfiguration != null,
      if (scalebarConfiguration != null)
        'scalebarConfiguration': scalebarConfiguration!.toJson(),
    };
  }

  Map<String, dynamic> updatesMap(_ArcgisMapOptions newOptions) {
    final Map<String, dynamic> prevOptionsMap = toMap();

    return newOptions.toMap()
      ..removeWhere((String key, dynamic value) {
        if (key == 'interactionOptions') {
          return interactionOptions == newOptions.interactionOptions;
        }
        return prevOptionsMap[key] == value;
      });
  }
}
