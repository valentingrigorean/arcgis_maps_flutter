part of arcgis_maps_flutter;

@immutable
class TimeAwareLayerInfo {
  const TimeAwareLayerInfo({
    this.layerId,
    this.fullTimeExtent,
    this.supportsTimeFiltering = false,
    this.isTimeFilteringEnabled = false,
    this.timeOffset,
    this.timeInterval,
  });

  final LayerId? layerId;

  /// The full time extent of the layer
  final TimeExtent? fullTimeExtent;

  /// Indicates whether the layer supports filtering its contents by a time range
  final bool supportsTimeFiltering;

  /// Indicates whether the layer must use the time extent defined
  /// on the owning view and filter its content.
  /// Only applicable if the layer supports time filtering [supportsTimeFiltering]
  final bool isTimeFilteringEnabled;

  /// A time offset for this layer. This is useful when data from different
  /// layers belong to different time periods and must be displayed together.
  /// The offset it applied on-the-fly, it does not change the actual data
  /// of the layer. The time offset is subtracted from the time extent
  /// set on the owning view before the extent is used to filter content from the layer.
  final TimeValue? timeOffset;

  /// Returns the suggested time slider step size for this time aware layer.
  /// Can be null if no time interval is suggested for this time aware object.
  final TimeValue? timeInterval;

  factory TimeAwareLayerInfo.fromJson(Map<dynamic, dynamic> json) {
    final layerId = json['layerId'];
    final fullTimeExtent = json['fullTimeExtent'];
    final timeOffset = json['timeOffset'];
    final timeInterval = json['timeInterval'];
    return TimeAwareLayerInfo(
      layerId: layerId == null ? null : LayerId(layerId),
      fullTimeExtent:
          fullTimeExtent == null ? null : TimeExtent.fromJson(fullTimeExtent),
      supportsTimeFiltering: json['supportsTimeFiltering'],
      isTimeFilteringEnabled: json['isTimeFilteringEnabled'],
      timeOffset: timeOffset == null ? null : TimeValue.fromJson(timeOffset),
      timeInterval:
          timeInterval == null ? null : TimeValue.fromJson(timeInterval),
    );
  }

  @override
  String toString() {
    return 'TimeAwareLayerInfo{layerId: $layerId, fullTimeExtent: $fullTimeExtent, supportsTimeFiltering: $supportsTimeFiltering, isTimeFilteringEnabled: $isTimeFilteringEnabled, timeOffset: $timeOffset, timeInterval: $timeInterval}';
  }
}
