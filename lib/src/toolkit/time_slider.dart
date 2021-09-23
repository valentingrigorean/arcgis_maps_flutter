part of arcgis_maps_flutter;

class TimeSliderController extends ChangeNotifier
    implements TimeExtentChangedListener, LayersChangedListener {
  final List<DateTime> _timeSteps = [];

  final Duration _playbackInterval;

  ArcgisMapController? _mapController;

  TimeValue _timeStepInterval;
  TimeExtent? _currentExtent;
  TimeExtent? _fullExtent;
  DateTime? _minDate;
  DateTime? _maxDate;

  bool _isPlaying = false;

  int _currentStep = 0;

  Timer? _playbackTimer;

  TimeSliderController({
    TimeValue timeStepInterval = const TimeValue(
      duration: 5,
      unit: TimeUnit.minutes,
    ),
    this.loop = false,
    DateTime? minDate,
    DateTime? maxDate,
    Duration playbackInterval = const Duration(seconds: 1),
  })  : _timeStepInterval = timeStepInterval,
        _minDate = minDate,
        _maxDate = maxDate,
        _playbackInterval = playbackInterval;

  @override
  void dispose() {
    _mapController?.removeTimeExtentChangedListener(this);
    _mapController?.removeLayersChangedListener(this);
    super.dispose();
  }

  final bool loop;

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
        if (loop && nextValue >= totalSteps - 1) {
          currentStep = 0;
        } else if (nextValue < totalSteps - 1) {
          currentStep = nextValue;
        } else {
          isPlaying = false;
        }
      });
    }

    notifyListeners();
  }

  List<DateTime> get timeSteps => List.unmodifiable(_timeSteps);

  int get totalSteps => _timeSteps.length;

  int get currentStep => _currentStep;

  bool get canMoveBack => currentStep > 0;

  bool get canMoveForward => currentStep + 1 < totalSteps;

  set currentStep(int value) {
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
    _fullExtent = value;
    _invalidateTimeSteps();
  }

  TimeValue get timeStepInterval => _timeStepInterval;

  set timeStepInterval(TimeValue value) {
    if (_timeStepInterval == value) {
      return;
    }
    _timeStepInterval = value;
    _invalidateTimeSteps();
  }

  DateTime? get minDate => _minDate;

  set minDate(DateTime? value) {
    if (_minDate == value) {
      return;
    }
    _minDate = minDate;
    _invalidateTimeSteps();
  }

  DateTime? get maxDate => _maxDate;

  set maxDate(DateTime? value) {
    if (_maxDate == value) {
      return;
    }
    _maxDate = value;
    _invalidateTimeSteps();
  }

  @override
  void timeExtentChanged(TimeExtent? timeExtent) {
    _currentExtent = timeExtent;
    notifyListeners();
  }

  @override
  void onLayersChanged(LayerType onLayer, LayerChangeType layerChange) async {
    if (onLayer == LayerType.operational) {
      fullExtent = await _getTimeExtentFromAwareLayers();
    }
  }

  void setMapController(
    ArcgisMapController? mapController, {
    bool observeLayerChanges = true,
  }) {
    if (_mapController != null) {
      if (_mapController == mapController) return;
      _mapController?.removeLayersChangedListener(this);
      _mapController?.removeTimeExtentChangedListener(this);
    }
    _mapController = mapController;
    _mapController?.addTimeExtentChangedListener(this);
    if (observeLayerChanges) {
      _mapController?.addLayersChangedListener(this);
      _initFromMapController();
    }
  }

  void back() {
    isPlaying = false;
    if (currentStep > 0) {
      currentStep = currentStep - 1;
    }
  }

  void forward() {
    isPlaying = false;
    if (currentStep + 1 < totalSteps) {
      currentStep = currentStep + 1;
    }
  }

  void _invalidateTimeSteps() {
    _calculateTimeSteps();
    _currentStep =
        _findClosedStep(_currentExtent?.startTime ?? DateTime.now().toUtc());
    if (_moveTimeStep(_currentStep)) {
      _updateCurrentExtent(_currentExtent);
    }
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

    while (true) {
      _timeSteps.add(currentTime);
      if (currentTime.millisecondsSinceEpoch >=
          endTime.millisecondsSinceEpoch) {
        _timeSteps.add(endTime);
        break;
      } else {
        currentTime = currentTime.add(intervalSeconds);
      }
    }
  }

  void _updateCurrentExtent(TimeExtent? timeExtent) {
    _mapController?.setTimeExtent(timeExtent);
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

  Future<TimeExtent?> _getTimeExtentFromAwareLayers() async {
    final mapController = _mapController;
    if (mapController == null) {
      return null;
    }
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

  Future<void> _initFromMapController() async {
    final mapController = _mapController;
    if (mapController == null) {
      return;
    }

    _currentExtent = await mapController.getTimeExtent();
    fullExtent = await _getTimeExtentFromAwareLayers();
  }
}

class TimeSlider extends StatefulWidget {
  const TimeSlider({
    Key? key,
    required this.controller,
    this.currentTimeExtentFormat = 'd/MM/yyyy HH:mm',
    this.convertToLocalTime = true,
    this.backgroundDecoration,
  }) : super(key: key);

  final TimeSliderController controller;

  final String currentTimeExtentFormat;

  final bool convertToLocalTime;

  final Decoration? backgroundDecoration;

  @override
  _TimeSliderState createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  late TimeSliderController controller = widget.controller;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _getBackgroundDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildControllers(context),
          _buildCurrentTimeExtent(context),
          _buildSlider(context),
        ],
      ),
    );
  }

  Widget _buildControllers(BuildContext context) {
    final isInvalid = controller.totalSteps == 0;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
          ),
          onPressed: isInvalid
              ? null
              : controller.canMoveBack
                  ? controller.back
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
                  ? controller.forward
                  : null,
        ),
      ],
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
    final data = SliderTheme.of(context);
    final isInvalid = controller.totalSteps == 0;

    return Offstage(
      offstage: controller.totalSteps == 0,
      child: SliderTheme(
        data: data.copyWith(
          tickMarkShape: _TimeSliderTickMarkShape(),
        ),
        child: Slider(
          value: isInvalid ? 0 : controller.currentStep.toDouble(),
          min: 0,
          max: isInvalid ? 1 : (controller.totalSteps - 1).toDouble(),
          divisions: isInvalid ? null : controller.totalSteps,
          onChanged: (val) {
            controller.currentStep = val.toInt();
          },
          label: isInvalid
              ? null
              : Jiffy(
                  getDate(controller.timeSteps[controller.currentStep]),
                ).format(widget.currentTimeExtentFormat),
        ),
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
          color: Colors.grey.shade300.withOpacity(0.5),
        );
  }

  void _handleChange() {
    setState(() {
      // The listenable's state is our build state, and it changed already.
    });
  }
}

class _TimeSliderTickMarkShape extends SliderTickMarkShape {
  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    return const Size(4, 20);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    required bool isEnabled,
    required TextDirection textDirection,
  }) {
    var paint = Paint()..color = Colors.black;

    context.canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, 10), paint);
  }
}
