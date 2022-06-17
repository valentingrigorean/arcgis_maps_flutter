part of arcgis_maps_flutter;

/// Callback method for when the map is ready to be used.
///
/// Pass to [ArcgisMapView.onMapCreated] to receive a [ArcgisMapController] when the
/// map is created.
typedef MapCreatedCallback = void Function(ArcgisMapController controller);

typedef MapErrorCallback = void Function(Object? error, StackTrace? stackTrace);

typedef MapLoadedCallback = void Function(ArcgisError? error);

typedef LayerLoadedCallback = void Function(Layer layer, ArcgisError? error);

typedef IdentifyLayerCallback = void Function(IdentifyLayerResult result);

typedef IdentifyLayersCallback = void Function(
    List<IdentifyLayerResult> results);

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
    this.failedToStartMyLocation,
    this.insetsContentInsetFromSafeArea = true,
    this.isAttributionTextVisible = true,
    this.contentInsets = EdgeInsets.zero,
    this.onTap,
    this.onLongPress,
    this.onIdentifyLayer = const {},
    this.onIdentifyLayers,
    this.onUserLocationTap,
  })  : assert(onIdentifyLayer.isNotEmpty ? onIdentifyLayers == null : true,
            'You can use only onIdentifyLayer or onIdentifyLayers'),
        assert(onIdentifyLayers != null ? onIdentifyLayer.isEmpty : true,
            'You can use only onIdentifyLayer or onIdentifyLayers'),
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

  final MapErrorCallback? failedToStartMyLocation;

  /// Indicates whether the content inset is relative to the safe area.
  /// When [true], the content inset is interpreted as a value relative to the safe area.
  /// When [false], the content inset is interpreted as a value from the edge of bounds.
  /// Defaults to [true].
  final bool insetsContentInsetFromSafeArea;

  /// Defines the edges where the [ArcgisMapView]is obscured by some other UI.
  /// This is important so that callouts display correctly, the location
  /// display is anchored appropriately, and setting a new viewpoint adjusts
  /// the map contents to correctly display in the unobscured part of the view.
  /// Setting this will affect the @c visibleArea that is reported by the [ArcgisMapView].
  final EdgeInsets contentInsets;

  /// Specifies whether the attribution text banner (along the bottom edge of the view) should be visible.
  /// Defaults to [true].
  final bool isAttributionTextVisible;

  /// Called every time a [ArcgisMapView] is tapped.
  final ArgumentCallback<AGSPoint>? onTap;

  final ArgumentCallback<AGSPoint>? onLongPress;

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

  final VoidCallback? onUserLocationTap;

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
      viewpoint: widget.viewpoint,
      operationalLayers: widget.operationalLayers,
      baseLayers: widget.baseLayers,
      referenceLayers: widget.referenceLayers,
      markers: widget.markers,
      polygons: widget.polygons,
      polylines: widget.polylines,
      gestureRecognizers: widget.gestureRecognizers,
      mapOptions: _arcgisMapOptions.toMap(),
    );
  }

  Future<void> onPlatformViewCreated(int id) async {
    final ArcgisMapController controller =
        await ArcgisMapController.init(id, this);

    if (!mounted) {
      return;
    }

    _controller.complete(controller);

    if (widget.myLocationEnabled) {
      try {
        await controller.locationDisplay.start();
      } catch (ex, stackTrace) {
        widget.failedToStartMyLocation?.call(ex, stackTrace);
      }
    }

    if (!mounted) {
      return;
    }

    final MapCreatedCallback? onMapCreated = widget.onMapCreated;
    if (onMapCreated != null) {
      onMapCreated(controller);
    }
  }

  void onUserLocationTap() {
    final callback = widget.onUserLocationTap;
    if (callback != null) {
      callback();
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

  void onTap(AGSPoint point) {
    final onTap = widget.onTap;
    if (onTap != null) {
      onTap(point);
    }
  }

  void onLongPress(AGSPoint position) {
    final onLongPress = widget.onLongPress;
    if (onLongPress != null) {
      onLongPress(position);
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
    if (updates.containsKey('myLocationEnabled')) {
      final ArcgisMapController controller = await _controller.future;
      final bool isStarted = await controller.locationDisplay.started;
      if (mounted) {
        try {
          if (updates['myLocationEnabled'] && !isStarted) {
            await controller.locationDisplay.start();
          } else if (isStarted) {
            await controller.locationDisplay.stop();
          }
        } catch (ex, stackTrace) {
          widget.failedToStartMyLocation?.call(ex, stackTrace);
        }
      }
    }
    final ArcgisMapController controller = await _controller.future;
    if (!mounted) {
      return;
    }
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
        trackIdentifyLayers = map.onIdentifyLayers != null,
        trackUserLocationTap = map.onUserLocationTap != null,
        insetsContentInsetFromSafeArea = map.insetsContentInsetFromSafeArea,
        isAttributionTextVisible = map.isAttributionTextVisible,
        contentInsets = map.contentInsets,
        scalebarConfiguration = map.scalebarConfiguration;

  final InteractionOptions interactionOptions;
  final bool myLocationEnabled;
  final bool trackIdentifyLayers;
  final bool trackUserLocationTap;
  final bool insetsContentInsetFromSafeArea;
  final bool isAttributionTextVisible;
  final EdgeInsets contentInsets;
  final ScalebarConfiguration? scalebarConfiguration;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'interactionOptions': interactionOptions.toJson(),
      'myLocationEnabled': myLocationEnabled,
      'trackIdentifyLayers': trackIdentifyLayers,
      'trackUserLocationTap': myLocationEnabled,
      'haveScalebar': scalebarConfiguration != null,
      'insetsContentInsetFromSafeArea': insetsContentInsetFromSafeArea,
      'isAttributionTextVisible': isAttributionTextVisible,
      'contentInsets': [
        contentInsets.left,
        contentInsets.top,
        contentInsets.right,
        contentInsets.bottom,
      ],
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
        if (key == 'contentInsets') {
          return contentInsets == newOptions.contentInsets;
        }
        return prevOptionsMap[key] == value;
      });
  }
}
