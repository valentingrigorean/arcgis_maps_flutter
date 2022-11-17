import 'dart:async';
import 'package:arcgis_maps_flutter/src/symbology/marker_updates.dart';
import 'package:arcgis_maps_flutter/src/symbology/polygon_updates.dart';
import 'package:arcgis_maps_flutter/src/symbology/polyline_updates.dart';
import 'package:arcgis_maps_flutter/src/utils/markers.dart';
import 'package:arcgis_maps_flutter/src/utils/polygons.dart';
import 'package:arcgis_maps_flutter/src/utils/polyline.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart' as rendering;
import 'package:stream_transform/stream_transform.dart';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/layers/layer_updates.dart';
import 'package:arcgis_maps_flutter/src/method_channel/map/arcgis_maps_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/map/map_event.dart';
import 'package:arcgis_maps_flutter/src/utils/layers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Error thrown when an unknown map ID is provided to a method channel API.
class UnknownMapIDError extends Error {
  /// Creates an assertion error with the provided [mapId] and optional
  /// [message].
  UnknownMapIDError(this.mapId, [this.message]);

  /// The unknown ID.
  final int mapId;

  /// Message describing the assertion error.
  final Object? message;

  @override
  String toString() {
    if (message != null) {
      return "Unknown map ID $mapId: ${Error.safeToString(message)}";
    }
    return "Unknown map ID $mapId";
  }
}

class MethodChannelArcgisMapsFlutter extends ArcgisMapsFlutterPlatform {
  // Keep a collection of id -> channel
  // Every method call passes the int mapId
  final _channels = <int, MethodChannel>{};

  // The controller we need to broadcast the different events coming
  // from handleMethodCall.
  //
  // It is a `broadcast` because multiple controllers will connect to
  // different stream views of this Controller.
  final StreamController<MapEvent> _mapEventStreamController =
      StreamController<MapEvent>.broadcast();

  /// Accesses the MethodChannel associated to the passed mapId.
  MethodChannel channel(int mapId) {
    MethodChannel? channel = _channels[mapId];
    if (channel == null) {
      throw UnknownMapIDError(mapId);
    }
    return channel;
  }

  @override
  Future<void> init(int mapId) {
    MethodChannel? channel = _channels[mapId];
    if (channel == null) {
      channel = MethodChannel('plugins.flutter.io/arcgis_maps_$mapId');
      channel.setMethodCallHandler(
          (MethodCall call) => _handleMethodCall(call, mapId));
      _channels[mapId] = channel;
    }
    return channel.invokeMethod<void>('map#waitForMap');
  }

