part of arcgis_maps_flutter;

class TimeSliderController extends ChangeNotifier {
  TimeExtent? _currentExtent;

  TimeExtent? get currentExtent => _currentExtent;

  set currentExtent(TimeExtent? value) {
    _currentExtent = value;
    notifyListeners();
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
