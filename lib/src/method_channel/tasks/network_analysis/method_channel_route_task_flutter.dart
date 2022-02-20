import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/network_analysis/route_task_flutter_platform.dart';
import 'package:flutter/services.dart';

class MethodChannelRouteTaskFlutter extends RouteTaskFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel("plugins.flutter.io/route_task");

  @override
  Future<void> createRouteTask(int id, String url, Credential? credential) {
    return _channel.invokeMethod<void>(
      "createRouteTask",
      {
        "id": id,
        "url": url,
        "credential": credential?.toJson(),
      },
    );
  }

  @override
  Future<void> destroyRouteTask(int id) {
    return _channel.invokeMethod<void>(
      "destroyRouteTask",
      id,
    );
  }

  @override
  Future<RouteTaskInfo> getRouteTaskInfo(int id) async {
    return _channel.invokeMapMethod<String, dynamic>(
      "getRouteTaskInfo",
      id,
    ).then((value) => RouteTaskInfo.fromJson(value!));
  }

  @override
  Future<RouteParameters> createDefaultParameters(int id) {
    return _channel.invokeMapMethod<String, dynamic>(
      "createDefaultParameters",
      id,
    ).then((value) => RouteParameters.fromJson(value!));
  }

  @override
  Future<RouteResult> solveRoute(int id, RouteParameters parameters) async {
    return _channel.invokeMapMethod<String, dynamic>(
      "solveRoute",
      {
        "id": id,
        "parameters": parameters.toJson(),
      },
    ).then((value) => RouteResult.fromJson(value!));
  }
}
