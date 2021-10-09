part of arcgis_maps_flutter;

abstract class TimeSliderDataProvider {
  final List<VoidCallback> _fullTimeExtentChange = <VoidCallback>[];
  Timer? _autoUpdateTimer;

  TimeSliderDataProvider({
    required this.mapController,
    this.autoUpdateInterval,
  }) {
    if (autoUpdateInterval != null) {
      _autoUpdateTimer = Timer.periodic(autoUpdateInterval!, (timer) {
        notifyFullTimeExtentListeners();
      });
    }
  }

  final ArcgisMapController mapController;

  final Duration? autoUpdateInterval;

  @mustCallSuper
  void dispose() {
    _autoUpdateTimer?.cancel();
    _autoUpdateTimer = null;
    _fullTimeExtentChange.clear();
  }

  void addFullTimeExtentChangeListener(VoidCallback callback) {
    _fullTimeExtentChange.add(callback);
  }

  void removeFullTimeExtentChangeListener(VoidCallback callback) {
    _fullTimeExtentChange.remove(callback);
  }

  Future<TimeExtent?> getFullTimeExtent();

  void onCurrentTimeExtentChanged(TimeExtent? timeExtent) {}

  @protected
  void notifyFullTimeExtentListeners() {
    for (final callback in _fullTimeExtentChange) {
      callback();
    }
  }
}

class TimeSliderMapControllerDataProvider extends TimeSliderDataProvider
    implements LayersChangedListener {
  TimeSliderMapControllerDataProvider({
    required ArcgisMapController mapController,
    this.observeLayerChanges = true,
    Duration? autoUpdateInterval,
  }) : super(
          mapController: mapController,
          autoUpdateInterval: autoUpdateInterval,
        ) {
    if (observeLayerChanges) {
      mapController.addLayersChangedListener(this);
    }
  }

  final bool observeLayerChanges;

  @override
  void dispose() {
    super.dispose();
    if (observeLayerChanges) {
      mapController.removeLayersChangedListener(this);
    }
  }

  @override
  void onLayersChanged(LayerType onLayer, LayerChangeType layerChange) {
    if (onLayer == LayerType.operational) {
      notifyFullTimeExtentListeners();
    }
  }

  @override
  Future<TimeExtent?> getFullTimeExtent() async {
    final timeAwareLayers = await mapController.getTimeAwareLayerInfos();
    final validTimeAwareLayers = timeAwareLayers
        .where((e) => e.fullTimeExtent != null && e.isTimeFilteringEnabled)
        .map((e) => e.fullTimeExtent!)
        .toList();

    if (validTimeAwareLayers.isEmpty) {
      return null;
    }

    var fullTimeExtent = validTimeAwareLayers.first;

    for (final timeExtent in validTimeAwareLayers.skip(1)) {
      fullTimeExtent = fullTimeExtent.union(timeExtent);
    }

    return fullTimeExtent;
  }
}

class TimeSliderWmsServiceDataProvider extends TimeSliderDataProvider {
  final WmsService _wmsService = const WmsService();
  final Set<WmsLayer> _layers = <WmsLayer>{};
  final Map<LayerId, _LayerDimensionInfo> _layersData = {};

  final Map<String, WmsServiceInfo> _cacheWmsServiceInfo =
      <String, WmsServiceInfo>{};

  DateTime? _lastUpdate;

  TimeSliderWmsServiceDataProvider({
    required ArcgisMapController mapController,
    this.setLayerTimeOffset = true,
    this.cacheDuration,
    Set<WmsLayer>? layers,
    Duration? autoUpdateInterval,
  }) : super(
          mapController: mapController,
          autoUpdateInterval: autoUpdateInterval,
        ) {
    if (layers != null) {
      _layers.addAll(layers);
    }
  }

  final bool setLayerTimeOffset;

  final Duration? cacheDuration;

  void addLayer(WmsLayer layer) {
    if (!_layers.contains(layer)) {
      _layers.add(layer);
    }
  }

  void removeLayer(WmsLayer layer) {
    _layers.remove(layer);
  }

  @override
  Future<TimeExtent?> getFullTimeExtent() async {
    if (_layers.isEmpty) {
      return null;
    }

    if (_checkIfUpdateIsNeeded()) {
      await Future.wait(_layers.map((e) => _fetchWmsLayerCompabilities(e)));
      _lastUpdate = DateTime.now();
    }

    if (_layersData.isEmpty) {
      return null;
    }

    TimeExtent? fullTimeExtent;

    for (final pair in _layersData.entries) {
      if (fullTimeExtent == null) {
        fullTimeExtent = pair.value.fullTimeExtent;
      } else {
        if (pair.value.fullTimeExtent != null) {
          fullTimeExtent = fullTimeExtent.union(pair.value.fullTimeExtent!);
        }
      }
    }
    return fullTimeExtent;
  }