  @override
  Widget buildView(
    int creationId,
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required ArcGISMap map,
    Viewpoint? viewpoint,
    Set<Layer> operationalLayers = const <Layer>{},
    Set<Layer> baseLayers = const <Layer>{},
    Set<Layer> referenceLayers = const <Layer>{},
    Set<Marker> markers = const <Marker>{},
    Set<Polygon> polygons = const <Polygon>{},
    Set<Polyline> polylines = const <Polyline>{},
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    Map<String, dynamic> mapOptions = const <String, dynamic>{},
  }) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'map': map.toJson(),
      'options': mapOptions,
      'operationalLayersToAdd': serializeLayerSet(operationalLayers),
      'baseLayersToAdd': serializeLayerSet(baseLayers),
      'referenceLayersToAdd': serializeLayerSet(referenceLayers),
      'markersToAdd': serializeMarkerSet(markers),
      'polygonsToAdd': serializePolygonSet(polygons),
      'polylinesToAdd': serializePolylineSet(polylines),
    };

    if (viewpoint != null) {
      creationParams['viewpoint'] = viewpoint.toJson();
    }

    const viewType = 'plugins.flutter.io/arcgis_maps';

    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: gestureRecognizers ??
                const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: rendering.PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener((id) {
              params.onPlatformViewCreated(id);
              onPlatformViewCreated(id);
            })
            ..create();
        },
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        gestureRecognizers: gestureRecognizers,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return const Text('Unsupported');
  }

  @override
  Future<Uint8List?> exportImage(int mapId) {
    return channel(mapId).invokeMethod<Uint8List>('map#exportImage');
  }

  @override
  Future<Location?> getLocation(int mapId) async {
    final result = await channel(mapId).invokeMapMethod('map#getLocation');
    if (result == null) {
      return null;
    }
    return Location.fromJson(result);
  }

  @override
  Future<AGSPoint?> getMapLocation(int mapId) async {
    final result = await channel(mapId).invokeMapMethod('map#getMapLocation');
    if (result == null) {
      return null;
    }
    return AGSPoint.fromJson(result);
  }

  @override
  Future<List<LegendInfoResult>> getLegendInfos(int mapId, Layer layer) async {
    final results = await channel(mapId).invokeListMethod(
      "map#getLegendInfos",
      layer.toJson(),
    );

    if (results == null || results.isEmpty) {
      return const [];
    }
    return results.map((e) => LegendInfoResult.fromJson(e)!).toList();
  }

  @override
  Future<AGSEnvelope?> getMapMaxExtend(int mapId) async {
    final result = await channel(mapId).invokeMapMethod('map#getMapMaxExtend');
    if (result == null) {
      return null;
    }
    return AGSEnvelope.fromJson(result);
  }

  @override
  Future<void> setMapMaxExtent(int mapId, AGSEnvelope envelope) {
    return channel(mapId).invokeMethod<void>(
      'map#setMapMaxExtent',
      envelope.toJson(),
    );
  }

  @override
  Future<void> setMap(int mapId, ArcGISMap map) {
    return channel(mapId).invokeMethod<void>("map#setMap", map.toJson());
  }

  @override
  Future<void> updateMapOptions(int mapId, Map<String, dynamic> optionsUpdate) {
    return channel(mapId).invokeMethod<void>(
      "map#update",
      <String, dynamic>{
        'options': optionsUpdate,
      },
    );
  }

  @override
  Future<double> getMapRotation(int mapId) async {
    final result =
        await channel(mapId).invokeMethod<double>('map#getMapRotation');
    return result ?? 0;
  }

  @override
  Future<double> getWanderExtentFactor(int mapId) async {
    final result =
        await channel(mapId).invokeMethod<double>('map#getWanderExtentFactor');
    return result ?? 0;
  }

  @override
  Future<List<TimeAwareLayerInfo>> getTimeAwareLayerInfos(int mapId) async {
    final result =
        await channel(mapId).invokeListMethod('map#getTimeAwareLayerInfos');
    return result
            ?.map<TimeAwareLayerInfo>((e) => TimeAwareLayerInfo.fromJson(e))
            .toList() ??
        const [];
  }

  @override
  Future<void> setViewpointChangedListenerEvents(int mapId, bool value) {
    return channel(mapId).invokeMethod<void>(
      'map#setViewpointChangedListenerEvents',
      value,
    );
  }

  @override
  Future<void> setLayersChangedListener(int mapId, bool value) {
    return channel(mapId).invokeMethod<void>(
      'map#setLayersChangedListener',
      value,
    );
  }

  @override
  Future<TimeExtent?> getTimeExtent(int mapId) async {
    final result = await channel(mapId)
        .invokeMapMethod<String, dynamic>("map#getTimeExtent");
    return result == null ? null : TimeExtent.fromJson(result);
  }

  @override
  Future<void> setTimeExtent(int mapId, TimeExtent? timeExtent) {
    return channel(mapId)
        .invokeMethod<void>('map#setTimeExtent', timeExtent?.toJson());
  }

  @override
  Future<void> clearMarkerSelection(int mapId) {
    return channel(mapId).invokeMethod<void>("map#clearMarkerSelection");
  }

  @override
  Future<Viewpoint?> getCurrentViewpoint(int mapId, ViewpointType type) async {
    final result = await channel(mapId).invokeMapMethod<String, dynamic>(
        "map#getCurrentViewpoint", type.index);
    if (result == null) {
      return null;
    }
    return Viewpoint.fromJson(result);
  }

  @override
  Future<void> setViewpoint(int mapId, Viewpoint viewpoint) {
    return channel(mapId)
        .invokeMethod<void>("map#setViewpoint", viewpoint.toJson());
  }

  @override
  Future<bool> setViewpointGeometry(
      int mapId, Geometry geometry, double? padding) async {
    final result = await channel(mapId).invokeMethod<bool>(
      'map#setViewpointGeometry',
      {
        'geometry': geometry.toJson(),
        if (padding != null) 'padding': padding,
      },
    );
    return result ?? false;
  }

  @override
  Future<bool> setViewpointCenter(
      int mapId, AGSPoint center, double scale) async {
    final result = await channel(mapId).invokeMethod<bool>(
      'map#setViewpointCenter',
      {
        'center': center.toJson(),
        'scale': scale,
      },
    );
    return result ?? false;
  }

  @override
  Future<void> setViewpointRotation(int mapId, double angleDegrees) {
    return channel(mapId)
        .invokeMethod<void>("map#setViewpointRotation", angleDegrees);
  }

  @override
  Future<bool> setViewpointScale(int mapId, double scale) async {
    final result = await channel(mapId).invokeMethod<bool>(
      'map#setViewpointScaleAsync',
      {
        'scale': scale,
      },
    );
    return result ?? false;
  }

  @override
  Future<Offset?> locationToScreen(int mapId, AGSPoint mapPoint) async {
    final result = await channel(mapId)
        .invokeListMethod<double>('map#locationToScreen', mapPoint.toJson());
    if (result == null) {
      return null;
    }
    return Offset(result[0], result[1]);
  }

  @override
  Future<double> getMapScale(int mapId) async {
    final result = await channel(mapId).invokeMethod<double>('map#getMapScale');
    return result ?? 0;
  }

  @override
  Future<AGSPoint?> screenToLocation(
      int mapId, Offset screenPoint, SpatialReference spatialReference) async {
    final result = await channel(mapId).invokeMethod('map#screenToLocation', {
      'position': [screenPoint.dx, screenPoint.dy],
      'spatialReference': spatialReference.toJson(),
    });
    return AGSPoint.fromJson(result);
  }

  @override
  Future<void> updateLayers(int mapId, LayerUpdates layerUpdates) {
    return channel(mapId)
        .invokeMethod<void>('layers#update', layerUpdates.toJson());
  }

  @override
  Future<void> updateMarkers(int mapId, MarkerUpdates markerUpdates) {
    return channel(mapId)
        .invokeMethod<void>('markers#update', markerUpdates.toJson());
  }

  @override
  Future<void> updatePolygons(int mapId, PolygonUpdates polygonUpdates) {
    return channel(mapId)
        .invokeMethod<void>('polygons#update', polygonUpdates.toJson());
  }

  @override
  Future<void> updatePolylines(int mapId, PolylineUpdates polylineUpdates) {
    return channel(mapId)
        .invokeMethod<void>('polylines#update', polylineUpdates.toJson());
  }

  @override
  Future<void> setLayerTimeOffset(
      int mapId, LayerId layerId, TimeValue? timeValue) async {
    return channel(mapId).invokeMethod<void>(
      'layer#setTimeOffset',
      {
        'layerId': layerId.value,
        'timeValue': timeValue?.toJson(),
      },
    );
  }

  @override
  void dispose(int mapId) {
    // Noop!
  }

  @override
  Stream<MapLoadedEvent> onMapLoad({required int mapId}) {
    return _events(mapId).whereType<MapLoadedEvent>();
  }

  @override
  Stream<LayerLoadedEvent> onLayerLoad({required int mapId}) {
    return _events(mapId).whereType<LayerLoadedEvent>();
  }

  @override
  Stream<MarkerTapEvent> onMarkerTap({required int mapId}) {
    return _events(mapId).whereType<MarkerTapEvent>();
  }

  @override
  Stream<PolygonTapEvent> onPolygonTap({required int mapId}) {
    return _events(mapId).whereType<PolygonTapEvent>();
  }

  @override
  Stream<PolylineTapEvent> onPolylineTap({required int mapId}) {
    return _events(mapId).whereType<PolylineTapEvent>();
  }

  @override
  Stream<MapTapEvent> onTap({required int mapId}) {
    return _events(mapId).whereType<MapTapEvent>();
  }

  @override
  Stream<MapLongPressEvent> onLongPress({required int mapId}) {
    return _events(mapId).whereType<MapLongPressEvent>();
  }

  @override
  Stream<UserLocationTapEvent> onUserLocationTap({required int mapId}) {
    return _events(mapId).whereType<UserLocationTapEvent>();
  }

  @override
  Stream<IdentifyLayerEvent> onIdentifyLayer({required int mapId}) {
    return _events(mapId).whereType<IdentifyLayerEvent>();
  }

  @override
  Stream<IdentifyLayersEvent> onIdentifyLayers({required int mapId}) {
    return _events(mapId).whereType<IdentifyLayersEvent>();
  }

  @override
  Stream<ViewpointChangedEvent> onViewpointChanged({required int mapId}) {
    return _events(mapId).whereType<ViewpointChangedEvent>();
  }

  @override
  Stream<LayersChangedEvent> onLayersChanged({required int mapId}) {
    return _events(mapId).whereType<LayersChangedEvent>();
  }

  @override
  Stream<TimeExtentChangedEvent> onTimeExtentChanged({required int mapId}) {
    return _events(mapId).whereType<TimeExtentChangedEvent>();
  }

  // Returns a filtered view of the events in the _controller, by mapId.
  Stream<MapEvent> _events(int mapId) =>
      _mapEventStreamController.stream.where((event) => event.mapId == mapId);

  Future<dynamic> _handleMethodCall(MethodCall call, int mapId) async {
    switch (call.method) {
      case 'map#viewpointChanged':
        _mapEventStreamController.add(
          ViewpointChangedEvent(
            mapId,
          ),
        );
        break;
      case 'map#onLayersChanged':
        final LayersChangedEvent event = LayersChangedEvent(
          mapId,
          LayerType.values[call.arguments['layerType']!],
          LayerChangeType.values[call.arguments['layerChangeType']!],
        );
        _mapEventStreamController.add(event);
        break;
      case 'marker#onTap':
        _mapEventStreamController.add(
          MarkerTapEvent(
            mapId,
            MarkerId(call.arguments['markerId']),
          ),
        );
        break;
      case 'polygon#onTap':
        _mapEventStreamController.add(
          PolygonTapEvent(
            mapId,
            PolygonId(call.arguments['polygonId']),
          ),
        );
        break;
      case 'polyline#onTap':
        _mapEventStreamController.add(
          PolylineTapEvent(
            mapId,
            PolylineId(call.arguments['polylineId']),
          ),
        );
        break;
      case 'map#loaded':
        _mapEventStreamController.add(
          MapLoadedEvent(
            mapId,
            ArcgisError.fromJson(call.arguments),
          ),
        );
        break;
      case 'layer#loaded':
        _mapEventStreamController.add(
          LayerLoadedEvent(
            mapId,
            ArcgisError.fromJson(call.arguments['error']),
            LayerId(call.arguments['layerId']),
          ),
        );
        break;
      case 'map#onTap':
        final args = call.arguments;
        final screenPoint = _fromJson(args['screenPoint']);
        AGSPoint position = AGSPoint.fromJson(args['position'])!;
        _mapEventStreamController.add(
          MapTapEvent(
            mapId,
            screenPoint: screenPoint,
            position: position,
          ),
        );
        break;
      case 'map#onLongPress':
        final args = call.arguments;
        final screenPoint = _fromJson(args['screenPoint']);
        AGSPoint position = AGSPoint.fromJson(args['position'])!;
        _mapEventStreamController.add(
          MapLongPressEvent(
            mapId,
            screenPoint: screenPoint,
            position: position,
          ),
        );
        break;
      case 'map#onIdentifyLayers':
        final Map<dynamic, dynamic> args = call.arguments;
        final screenPoint = _fromJson(args['screenPoint']);
        final position = AGSPoint.fromJson(args['position'])!;
        final List<IdentifyLayerResult> results = [];
        for (var item in args['results']) {
          final String layerName = item['layerName']!;
          final List<dynamic> elementsData = item['elements']!;
          final List<GeoElement> elements = [];
          for (var elementData in elementsData) {
            elements.add(GeoElement.fromJson(elementData));
          }
          results.add(IdentifyLayerResult(
            layerName: layerName,
            elements: elements,
          ));
        }
        _mapEventStreamController.add(
          IdentifyLayersEvent(
            mapId,
            screenPoint: screenPoint,
            position: position,
            results: results,
          ),
        );
        break;
      case 'map#timeExtentChanged':
        _mapEventStreamController.add(
          TimeExtentChangedEvent(
            mapId,
            call.arguments == null ? null : TimeExtent.fromJson(call.arguments),
          ),
        );
        break;
      case 'map#onUserLocationTap':
        _mapEventStreamController.add(
          UserLocationTapEvent(
            mapId,
          ),
        );
        break;
      default:
        throw MissingPluginException();
    }
  }
}

Offset _fromJson(dynamic json) {
  final List<dynamic> data = json;
  return Offset(data[0]!.toDouble(), data[1]!.toDouble());
}
