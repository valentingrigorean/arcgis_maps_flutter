part of arcgis_maps_flutter;

class GeodatabaseDeltaInfo {
  GeodatabaseDeltaInfo._({
    required this.downloadDeltaFileUrl,
    required this.featureServiceUrl,
    required this.geodatabaseFileUrl,
    required this.uploadDeltaFileUrl,
  });

  factory GeodatabaseDeltaInfo._fromJson(Map<dynamic, dynamic> json) {
    return GeodatabaseDeltaInfo._(
      downloadDeltaFileUrl: json['downloadDeltaFileUrl'] as String?,
      featureServiceUrl: json['featureServiceUrl'] as String,
      geodatabaseFileUrl: json['geodatabaseFileUrl'] as String,
      uploadDeltaFileUrl: json['uploadDeltaFileUrl'] as String?,
    );
  }

  final String? downloadDeltaFileUrl;
  final String featureServiceUrl;
  final String geodatabaseFileUrl;
  final String? uploadDeltaFileUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GeodatabaseDeltaInfo &&
              runtimeType == other.runtimeType &&
              downloadDeltaFileUrl == other.downloadDeltaFileUrl &&
              featureServiceUrl == other.featureServiceUrl &&
              geodatabaseFileUrl == other.geodatabaseFileUrl &&
              uploadDeltaFileUrl == other.uploadDeltaFileUrl;

  @override
  int get hashCode =>
      downloadDeltaFileUrl.hashCode ^
      featureServiceUrl.hashCode ^
      geodatabaseFileUrl.hashCode ^
      uploadDeltaFileUrl.hashCode;

  @override
  String toString() {
    return 'GeodatabaseDeltaInfo{downloadDeltaFileUrl: $downloadDeltaFileUrl, featureServiceUrl: $featureServiceUrl, geodatabaseFileUrl: $geodatabaseFileUrl, uploadDeltaFileUrl: $uploadDeltaFileUrl}';
  }
}