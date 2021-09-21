part of arcgis_maps_flutter;

class TimeSliderController extends ChangeNotifier
    implements TimeExtentChangedListener {
  final List<DateTime> _timeSteps = [];
  ArcgisMapController? _mapController;

  TimeExtent? _currentExtent;
  TimeExtent? _fullExtent;
  TimeValue _timeStepInterval;

  TimeSliderController({
    TimeValue timeStepInterval = const TimeValue(
      duration: 5,
      unit: TimeUnit.minutes,
    ),
  }) : _timeStepInterval = timeStepInterval;

  @override
  void dispose() {
    _mapController?.removeTimeExtentChangedListener(this);
    super.dispose();
  }

  List<DateTime> get timeSteps => List.unmodifiable(_timeSteps);

  TimeExtent? get currentExtent => _currentExtent;

  set currentExtent(TimeExtent? value) {
    _currentExtent = value;
    notifyListeners();
  }

  TimeExtent? get fullExtent => _fullExtent;

  set fullExtent(TimeExtent? value) {
    _fullExtent = value;
    _calculateTimeSteps();
    notifyListeners();
  }

  TimeValue get timeStepInterval => _timeStepInterval;

  set timeStepInterval(TimeValue value) {
    _timeStepInterval = value;
    _calculateTimeSteps();
    notifyListeners();
  }

  void setMapController(ArcgisMapController? mapController) {
    if (_mapController != null) {
      if (_mapController == mapController) return;
      _mapController?.removeTimeExtentChangedListener(this);
    }
    _mapController = mapController;
    _mapController?.addTimeExtentChangedListener(this);
  }

  @override
  void timeExtentChanged(TimeExtent? timeExtent) {}

  void _calculateTimeSteps() {
    _timeSteps.clear();

    final startTime = _fullExtent?.startTime;
    final endTime = _fullExtent?.endTime;
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
}

class TimeSlider extends StatefulWidget {
  const TimeSlider({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ArcgisMapController controller;

  @override
  _TimeSliderState createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
