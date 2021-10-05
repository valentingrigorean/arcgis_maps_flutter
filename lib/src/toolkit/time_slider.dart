part of arcgis_maps_flutter;

class _LayerDimensionInfo {
  _LayerDimensionInfo({
    this.timeExtent,
    this.timeDimension,
  });

  final TimeExtent? timeExtent;

  final WmsLayerTimeDimension? timeDimension;

  TimeValue? getClosedTimeValue(TimeExtent currentTimeExtent) {
    final timeDimension = this.timeDimension;
    if (timeDimension == null) {
      return null;
    }

    if (!currentTimeExtent.only1Time) {
      return null;
    }

    final currentStart = currentTimeExtent.startTime!;

    for (int i = 0; i < timeDimension.dates.length; i++) {
      final dateInfo = timeDimension.dates[i];
      if (dateInfo.timeExtent == currentTimeExtent) {
        return null;
      }
      if (dateInfo.interval != null && timeExtent != null) {
        // impl
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
      return diff.inSeconds == 0
          ? null
          : TimeValue(
              duration: diff.inSeconds.toDouble(),
              unit: TimeUnit.seconds,
            );
    }
    return prevDiff.inSeconds == 0
        ? null
        : TimeValue(
            duration: prevDiff.inSeconds.toDouble(),
            unit: TimeUnit.seconds,
          );
    ;
  }
}

class TimeSliderController extends ChangeNotifier
    implements TimeExtentChangedListener, LayersChangedListener {
  final WmsService _wmsService = const WmsService();
  final Set<WmsLayer> _wmsLayers = {};
  final Map<LayerId, _LayerDimensionInfo> _layersData = {};

  final List<DateTime> _timeSteps = [];

  final Duration _playbackInterval;

  final bool _autoSetTimeOffset;

  ArcgisMapController? _mapController;

  TimeValue _timeStepInterval;
  TimeExtent? _currentExtent;
  TimeExtent? _fullExtent;
  DateTime? _minDate;
  DateTime? _maxDate;

  bool _isDisposed = false;

  bool _isPlaying = false;

  int _currentStep = 0;

  Timer? _playbackTimer;

  Timer? _autoUpdateLayersTimer;

  TimeSliderController({
    TimeValue timeStepInterval = const TimeValue(
      duration: 5,
      unit: TimeUnit.minutes,
    ),
    this.autoLoop = false,
    this.autoDispose = true,
    DateTime? minDate,
    DateTime? maxDate,
    Duration playbackInterval = const Duration(seconds: 1),
    bool autoSetTimeOffset = false,
  })  : _timeStepInterval = timeStepInterval,
        _minDate = minDate,
        _maxDate = maxDate,
        _playbackInterval = playbackInterval,
        _autoSetTimeOffset = autoSetTimeOffset;

  @override
  void dispose() {
    _mapController?.removeTimeExtentChangedListener(this);
    _mapController?.removeLayersChangedListener(this);
    _playbackTimer?.cancel();
    _playbackTimer = null;

    _autoUpdateLayersTimer?.cancel();
    _autoUpdateLayersTimer = null;
    _isDisposed = true;
    super.dispose();
  }

  final bool autoLoop;

  final bool autoDispose;

  bool get isPlaying => _isPlaying;

  set isPlaying(bool value) {
    if (value == _isPlaying) {
      return;
    }
    _playbackTimer?.cancel();
    _playbackTimer = null;
    _isPlaying = value;

    if (value) {
      _playbackTimer = Timer.periodic(_playbackInterval, (_) {
        var nextValue = currentStep + 1;
        if (autoLoop && nextValue >= totalSteps - 1) {
          currentStep = 0;
        } else if (nextValue <= totalSteps - 1) {
          currentStep = nextValue;
        } else {
          isPlaying = false;
        }

        if ((totalSteps - 1) == nextValue && !autoLoop) {
          isPlaying = false;
        }
      });
    }

    notifyListeners();
  }

  List<DateTime> get timeSteps => List.unmodifiable(_timeSteps);

  int get totalSteps => _timeSteps.length;

  int get currentStep => _currentStep;

  bool get canMoveBack => _isDisposed ? false : currentStep > 0;

  bool get canMoveForward => _isDisposed ? false : currentStep + 1 < totalSteps;

  set currentStep(int value) {
    if (_isDisposed) {
      return;
    }
    if (value == _currentStep) {
      return;
    }
    _currentStep = value;
    if (_moveTimeStep(value)) {
      _updateCurrentExtent(currentExtent);
      notifyListeners();
    }
  }

  TimeExtent? get currentExtent => _currentExtent;

  TimeExtent? get fullExtent => _fullExtent;

  set fullExtent(TimeExtent? value) {
    if (_isDisposed) {
      return;
    }
    if (_fullExtent == value) {
      return;
    }
    _fullExtent = value;
    _invalidateTimeSteps();
  }

  TimeValue get timeStepInterval => _timeStepInterval;

  set timeStepInterval(TimeValue value) {
    if (_isDisposed) {
      return;
    }
    if (_timeStepInterval == value) {
      return;
    }
    _timeStepInterval = value;
    _invalidateTimeSteps();
  }

  DateTime? get minDate => _minDate;

  set minDate(DateTime? value) {
    if (_isDisposed) {
      return;
    }
    if (_minDate == value) {
      return;
    }
    _minDate = minDate;
    _invalidateTimeSteps();
  }

  DateTime? get maxDate => _maxDate;

  set maxDate(DateTime? value) {
    if (_isDisposed) {
      return;
    }
    if (_maxDate == value) {
      return;
    }
    _maxDate = value;
    _invalidateTimeSteps();
  }

  @override
  void timeExtentChanged(TimeExtent? timeExtent) {
    if (timeExtent == currentExtent) {
      return;
    }
    _currentExtent = timeExtent;
    if (_isDisposed) {
      return;
    }
    _updateAllLayersOffset();
    notifyListeners();
  }

  @override
  void onLayersChanged(LayerType onLayer, LayerChangeType layerChange) async {
    if (_isDisposed) {
      return;
    }
    if (onLayer == LayerType.operational) {
      await _updateData();
    }
  }

  void setMapController(
    ArcgisMapController? mapController, {
    bool observeLayerChanges = true,
    Duration? autoUpdateLayersInterval,
  }) {
    if (_mapController != null) {
      if (_mapController == mapController) return;
      _mapController?.removeLayersChangedListener(this);
      _mapController?.removeTimeExtentChangedListener(this);
    }
    _autoUpdateLayersTimer?.cancel();
    _autoUpdateLayersTimer = null;
    _mapController = mapController;
    _mapController?.addTimeExtentChangedListener(this);
    if (observeLayerChanges) {
      _mapController?.addLayersChangedListener(this);
      if (autoUpdateLayersInterval != null) {
        Timer.periodic(autoUpdateLayersInterval, (timer) async {
          await _updateData();
        });
      }
      _initFromMapController();
    }
  }

  void back({int steps = 5}) {
    isPlaying = false;
    if (currentStep > 0) {
      final nextStep = currentStep - steps;
      currentStep = nextStep > 0 ? nextStep : 0;
    }
  }

  void forward({int steps = 5}) {
    isPlaying = false;
    final nextStep = currentStep + steps;
    currentStep = nextStep < (totalSteps - 1) ? nextStep : totalSteps - 1;
  }

  void _invalidateTimeSteps() {
    _calculateTimeSteps();
    _currentStep =
        _findClosedStep(_currentExtent?.startTime ?? DateTime.now().toUtc());
    if (_moveTimeStep(_currentStep)) {
      _updateCurrentExtent(_currentExtent);
    }
    _updateAllLayersOffset();
    notifyListeners();
  }

  void _calculateTimeSteps() {
    _timeSteps.clear();

    var startTime = _fullExtent?.startTime;
    var endTime = _fullExtent?.endTime;
    if (startTime == null || endTime == null) {
      return;
    }

    if (startTime == endTime) {
      _timeSteps.add(startTime);
      return;
    }
    final intervalSeconds =
        Duration(seconds: timeStepInterval.toSeconds().toInt());

    if (intervalSeconds.inSeconds == 0) {
      return;
    }

    if (minDate != null &&
        minDate!.millisecondsSinceEpoch > startTime.millisecondsSinceEpoch) {
      startTime = minDate!;
    }

    if (maxDate != null &&
        maxDate!.millisecondsSinceEpoch < endTime.millisecondsSinceEpoch) {
      endTime = maxDate!;
    }

    var currentTime = startTime;
    var diffOffset = endTime.difference(startTime);
    var offset = diffOffset.inSeconds ~/ intervalSeconds.inSeconds;

    _timeSteps.add(startTime);
    for (int i = 1; i < offset - 1; i++) {
      currentTime = currentTime.add(intervalSeconds);
      _timeSteps.add(currentTime);
    }
    _timeSteps.add(endTime);
  }

  void _updateCurrentExtent(TimeExtent? timeExtent) {
    _mapController?.setTimeExtent(timeExtent);
    _updateAllLayersOffset();
  }

  int _findClosedStep(DateTime date) {
    if (_timeSteps.isEmpty) {
      return -1;
    }
    if (_timeSteps.length == 1) {
      return 0;
    }

    final firstDate = _timeSteps.first;
    final lastDate = _timeSteps.last;

    if (date.millisecondsSinceEpoch <= firstDate.millisecondsSinceEpoch) {
      return 0;
    }
    if (date.millisecondsSinceEpoch >= lastDate.millisecondsSinceEpoch) {
      return _timeSteps.length - 1;
    }

    for (var i = 0; i < _timeSteps.length - 1; i++) {
      final currentDate = _timeSteps[i];
      if (currentDate.millisecondsSinceEpoch <= date.millisecondsSinceEpoch) {
        return i;
      }
    }

    return _timeSteps.length - 1;
  }

  bool _moveTimeStep(int timeStep) {
    if (timeStep < 0 || timeStep > _timeSteps.length) {
      return false;
    }

    final date = _timeSteps[timeStep];
    final timeExtent = TimeExtent.singleValue(date);
    if (timeExtent == currentExtent) {
      return false;
    }
    _currentExtent = timeExtent;
    return true;
  }

  Future<void> _updateData() async {
    _wmsLayers.clear();

    final mapController = _mapController;
    if (mapController == null) {
      return;
    }
    final timeAwareLayers = await mapController.getTimeAwareLayerInfos();
    if (_isDisposed) {
      return;
    }
    final validTimeAwareLayers = timeAwareLayers
        .where((e) => e.fullTimeExtent != null && e.isTimeFilteringEnabled)
        .toList();

    fullExtent = _getFullTimeExtentFromAwareLayers(validTimeAwareLayers);

    if (_autoSetTimeOffset) {
      _wmsLayers.addAll(mapController.getLayersOfType<WmsLayer>());
      for (final layerInfo in timeAwareLayers) {
        _fetchTimeDimensionIfNeededForLayer(layerInfo);
      }
    }
  }

  TimeExtent? _getFullTimeExtentFromAwareLayers(
      List<TimeAwareLayerInfo> layers) {
    if (layers.isEmpty) {
      return null;
    }

    var fullTimeExtent = layers.first.fullTimeExtent!;

    for (final layer in layers.skip(1)) {
      fullTimeExtent = fullTimeExtent.union(layer.fullTimeExtent!);
    }

    return fullTimeExtent;
  }

  Future<void> _updateAllLayersOffset() {
    return Future.wait(_layersData.keys.map((e) => _updateLayerOffset(e)));
  }

  Future<void> _updateLayerOffset(LayerId layerId) async {
    if (_isDisposed) {
      return;
    }
    final data = _layersData[layerId];
    if (data == null) {
      return;
    }
    final mapController = _mapController;
    if (mapController == null) {
      return;
    }
    if (currentExtent == null) {
      return;
    }

    await mapController.setLayerTimeOffset(
        layerId, data.getClosedTimeValue(currentExtent!));
  }

  Future<void> _initFromMapController() async {
    final mapController = _mapController;
    if (mapController == null) {
      return;
    }

    _currentExtent = await mapController.getTimeExtent();
    await _updateData();
  }

  Future<void> _fetchTimeDimensionIfNeededForLayer(
      TimeAwareLayerInfo layerInfo) async {
    if (layerInfo.layerId == null) {
      return;
    }
    final layer = _findLayerById(layerInfo.layerId!);
    if (layer == null || layer.url == null) {
      if (layer != null) {
        _layersData.remove(layer.layerId);
      }
      return;
    }

    if (layer.layersName.isEmpty || layer.layersName.length > 1) {
      _layersData.remove(layer.layerId);
      return;
    }

    try {
      final wmsServiceInfo = await _wmsService.getServiceInfo(layer.url!);
      if (_isDisposed) {
        return;
      }
      if (wmsServiceInfo == null) {
        return;
      }
      for (final subLayerName in layer.layersName) {
        final subLayerInfo = wmsServiceInfo.getLayerInfoByName(subLayerName);
        if (subLayerInfo == null) {
          continue;
        }

        for (final dimension in subLayerInfo.dimensions) {
          final timeDimension = dimension.timeDimension;
          if (timeDimension != null) {
            _layersData[layer.layerId] = _LayerDimensionInfo(
              timeExtent: layerInfo.fullTimeExtent,
              timeDimension: timeDimension,
            );
            _updateLayerOffset(layer.layerId);
            break;
          }
        }
      }
    } catch (_) {
      _layersData.remove(layer.layerId);
    }
  }

  WmsLayer? _findLayerById(LayerId layerId) {
    for (final layer in _wmsLayers) {
      if (layer.layerId == layerId) {
        return layer;
      }
    }
    return null;
  }
}

class TimeSlider extends StatefulWidget {
  const TimeSlider({
    Key? key,
    required this.controller,
    this.currentTimeExtentFormat = 'd/MM/yyyy HH:mm',
    this.convertToLocalTime = true,
    this.backgroundDecoration,
    this.stepsJump = 5,
    this.showControls = true,
  }) : super(key: key);

