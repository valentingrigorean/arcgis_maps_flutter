import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/scene/method_channel_arcgis_scene_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class ArcgisSceneFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static ArcgisSceneFlutterPlatform _instance =
      MethodChannelArcgisSceneFlutter();

  ArcgisSceneFlutterPlatform() : super(token: _token);

  static ArcgisSceneFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(ArcgisSceneFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the platform interface with [id].
  ///
  /// This method is called when the plugin is first initialized.
  Future<void> init(int sceneId) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Widget buildView(
      int creationId, PlatformViewCreatedCallback onPlatformViewCreated,
      {required ArcGISScene scene,
      required Surface surface,
      required Camera initialCamera}) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  Future<void> setScene(int sceneId, ArcGISScene scene) {
    throw UnimplementedError('setScene() has not been implemented.');
  }

  Future<void> setSurface(int sceneId, Surface surface) {
    throw UnimplementedError('setScene() has not been implemented.');
  }

  Future<void> setViewpointCamera(int sceneId, Camera camera) {
    throw UnimplementedError('setViewpointCamera() has not been implemented.');
  }
}
