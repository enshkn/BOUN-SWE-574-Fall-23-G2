import 'package:flutter/material.dart';
import 'package:google_map_location_picker/map_location_picker.dart'
    hide Location;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/env/env.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/location_model.dart';
import 'package:swe/_domain/story/model/story_filter.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/widgets/app_button.dart';
import 'package:swe/_presentation/widgets/filters/modal_header.dart';
import 'package:swe/_presentation/widgets/textformfield/app_text_form_field.dart';

class StoryFilterModal extends StatefulWidget {
  const StoryFilterModal({
    this.currentFilter,
    super.key,
  });
  final StoryFilter? currentFilter;

  @override
  State<StoryFilterModal> createState() => _StoryFilterModalState();
}

class _StoryFilterModalState extends State<StoryFilterModal> {
  late StoryFilter filter;
  late StoryCubit cubit;

  late TextEditingController radiusController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController startTimeStampController;
  late TextEditingController endTimeStampController;
  late TextEditingController decadeController;
  late TextEditingController seasonController;

  String? query;
  int? radius;
  double? latitude;
  double? longitude;
  String? startTimeStamp;
  String? endTimeStamp;
  String? decade;
  String? season;

  int index = 0;
  late TextEditingController radiusMapController;

  List<LatLng> selectedLocations = [];

  List<LocationModel> selectedLocationsforMap = [];
  List<int> radiusList = [];
  final FocusNode _focusNode = FocusNode();
  late LatLng? _currentPosition;
  final Location _locationController = Location();
  bool showRadiusSelection = false;
  double selectedLat = 0;
  double selectedLng = 0;
  String selectedAddress = 'null';
  LocationModel? selectedLocation;
  late List<LocationModel> locations = [];
  bool hasPermission = false;
  bool locationLoading = true;
  bool firstLocation = true;
  late LocationData currentLocation;

  @override
  void initState() {
    getLocationMemory();
    getCurrentLocation();
    filter = const StoryFilter();
    radiusController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    startTimeStampController = TextEditingController();
    endTimeStampController = TextEditingController();
    decadeController = TextEditingController();
    seasonController = TextEditingController();

    setFilter(widget.currentFilter);

    super.initState();
  }

