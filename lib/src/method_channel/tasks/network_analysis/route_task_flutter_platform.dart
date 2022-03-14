import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/network_analysis/method_channel_route_task_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class RouteTaskFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static RouteTaskFlutterPlatform _instance =  MethodChannelRouteTaskFlutter();

  RouteTaskFlutterPlatform() : super(token: _token);

  static RouteTaskFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(RouteTaskFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> createRouteTask(int id,String url,Credential? credential){
    throw UnimplementedError('createRouteTask() has not been implemented.');
  }

  Future<void> destroyRouteTask(int id){
    throw UnimplementedError('destroyRouteTask() has not been implemented.');
  }

  Future<RouteTaskInfo> getRouteTaskInfo(int id){
    throw UnimplementedError('getRouteTaskInfo() has not been implemented.');
  }

  Future<RouteParameters> createDefaultParameters(int id)  {
    throw UnimplementedError('createDefaultParameters() has not been implemented.');
  }

  Future<RouteResult> solveRoute(int id,RouteParameters parameters) async {
    throw UnimplementedError('solve() has not been implemented.');
  }
}
