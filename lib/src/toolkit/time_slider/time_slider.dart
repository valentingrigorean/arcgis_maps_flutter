part of arcgis_maps_flutter;

class TimeSliderController extends ChangeNotifier
    implements TimeExtentChangedListener {
  final List<DateTime> _timeSteps = [];

  final Duration _playbackInterval;

  TimeValue _timeStepInterval;
  TimeExtent? _currentExtent;
  TimeExtent? _fullExtent;
  DateTime? _minDate;
  DateTime? _maxDate;

  bool _isDisposed = false;

  bool _isPlaying = false;

  int _currentStep = 0;

  Timer? _playbackTimer;

  TimeSliderController({
    required this.mapController,
    this.dataProvider,
    TimeValue timeStepInterval = const TimeValue(
      duration: 5,
      unit: TimeUnit.minutes,
    ),
    this.autoLoop = false,
    this.autoDispose = true,
    DateTime? minDate,
    DateTime? maxDate,
    Duration playbackInterval = const Duration(seconds: 1),
  })  : _timeStepInterval = timeStepInterval,
        _minDate = minDate,
        _maxDate = maxDate,
        _playbackInterval = playbackInterval {
    if (dataProvider != null) {
      dataProvider!
          .addFullTimeExtentChangeListener(_handleFullTimeExtentChange);
      _handleFullTimeExtentChange();
    }
  }

  @override
  void dispose() {
    mapController.removeTimeExtentChangedListener(this);
    dataProvider?.dispose();
    _playbackTimer?.cancel();
    _playbackTimer = null;

    _isDisposed = true;
    super.dispose();
  }

  final bool autoLoop;

  final bool autoDispose;

  final ArcgisMapController mapController;

  final TimeSliderDataProvider? dataProvider;

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
    notifyListeners();
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

  void _handleFullTimeExtentChange() async {
    if (_isDisposed) {
      return;
    }
    fullExtent = await dataProvider!.getFullTimeExtent();
    dataProvider!.onCurrentTimeExtentChanged(currentExtent);
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
    mapController.setTimeExtent(timeExtent);
    dataProvider?.onCurrentTimeExtentChanged(timeExtent);
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
          controller.isPlaying = false;
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
