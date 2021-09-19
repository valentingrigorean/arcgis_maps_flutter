part of arcgis_maps_flutter;

@immutable
class PortalItem extends Equatable {
  const PortalItem({
    required this.portal,
    required this.itemId,
  });

  final Portal portal;
  final String itemId;

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['portal'] = portal.toJson();
    json['itemId'] = itemId;
    return json;
  }

  @override
  List<Object?> get props => [portal, itemId];
}