  final TimeSliderController controller;

  final String currentTimeExtentFormat;

  final bool convertToLocalTime;

  final bool showControls;

  final int stepsJump;

  final Decoration? backgroundDecoration;

  @override
  _TimeSliderState createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  late TimeSliderController controller = widget.controller;
  final List<FlutterSliderHatchMarkLabel> labels = [];
  TimeExtent? _fullTimeExtent;

  String? _formatTooltipAndHatchMarkLabel;

  @override
  void initState() {
    super.initState();
    controller.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(TimeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleChange);
      widget.controller.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_handleChange);
    if (controller.autoDispose) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildControllers(context),
        _buildCurrentTimeExtent(context),
        _buildSlider(context),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _getBackgroundDecoration(),
      child: child,
    );
  }

  Widget _buildControllers(BuildContext context) {
    if (!widget.showControls) {
      return const SizedBox();
    }

    final isInvalid = controller.totalSteps == 0;

    var childrens = <Widget>[
      IconButton(
        icon: const Icon(
          Icons.skip_previous,
        ),
        onPressed: isInvalid
            ? null
            : controller.canMoveBack
                ? () => controller.back(steps: widget.stepsJump)
                : null,
      ),
      IconButton(
        icon: Icon(
          !controller.isPlaying ? Icons.play_arrow : Icons.pause,
        ),
        onPressed: isInvalid
            ? null
            : controller.canMoveForward
                ? () {
                    controller.isPlaying = !controller.isPlaying;
                  }
                : null,
      ),
      IconButton(
        icon: const Icon(
          Icons.skip_next,
        ),
        onPressed: isInvalid
            ? null
            : controller.canMoveForward
                ? () => controller.forward(steps: widget.stepsJump)
                : null,
      ),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: childrens,
    );
  }

  Widget _buildCurrentTimeExtent(BuildContext context) {
    final timeExtent = controller.currentExtent;

    if (timeExtent == null || !timeExtent.haveTime) {
      return const Text('');
    }

    Widget? startTimeView;
    Widget? endTimeView;

    if (timeExtent.startTime != null) {
      startTimeView = Text(
        Jiffy(
          getDate(timeExtent.startTime!),
        ).format(widget.currentTimeExtentFormat),
      );
    }

    if (timeExtent.endTime != null) {
      startTimeView = Text(
        Jiffy(
          getDate(timeExtent.endTime)!,
        ).format(widget.currentTimeExtentFormat),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (startTimeView != null) startTimeView,
        if (startTimeView != null && endTimeView != null) const Spacer(),
        if (endTimeView != null) endTimeView,
      ],
    );
  }

  Widget _buildSlider(BuildContext context) {
    final isInvalid = controller.totalSteps == 0;

    _calculateHatchMarkLabels();

    return Visibility(
      visible: controller.totalSteps != 0,
      child: FlutterSlider(
        min: 0,
        max: isInvalid ? 1 : (controller.totalSteps - 1).toDouble(),
        values: [
          isInvalid ? 0 : controller.currentStep.toDouble(),
        ],
        hatchMark: FlutterSliderHatchMark(
          density: 0.15,
          // means 50 lines, from 0 to 100 percent
          labelsDistanceFromTrackBar: 35,
          displayLines: true,
          linesAlignment: FlutterSliderHatchMarkAlignment.right,
          labels: labels,
        ),
        handler: FlutterSliderHandler(
          decoration: const BoxDecoration(),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(
                color: Colors.black.withOpacity(0.65),
                width: 1,
              ),
            ),
          ),
        ),
        handlerHeight: 30,
        trackBar: const FlutterSliderTrackBar(
          activeTrackBar: BoxDecoration(
            color: Colors.black,
          ),
        ),
        tooltip: FlutterSliderTooltip(
          custom: (value) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                Jiffy(getDate(controller.timeSteps[value.toInt()])!).format(
                  _formatTooltipAndHatchMarkLabel ??
                      widget.currentTimeExtentFormat,
                ),
                style: const TextStyle(fontSize: 24),
              ),
            );
          },
        ),
        onDragging: (handlerIndex, lowerValue, upperValue) {
          controller.currentStep = lowerValue.toInt();
        },
      ),
    );
  }

  DateTime? getDate(DateTime? date) {
    if (widget.convertToLocalTime) {
      return date?.toLocal();
    }
    return date;
  }

  Decoration _getBackgroundDecoration() {
    return widget.backgroundDecoration ??
        BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade300.withOpacity(0.8),
        );
  }

  void _handleChange() {
    if (_fullTimeExtent != controller.fullExtent) {
      _calculateHatchMarkLabels();
      _fullTimeExtent = controller.fullExtent;
    }
    setState(() {
      // The listenable's state is our build state, and it changed already.
    });
  }

  void _calculateHatchMarkLabels() {
    final dates = controller.timeSteps;
    labels.clear();
    if (dates.isEmpty || dates.length == 1) {
      return;
    }
    final startDate = dates.first;
    final endDate = dates.last;
    final diff = endDate.difference(startDate);
    late String format;
    if (diff.inDays == 0) {
      format = 'HH:mm';
    } else if (diff.inDays >= 30) {
      format = 'MMMM';
    } else {
      format = 'YY';
    }

    _formatTooltipAndHatchMarkLabel = format;

    if (dates.length >= 2) {
      labels.addAll([
        _createLabelFromDate(0, startDate, format),
        _createLabelFromDate(100, endDate, format),
      ]);
    }

    if (dates.length == 3) {
      labels.insert(1, _createLabelFromDate(50, dates[1], format));
      return;
    }

    final diffOffset = diff.inMilliseconds / 6;
    labels.insert(
      1,
      _createLabelFromDate(
        25,
        startDate.add(
          Duration(milliseconds: diffOffset.toInt()),
        ),
        format,
      ),
    );
    labels.insert(
      2,
      _createLabelFromDate(
        75,
        endDate.subtract(
          Duration(milliseconds: diffOffset.toInt()),
        ),
        format,
      ),
    );

    if (dates.length > 5) {
      labels.insert(
        2,
        _createLabelFromDate(
          50,
          startDate.add(
            Duration(milliseconds: diffOffset.toInt() * 2),
          ),
          format,
        ),
      );
    }
  }

  FlutterSliderHatchMarkLabel _createLabelFromDate(
      double percent, DateTime date, String format) {
    return FlutterSliderHatchMarkLabel(
      percent: percent,
      label: Text(
        Jiffy(getDate(date)!).format(format),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
