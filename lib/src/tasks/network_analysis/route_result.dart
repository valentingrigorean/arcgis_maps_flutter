part of arcgis_maps_flutter;

@immutable
class RouteResult {
  const RouteResult._({
    required this.directionsLanguage,
    required this.messages,
    required this.routes,
    // TODO(vali): impl AGSPointBarrier/AGSPolygonBarrier/AGSPolylineBarrier
  });

  factory RouteResult.fromJson(Map<String, dynamic> json) {
    return RouteResult._(
      directionsLanguage: json['directionsLanguage'] as String,
      messages: json['messages'] as List<String>,
      routes: Route.fromJsonList(json['routes'] as List<dynamic>),
    );
  }

  /// The language used when computing directions.
  /// For example, en, fr, pt-BR, zh-Hans, etc.
  /// The list of languages supported is available in [RouteTaskInfo.supportedLanguages].
  final String directionsLanguage;

  /// Informational messages that were generated while computing routes.
  final List<String> messages;

  /// Each elements represents an indepdendent route with its own driving directions.
  /// Stops are grouped into diffrent routes based on @c AGSStop#routeName.
  final List<Route> routes;
}