  @override
  void onCurrentTimeExtentChanged(TimeExtent? timeExtent) {
    for (final pair in _layersData.entries) {
      if (timeExtent == null) {
        mapController.setLayerTimeOffset(pair.key, null);
      } else {
        mapController.setLayerTimeOffset(
            pair.key, pair.value.getClosedTimeValue(timeExtent));
      }
    }
  }

  bool _checkIfUpdateIsNeeded() {
    final lastUpdate = _lastUpdate;
    if (lastUpdate == null) {
      return true;
    }
    if (cacheDuration == null) {
      return false;
    }
    return lastUpdate.add(cacheDuration!).millisecondsSinceEpoch >
        DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> _fetchWmsLayerCompabilities(WmsLayer layer) async {
    _layersData.remove(layer.layerId);
    final url = layer.url;
    if (url == null) {
      return;
    }
    if (!_cacheWmsServiceInfo.containsKey(url)) {
      try {
        final serviceInfo = await _wmsService.getServiceInfo(url);
        if (serviceInfo != null) {
          _cacheWmsServiceInfo[url] = serviceInfo;
        }
      } catch (_) {}
    }

    if (!_cacheWmsServiceInfo.containsKey(url)) {
      return;
    }

    final serviceInfo = _cacheWmsServiceInfo[url]!;

    if (layer.layersName.isEmpty || layer.layersName.length > 1) {
      return;
    }

    final subLayerName = layer.layersName.first;
    final subLayerInfo = serviceInfo.getLayerInfoByName(subLayerName);
    if (subLayerInfo == null) {
      return;
    }
    for (final dimension in subLayerInfo.dimensions) {
      final timeDimension = dimension.timeDimension;
      if (timeDimension != null) {
        _layersData[layer.layerId] = _LayerDimensionInfo(
          timeDimension: timeDimension,
        );
        break;
      }
    }
  }
}

class _LayerDimensionInfo {
  _LayerDimensionInfo({
    required this.timeDimension,
  }) {
    if (timeDimension.dates.isNotEmpty) {
      fullTimeExtent = timeDimension.dates.first.timeExtent;
      for (final date in timeDimension.dates.skip(1)) {
        fullTimeExtent = fullTimeExtent!.union(date.timeExtent);
      }
    }
  }

  TimeExtent? fullTimeExtent;

  final WmsLayerTimeDimension timeDimension;

  TimeValue? getClosedTimeValue(TimeExtent currentTimeExtent) {
    if (!currentTimeExtent.only1Time) {
      return null;
    }

    final currentStart = currentTimeExtent.startTime!;

    for (int i = 0; i < timeDimension.dates.length; i++) {
      final dateInfo = timeDimension.dates[i];
      if (dateInfo.timeExtent == currentTimeExtent) {
        return null;
      }

      if (!dateInfo.timeExtent.only1Time) {
        continue;
      }

      final startDate = dateInfo.timeExtent.startTime!;

      if (currentStart.isBefore(startDate)) {
        if (i == 0) {
          return null;
        }
        var prev = timeDimension.dates[i - 1];
        return _calculateOffset(
          currentStart,
          prev.timeExtent.only1Time ? prev.timeExtent.startTime! : null,
          startDate,
        );
      }
    }

    return null;
  }

  TimeValue? _calculateOffset(
      DateTime current, DateTime? prevDate, DateTime nextDate) {
    var diff = current.difference(nextDate);
    if (prevDate == null) {
      return TimeValue(
        duration: diff.inSeconds.toDouble(),
        unit: TimeUnit.seconds,
      );
    }
    var prevDiff = current.difference(prevDate);
    if (prevDiff.abs() > diff.abs()) {
      return diff.inMilliseconds == 0
          ? null
          : TimeValue(
              duration: diff.inMilliseconds.toDouble(),
              unit: TimeUnit.milliseconds,
            );
    }
    return prevDiff.inMilliseconds == 0
        ? null
        : TimeValue(
            duration: prevDiff.inMilliseconds.toDouble(),
            unit: TimeUnit.milliseconds,
          );
  }
}
