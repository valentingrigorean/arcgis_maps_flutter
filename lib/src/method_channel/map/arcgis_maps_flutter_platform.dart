import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/layers/layer_updates.dart';
import 'package:arcgis_maps_flutter/src/method_channel/map/map_event.dart';
import 'package:arcgis_maps_flutter/src/method_channel/map/method_channel_arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/symbology/marker_updates.dart';
import 'package:arcgis_maps_flutter/src/symbology/polygon_updates.dart';
import 'package:arcgis_maps_flutter/src/symbology/polyline_updates.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class ArcgisMapsFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static ArcgisMapsFlutterPlatform _instance = MethodChannelArcgisMapsFlutter();

  ArcgisMapsFlutterPlatform() : super(token: _token);

  static ArcgisMapsFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(ArcgisMapsFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the platform interface with [id].
  ///
  /// This method is called when the plugin is first initialized.
  Future<void> init(int mapId) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Widget buildView(
    int creationId,
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required ArcGISMap map,
    Viewpoint? viewpoint,
    Set<Layer> operationalLayers = const <Layer>{},
    Set<Layer> baseLayers = const <Layer>{},
    Set<Layer> referenceLayers = const <Layer>{},
    Set<Marker> markers = const <Marker>{},
    Set<PolygonMarker> polygons = const <PolygonMarker>{},
    Set<PolylineMarker> polylines = const <PolylineMarker>{},
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    Map<String, dynamic> mapOptions = const <String, dynamic>{},
  }) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  Future<Uint8List?> exportImage(int mapId) {
    throw UnimplementedError('exportImage() has not been implemented.');
  }

  Future<Location?> getLocation(int mapId) {
    throw UnimplementedError('getLocation() has not been implemented.');
  }

  Future<Point?> getMapLocation(int mapId) {
    throw UnimplementedError('getMapLocation() has not been implemented.');
  }

  Future<LegendInfoResult?> getLegendInfos(int mapId, Layer layer) {
    throw UnimplementedError(
        'setMgetLegendInfosap() has not been implemented.');
  }

  Future<Envelope?> getMapMaxExtend(int mapId) {
    throw UnimplementedError('getMapMaxExtend() has not been implemented.');
  }

  Future<void> setMapMaxExtent(int mapId, Envelope envelope) {
    throw UnimplementedError('setMapMaxExtent() has not been implemented.');
  }

  Future<void> setMap(int mapId, ArcGISMap map) {
    throw UnimplementedError('setMap() has not been implemented.');
  }

  Future<void> updateMapOptions(int mapId, Map<String, dynamic> optionsUpdate) {
    throw UnimplementedError('updateMapOptions() has not been implemented.');
  }

  Future<double> getMapRotation(int mapId) {
    throw UnimplementedError('getMapRotation() has not been implemented.');
  }

  Future<double> getWanderExtentFactor(int mapId) {
    throw UnimplementedError(
        'getWanderExtentFactor() has not been implemented.');
  }

  Future<List<Feature>> queryFeatureTableFromLayer(
      {
        required int mapId,
        required String layerName,
        Geometry? geometry,
        SpatialRelationship? spatialRelationship,
        int? maxResults,
        Map<String, dynamic>? queryValues
      }
      ) {
    throw UnimplementedError(
        'selectFeatureById() has not been implemented.');
  }

  Future<List<TimeAwareLayerInfo>> getTimeAwareLayerInfos(int mapId) {
    throw UnimplementedError(
        'getTimeAwareLayerInfos() has not been implemented.');
  }

  Future<void> setViewpointChangedListenerEvents(int mapId, bool value) {
    throw UnimplementedError(
        'setViewpointChangedListenerEvents() has not been implemented.');
  }

  Future<void> setLayersChangedListener(int mapId, bool value) {
    throw UnimplementedError(
        'setOperationLayersChangedListener() has not been implemented.');
  }

  Future<void> setTimeExtentChangedListener(int mapId, bool register) {
    throw UnimplementedError(
        'setOperationLayersChangedListener() has not been implemented.');
  }

  Future<TimeExtent?> getTimeExtent(int mapId) {
    throw UnimplementedError('getTimeExtent() has not been implemented.');
  }

  Future<void> setTimeExtent(int mapId, TimeExtent? timeExtent) {
    throw UnimplementedError('setTimeExtent() has not been implemented.');
  }

  Future<void> clearMarkerSelection(int mapId) {
    throw UnimplementedError(
        'clearMarkerSelection() has not been implemented.');
  }

  Future<void> setViewpoint(int mapId, Viewpoint viewpoint) {
    throw UnimplementedError('setViewpoint() has not been implemented.');
  }

  Future<bool> setViewpointGeometry(int mapId, Geometry geometry,double? padding) {
    throw UnimplementedError('setViewpointGeometry() has not been implemented.');
  }

  Future<bool> setViewpointCenter(int mapId, Point center, double scale) {
    throw UnimplementedError('setViewpointCenter() has not been implemented.');
  }

  Future<Viewpoint?> getCurrentViewpoint(int mapId, ViewpointType type) {
    throw UnimplementedError('getCurrentViewpoint() has not been implemented.');
  }

  Future<Viewpoint?> getInitialViewpoint(int mapId) {
    throw UnimplementedError('getInitialViewpoint() has not been implemented.');
  }

  Future<void> setViewpointRotation(int mapId, double angleDegrees) {
    throw UnimplementedError(
        'onViewpointChangedListener() has not been implemented.');
  }

  Future<bool> setViewpointScale(int mapId, double scale) {
    throw UnimplementedError(
        'setViewpointScale() has not been implemented.');
  }

  Future<Offset?> locationToScreen(int mapId, Point mapPoint) {
    throw UnimplementedError('locationToScreen() has not been implemented.');
  }

  Future<Point?> screenToLocation(
      int mapId, Offset screenPoint, SpatialReference spatialReference) {
    throw UnimplementedError('screenToLocation() has not been implemented.');
  }

  Future<double> getMapScale(int mapId) {
    throw UnimplementedError('getMapScale() has not been implemented.');
  }

  Future<void> updateLayers(int mapId, LayerUpdates layerUpdates) {
    throw UnimplementedError('updateLayers() has not been implemented.');
  }

  Future<void> updateMarkers(int mapId, MarkerUpdates markerUpdates) {
    throw UnimplementedError('updateMarkers() has not been implemented.');
  }

  Future<void> updatePolygons(int mapId, PolygonUpdates polygonUpdates) {
    throw UnimplementedError('updatePolygons() has not been implemented.');
  }

  Future<void> updatePolylines(int mapId, PolylineUpdates polylineUpdates) {
    throw UnimplementedError('updatePolylines() has not been implemented.');
  }

  Future<void> updateIdentifyLayerListeners(int mapId, Set<LayerId> layers) {
    throw UnimplementedError(
        'updateIdentifyLayerListeners() has not been implemented.');
  }

  /// Sets a time offset for this object. The time offset is subtracted from
  /// the time extent set on the owning GeoView. This allows for data from
  /// different periods of time to be compared. Can be null if there is
  /// no time offset.
  Future<void> setLayerTimeOffset(
      int mapId, LayerId layerId, TimeValue? timeValue) {
    throw UnimplementedError('setLayerTimeOffset() has not been implemented.');
  }

  Stream<MapLoadedEvent> onMapLoad({required int mapId}) {
    throw UnimplementedError('onMapLoad() has not been implemented.');
  }

  Stream<LayerLoadedEvent> onLayerLoad({required int mapId}) {
    throw UnimplementedError('onMapLoad() has not been implemented.');
  }

  /// A [Marker] has been tapped.
  Stream<MarkerTapEvent> onMarkerTap({required int mapId}) {
    throw UnimplementedError('onMarkerTap() has not been implemented.');
  }

  /// A [PolygonMarker] has been tapped.
  Stream<PolygonTapEvent> onPolygonTap({required int mapId}) {
    throw UnimplementedError('onPolygonTap() has not been implemented.');
  }

  /// A [PolylineMarker] has been tapped.
  Stream<PolylineTapEvent> onPolylineTap({required int mapId}) {
    throw UnimplementedError('onPolylineTap() has not been implemented.');
  }

  /// A Map has been tapped at a certain [LatLng].
  Stream<MapTapEvent> onTap({required int mapId}) {
    throw UnimplementedError('onTap() has not been implemented.');
  }

  /// A Map has been long tapped at a certain [LatLng].
  Stream<MapLongPressEvent> onLongPress({required int mapId}) {
    throw UnimplementedError('onLongPress() has not been implemented.');
  }

  /// A Map has been long tapped at a certain [LatLng] and the long tap has ended.
  Stream<MapLongPressEndEvent> onLongPressEnd({required int mapId}) {
    throw UnimplementedError('onLongPressEnd() has not been implemented.');
  }

  Stream<UserLocationTapEvent> onUserLocationTap({required int mapId}) {
    throw UnimplementedError('onUserLocationTap() has not been implemented.');
  }

  Stream<IdentifyLayerEvent> onIdentifyLayer({required int mapId}) {
    throw UnimplementedError('onIdentifyLayer() has not been implemented.');
  }

  Stream<IdentifyLayersEvent> onIdentifyLayers({required int mapId}) {
    throw UnimplementedError('onIdentifyLayers() has not been implemented.');
  }

  Stream<ViewpointChangedEvent> onViewpointChanged({required int mapId}) {
    throw UnimplementedError(
        'onViewpointChangedListener() has not been implemented.');
  }

  Stream<LayersChangedEvent> onLayersChanged({required int mapId}) {
    throw UnimplementedError('onLayersChanged() has not been implemented.');
  }

  Stream<TimeExtentChangedEvent> onTimeExtentChanged({required int mapId}) {
    throw UnimplementedError('onTimeExtentChanged() has not been implemented.');
  }

  void dispose(int mapId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }

}
