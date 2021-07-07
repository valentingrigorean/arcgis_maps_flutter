import 'dart:async';
import 'package:arcgis_maps_flutter/src/symbology/marker_updates.dart';
import 'package:arcgis_maps_flutter/src/symbology/polygon_updates.dart';
import 'package:arcgis_maps_flutter/src/symbology/polyline_updates.dart';
import 'package:arcgis_maps_flutter/src/utils/json.dart';
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
            creationParamsCodec: StandardMessageCodec(),
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
    return Text('Unsupported');
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
  Future<void> setViewpointChangedListenerEvents(int mapId, bool value) {
    return channel(mapId).invokeMethod<void>(
      "map#setViewpointChangedListenerEvents",
      value,
    );
  }

  @override
  Future<void> clearMarkerSelection(int mapId) {
    return channel(mapId).invokeMethod<void>("map#clearMarkerSelection");
  }

  @override
  Future<void> setViewpoint(int mapId, Viewpoint viewpoint) {
    return channel(mapId)
        .invokeMethod<void>("map#setViewpoint", viewpoint.toJson());
  }

  @override
  Future<Viewpoint?> getCurrentViewpoint(int mapId, ViewpointType type) async {
    final result = await channel(mapId).invokeMapMethod<String, dynamic>(
        "map#getCurrentViewpoint", type.index);
    return Viewpoint.fromJson(result);
  }

  @override
  Future<Offset?> locationToScreen(int mapId, Point mapPoint) async {
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
  Future<Point?> screenToLocation(
      int mapId, Offset screenPoint, SpatialReference spatialReference) async {
    final result = await channel(mapId).invokeMethod('map#screenToLocation', {
      'position': [screenPoint.dx, screenPoint.dy],
      'spatialReference': spatialReference.toJson(),
    });
    return Point.fromJson(toSafeMapNullable(result));
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
  void dispose(int mapId) {
    _channels.remove(mapId);
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
  Stream<CameraMoveEvent> onCameraMove({required int mapId}) {
    return _events(mapId).whereType<CameraMoveEvent>();
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
  Stream<ViewpointChangedListenerEvent> onViewpointChangedListener(
      {required int mapId}) {
    return _events(mapId).whereType<ViewpointChangedListenerEvent>();
  }

  // Returns a filtered view of the events in the _controller, by mapId.
  Stream<MapEvent> _events(int mapId) =>
      _mapEventStreamController.stream.where((event) => event.mapId == mapId);

  Future<dynamic> _handleMethodCall(MethodCall call, int mapId) async {
    switch (call.method) {
      case 'map#viewpointChanged':
        _mapEventStreamController.add(
          ViewpointChangedListenerEvent(
            mapId,
          ),
        );
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
      case 'camera#onMove':
        _mapEventStreamController.add(
          CameraMoveEvent(
            mapId,
          ),
        );
        break;
      case 'map#onTap':
        final args = call.arguments['position'];
        Point point = Point.fromJson(toSafeMapNullable(args))!;
        _mapEventStreamController.add(
          MapTapEvent(
            mapId,
            point,
          ),
        );
        break;
      case 'map#onIdentifyLayers':
        final List<dynamic> args = call.arguments;
        final List<IdentifyLayerResult> results = [];
        for (var item in args) {
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
        _mapEventStreamController.add(IdentifyLayersEvent(mapId, results));
        break;
      default:
        throw MissingPluginException();
    }
  }
}
