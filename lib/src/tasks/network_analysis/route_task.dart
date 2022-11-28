part of arcgis_maps_flutter;

class RouteTask extends ArcgisNativeObject
    with Loadable, RemoteResource, ApiKeyResource {
  final String _url;

  RouteTask({
    required String url,
    Credential? credential,
  }) : _url = url {
    if (credential != null) {
      setCredential(credential);
    }
  }

  @override
  String get type => 'RouteTask';

  @override
  dynamic getCreateArguments() => _url;

  Future<RouteTaskInfo> getRouteTaskInfo() async {
    final result = await invokeMethod('routeTask#getRouteTaskInfo');
    return RouteTaskInfo.fromJson(result);
  }

  Future<RouteParameters> createDefaultParameters() async {
    final result = await invokeMethod('routeTask#createDefaultParameters');
    return RouteParameters.fromJson(result);
  }

  Future<RouteResult> solveRoute(RouteParameters parameters) async {
    final result = await invokeMethod(
      'routeTask#solveRoute',
      arguments: parameters.toJson(),
    );
    return RouteResult.fromJson(result);
  }
}
