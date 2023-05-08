part of arcgis_maps_flutter;

enum PortalConnection {
  anonymous(0),
  authenticated(1),
  ;

  const PortalConnection(this.value);

  factory PortalConnection.fromValue(int value) {
    return PortalConnection.values.firstWhere(
      (e) => e.value == value,
    );
  }

  final int value;
}

@immutable
class Portal extends Equatable {
  const Portal({
    required this.url,
    this.connection = PortalConnection.anonymous,
  });

  factory Portal.arcGISOnline({
    required PortalConnection connection,
  }) =>
      Portal(
        url: 'https://www.arcgis.com',
        connection: connection,
      );

  final String url;

  final PortalConnection connection;

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['url'] = url;
    json['connection'] = connection.value;
    return json;
  }

  @override
  List<Object?> get props => [url, connection];
}
