part of arcgis_maps_flutter;

class OfflineMapItemInfo {
  OfflineMapItemInfo._({
    required this.accessInformation,
    required this.itemDescription,
    required this.snippet,
    required this.tags,
    required this.termsOfUse,
    required this.thumbnail,
    required this.title,
  });

  factory OfflineMapItemInfo.fromJson(Map<dynamic, dynamic> json) {
    return OfflineMapItemInfo._(
      accessInformation: json['accessInformation'] as String,
      itemDescription: json['itemDescription'] as String,
      snippet: json['snippet'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      termsOfUse: json['termsOfUse'] as String,
      thumbnail: json['thumbnail'] as Uint8List?,
      title: json['title'] as String,
    );
  }

  /// The access information about the item.
  final String accessInformation;

  /// The description of the item.
  final String itemDescription;

  /// Snippet or summary of the item with a character limit of 250 characters.
  final String snippet;

  /// Words or short phrases that describe the item.
  final List<String> tags;

  /// The terms of use of the item.
  /// This property can contain HTML formatting.
  final String termsOfUse;

  /// The thumbnail image of the item.
  final Uint8List? thumbnail;

  /// Title of the item.
  final String title;

  @override
  String toString() {
    return 'OfflineMapItemInfo{accessInformation: $accessInformation, itemDescription: $itemDescription, snippet: $snippet, tags: $tags, termsOfUse: $termsOfUse, thumbnail: ${thumbnail != null ? 'true' : 'false'}, title: $title}';
  }
}