  Future<void> getLocationMemory() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble('latitude');
    final longitude = prefs.getDouble('longitude');
    if (latitude != null && longitude != null) {
      _currentPosition = LatLng(latitude, longitude);
    }
  }

  void setFilter(StoryFilter? filter) {
    if (filter == null) return;
    query = widget.currentFilter!.query;
    radius = widget.currentFilter!.radius;
    latitude = widget.currentFilter!.latitude;
    longitude = widget.currentFilter!.longitude;
    startTimeStamp = widget.currentFilter!.startTimeStamp;
    endTimeStamp = widget.currentFilter!.endTimeStamp;
    decade = widget.currentFilter!.decade;
    season = widget.currentFilter!.season;

    radiusController.text = widget.currentFilter!.radius.toString() == 'null'
        ? ''
        : widget.currentFilter!.radius.toString();
    latitudeController.text =
        widget.currentFilter!.latitude.toString() == 'null'
            ? ''
            : widget.currentFilter!.latitude.toString();
    longitudeController.text =
        widget.currentFilter!.longitude.toString() == 'null'
            ? ''
            : widget.currentFilter!.longitude.toString();
    startTimeStampController.text = widget.currentFilter!.startTimeStamp ?? '';
    endTimeStampController.text = widget.currentFilter!.endTimeStamp ?? '';
    decadeController.text = widget.currentFilter!.decade ?? '';
    seasonController.text = widget.currentFilter!.season ?? '';
    this.filter = filter;
  }

  void cancelFilter() {
    cubit.clearState();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<StoryCubit, StoryState>(
      onCubitReady: (cubit) {
        cubit.setContext(context);
        this.cubit = cubit;
      },
      builder: (context, cubit, state) {
        final maxHeight = MediaQuery.of(context).size.height * 0.90;

        return SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              cancelFilter();
              return false;
            },
            child: SizedBox(
              height: maxHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ModalHeader(
                          title: 'Filter',
                          actionType: ModalHeaderActionType.clear,
                          onClear: filter.isEmpty
                              ? null
                              : () {
                                  query = null;
                                  radius = null;
                                  latitude = null;
                                  longitude = null;
                                  startTimeStamp = null;
                                  endTimeStamp = null;
                                  decade = null;
                                  season = null;
                                  radiusController.text = '';
                                  latitudeController.text = '';
                                  longitudeController.text = '';
                                  startTimeStampController.text = '';
                                  endTimeStampController.text = '';
                                  decadeController.text = '';
                                  seasonController.text = '';
                                  filter = const StoryFilter();

                                  setState(() {});
                                },
                        ),
                      ),
                    ),
                    Expanded(
                      child: BaseScrollView(
                        children: [
                          BaseWidgets.normalGap,
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: MapLocationPicker(
                              hideAreasList: true,
                              radiusList: radiusList,
                              apiKey: AppEnv.apiKey,
                              getLocation: () {
                                getCurrentLocation();
                              },
                              currentLatLng: filter.isEmpty
                                  ? _currentPosition
                                  : latitudeController.text == '' &&
                                          longitudeController.text != ''
                                      ? LatLng(
                                          double.parse(latitudeController.text),
                                          double.parse(
                                            longitudeController.text,
                                          ),
                                        )
                                      : _currentPosition,
                              bottomCardMargin: const EdgeInsets.fromLTRB(
                                8,
                                0,
                                8,
                                100,
                              ),
                              hideMapTypeButton: true,
                              hideLocationButton: true,
                              hideBackButton: true,
                              bottomCardShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              onDecodeAddress: (
                                GeocodingResult? result,
                                LatLng? location,
                              ) {
                                setState(() {
                                  if (firstLocation) {
                                    firstLocation = false;
                                    return;
                                  }
                                  selectedLat = location!.latitude;
                                  selectedLng = location.longitude;
                                  selectedAddress =
                                      result!.formattedAddress ?? '';
                                  selectedLocation = LocationModel(
                                    locationName: selectedAddress,
                                    latitude: selectedLat,
                                    longitude: selectedLng,
                                  );
                                  if (selectedLocation != null) {
                                    longitudeController.text =
                                        selectedLocation!.longitude.toString();
                                    latitudeController.text =
                                        selectedLocation!.latitude.toString();
                                  }
                                });
                              },
                              onNext: (GeocodingResult? decodedAddress) {
                                setState(() {
                                  selectedLat =
                                      decodedAddress!.geometry.location.lat;
                                  selectedLng =
                                      decodedAddress.geometry.location.lng;
                                  selectedAddress =
                                      decodedAddress.formattedAddress ?? '';

                                  selectedLocation = LocationModel(
                                    locationName: selectedAddress,
                                    latitude: selectedLat,
                                    longitude: selectedLng,
                                  );
                                  if (selectedLocation != null) {
                                    longitudeController.text =
                                        selectedLocation!.longitude.toString();
                                    latitudeController.text =
                                        selectedLocation!.latitude.toString();
                                  }
                                });
                              },
                            ),
                          ),
                          BaseWidgets.normalGap,
                          AppTextFormField(
                            controller: radiusController,
                            hintText: 'Write radius',
                          ),
                          BaseWidgets.normalGap,
                          AppTextFormField(
                            controller: startTimeStampController,
                            hintText: 'Write start time',
                          ),
                          BaseWidgets.normalGap,
                          AppTextFormField(
                            controller: endTimeStampController,
                            hintText: 'Write end time',
                          ),
                          BaseWidgets.normalGap,
                          AppTextFormField(
                            controller: decadeController,
                            hintText: 'Write decade',
                          ),
                          BaseWidgets.normalGap,
                          AppTextFormField(
                            controller: seasonController,
                            hintText: 'Write season',
                          ),
                          BaseWidgets.normalGap,
                          AppButton.primary(
                            context,
                            centerLabel: true,
                            label: 'Continue',
                            onPressed: onPressSubmit,
                          ),
                          BaseWidgets.normalGap,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /* Future<void> getCurrentLocation() async {
    LocationData currentLocation;
    currentLocation = await _locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        _currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        locationLoading = false;
      });
    }
  } */

  /* Future<void> getCurrentLocation() async {
    currentLocation = await _locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        _currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        locationLoading = false;
      });
    }
  } */

  Future<void> getCurrentLocation() async {
    LocationData currentLocation;
    currentLocation = await _locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        _currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        locationLoading = false;
      });
    }
  }

  Future<void> onPressSubmit() async {
    final filter = StoryFilter(
      query: query,
      radius:
          radiusController.text != '' ? int.parse(radiusController.text) : null,
      latitude: latitudeController.text != ''
          ? double.parse(latitudeController.text)
          : null,
      longitude: longitudeController.text != ''
          ? double.parse(longitudeController.text)
          : null,
      startTimeStamp: startTimeStampController.text != ''
          ? startTimeStampController.text
          : null,
      endTimeStamp: endTimeStampController.text != ''
          ? endTimeStampController.text
          : null,
      decade: decadeController.text != '' ? decadeController.text : null,
      season: seasonController.text != '' ? seasonController.text : null,
    );

    Navigator.of(context).pop(filter);
  }
}
