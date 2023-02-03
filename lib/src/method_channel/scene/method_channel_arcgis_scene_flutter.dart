import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/scene/arcgis_scene_flutter_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Error thrown when an unknown map ID is provided to a method channel API.
class UnknownSceneIDError extends Error {
  /// Creates an assertion error with the provided [mapId] and optional
  /// [message].
  UnknownSceneIDError(this.sceneId, [this.message]);

  /// The unknown ID.
  final int sceneId;

  /// Message describing the assertion error.
  final Object? message;

  @override
  String toString() {
    if (message != null) {
      return "Unknown map ID $sceneId: ${Error.safeToString(message)}";
    }
    return "Unknown map ID $sceneId";
  }
}

class MethodChannelArcgisSceneFlutter extends ArcgisSceneFlutterPlatform {
  // Keep a collection of id -> channel
  // Every method call passes the int mapId
  final Map<int, MethodChannel> _channels = {};

  /// Accesses the MethodChannel associated to the passed mapId.
  MethodChannel channel(int sceneId) {
    MethodChannel? channel = _channels[sceneId];
    if (channel == null) {
      throw UnknownSceneIDError(sceneId);
    }
    return channel;
  }

  @override
  Future<void> init(int sceneId) {
    MethodChannel? channel = _channels[sceneId];
    if (channel == null) {
      channel = OptionalMethodChannel('plugins.flutter.io/arcgis_maps_$sceneId');
      channel.setMethodCallHandler(
          (MethodCall call) => _handleMethodCall(call, sceneId));
      _channels[sceneId] = channel;
    }
    return channel.invokeMethod<void>('sceneView#waitForView');
  }

  @override
  Widget buildView(
      int creationId, PlatformViewCreatedCallback onPlatformViewCreated,
      {required ArcGISScene scene,
      required Surface surface,
      required Camera initialCamera}) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'scene': scene.toJson(),
      'surface': surface.toJson(),
      'initialCamera': initialCamera.toJson(),
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: "plugins.flutter.io/arcgis_scene",
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return const Text("Unsupported");
  }

  @override
  Future<void> setScene(int sceneId, ArcGISScene scene) {
    return channel(sceneId).invokeMethod("sceneView#setScene", scene.toJson());
  }

  @override
  Future<void> setSurface(int sceneId, Surface surface) {
    return channel(sceneId).invokeMethod("sceneView#setSurface", surface.toJson());
  }

  @override
  Future<void> setViewpointCamera(int sceneId, Camera camera) {
    return channel(sceneId).invokeMethod("sceneView#setViewpointCamera", camera.toJson());
  }

  Future<dynamic> _handleMethodCall(MethodCall call, int mapId) async {
    switch (call.method) {
      default:
        throw MissingPluginException();
    }
  }
}
