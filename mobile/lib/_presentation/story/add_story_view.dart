import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/map_location_picker.dart'
    hide Location;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_common/mixins/form_page_view_mixin.dart';
import 'package:swe/_core/env/env.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/widgets/base_loader.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/addStory_model.dart';
import 'package:swe/_domain/story/model/location_model.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/widgets/appBar/customAppBar.dart';
import 'package:swe/_presentation/widgets/app_button.dart';
import 'package:swe/_presentation/widgets/textformfield/app_text_form_field.dart';

enum AddStoryStepType {
  story(0),
  time(1),
  location(2);

  const AddStoryStepType(this.value);
  final int value;

  static AddStoryStepType fromValue(int value) {
    return AddStoryStepType.values.firstWhere((el) => el.value == value);
  }
}

enum TimeResolutionType {
  exactDate(0),
  exactDateWithTime(1),
  dateRange(2),
  decade(3);

  const TimeResolutionType(this.value);
  final int value;

  static TimeResolutionType fromValue(int value) {
    return TimeResolutionType.values.firstWhere((el) => el.value == value);
  }
}

@RoutePage()
class AddStoryView extends StatefulWidget {
  final bool myStories;
  final StoryModel? storyModel;
  const AddStoryView({super.key, this.myStories = false, this.storyModel});

  @override
  State<AddStoryView> createState() => _AddStoryViewState();
}

class _AddStoryViewState extends State<AddStoryView>
    with FormPageViewMixin, SingleTickerProviderStateMixin {
  late StoryCubit cubit;
  int index = 0;
  late TextEditingController titleController;
  late TextEditingController radiusController;

  late TextEditingController tagController;
  late TextEditingController textController;
  late QuillEditorController controller;
  late TextEditingController seasonController;
  late TextEditingController decadeController;
  late TextEditingController timeResolutionController;
  List<LatLng> selectedLocations = [];
  Map<String, LatLng>? additionalMarkers = {};
  Map<String, List<LatLng>>? additionalPolylines = {};
  Map<String, List<LatLng>>? additionalPolygones = {};
  Map<String, LatLng>? additionalCircles = {};

  List<LocationModel> selectedLocationsforMap = [];
  List<int> radiusList = [];

  bool _isPolyline = false;
  bool _isPolygon = false;
  bool _isCircle = false;
  bool _isPoint = true;
  int polygoneindex = -1;
  int polylineindex = -1;
  int circleindex = -1;
  bool showRadiusSelection = false;

  final customToolBarList = [
    ToolBarStyle.image,
    ToolBarStyle.link,
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
  );
  final _hintTextStyle = const TextStyle(
    fontSize: 18,
    color: Colors.black38,
    fontWeight: FontWeight.normal,
  );
  final bool _hasFocus = false;
  String? selectedSeason;
  String? selectedDecade;
  late String selectedMonth;
  late DateTime selectedStartDateTime;
  late DateTime selectedEndDateTime;
  late DateTime selectedStartDate;
  late DateTime selectedEndDate;

  String selectedAddress = 'null';
  double selectedLat = 0;
  double selectedLng = 0;
  final FocusNode _focusNode = FocusNode();
  late LatLng? _currentPosition = const LatLng(0, 0);
  final Location _locationController = Location();
  bool locationLoading = true;
  bool hasPermission = false;
  String? formattedStartDate;
  String? formattedStartDateTime;

  String? formattedEndDate;
  LocationModel? selectedLocation;
  late List<LocationModel> locations = [];
  String? htmlText;
  String? story;
  bool exatDateSelected = false;
  bool exactDateWithTimeSelected = false;
  bool dateRangeSelected = false;
  bool decadeSelected = false;
  int currnetIndex = 0;
  bool showBottomNav = true;
  String? selectTimeResolutions;
  bool firstLocation = true;

  List<List<LatLng>> polygonList = [[]];
  List<List<LatLng>> polylineList = [[]];
  List<LatLng> circleList = [];

  List<String> season = <String>['Winter', 'Spring', 'Summer', 'Fall'];
  List<String> decade = <String>[
    '1940s',
    '1950s',
    '1960s',
    '1970s',
    '1980s',
    '1990s',
    '2000s',
    '2010s',
    '2020s',
  ];
  List<String> timeResolutions = <String>[
    'Exact Date',
    'Exact Date with Time',
    'Date Range',
    'Decade',
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    permissionCheck();
    getCurrentLocation();
    seasonController = TextEditingController();
    decadeController = TextEditingController();
    titleController = TextEditingController();
    radiusController = TextEditingController();
    tagController = TextEditingController();
    textController = TextEditingController();
    controller = QuillEditorController();
    timeResolutionController = TextEditingController();
    story = '';
    selectedStartDateTime = DateTime(0);
    selectedEndDateTime = DateTime(0);
    selectedStartDate = DateTime(0);
    selectedEndDate = DateTime(0);
    if (widget.myStories) {
      story = widget.storyModel!.text;

      for (var i = 0; i < widget.storyModel!.locations!.length; i++) {
        locations.add(widget.storyModel!.locations![i]);
      }
      for (var i = 0; i < widget.storyModel!.locations!.length; i++) {
        selectedLocationsforMap.add(widget.storyModel!.locations![i]);
      }
      seasonController.text = widget.storyModel!.season ?? '';
      if (widget.storyModel!.decade != null) {
        decadeSelected = true;
        decadeController.text = widget.storyModel!.decade ?? '';
      }

      titleController.text = widget.storyModel!.title ?? '';
      if (widget.storyModel!.labels != null) {
        for (var i = 0; i < widget.storyModel!.labels!.length; i++) {
          if (i == 0) {
            tagController.text += widget.storyModel!.labels![i];
          } else {
            tagController.text += ',${widget.storyModel!.labels![i]}';
          }
        }
      }
      if (widget.storyModel!.startHourFlag != 0 &&
          widget.storyModel!.startHourFlag != null &&
          widget.storyModel!.startTimeStamp != null) {
        exactDateWithTimeSelected = true;
        final newTime = widget.storyModel!.startTimeStamp!.replaceAll('/', '-');
        final newTimeFormat = '$newTime:00';
        selectedStartDateTime =
            DateFormat('dd-MM-yyyy hh:mm:ss').parse(newTimeFormat);
        formattedStartDateTime = widget.storyModel!.startTimeStamp ?? '';
      } else if (widget.storyModel!.startHourFlag != null &&
          widget.storyModel!.startHourFlag == 0 &&
          widget.storyModel!.startTimeStamp != null) {
        exatDateSelected = true;
        final newTime = widget.storyModel!.startTimeStamp!.replaceAll('/', '-');
        selectedStartDate = DateFormat('dd-MM-yyyy').parse(newTime);
        formattedStartDate = widget.storyModel!.startTimeStamp ?? '';
      }
      if (widget.storyModel!.endHourFlag != 0 &&
          widget.storyModel!.endHourFlag != null &&
          widget.storyModel!.endTimeStamp != null) {
        exactDateWithTimeSelected = true;
        final newTime = widget.storyModel!.endTimeStamp!.replaceAll('/', '-');
        final newTimeFormat = '$newTime:00';
        selectedEndDateTime =
            DateFormat('dd-MM-yyyy hh:mm:ss').parse(newTimeFormat);
        formattedEndDate = widget.storyModel!.endTimeStamp ?? '';
      } else if (widget.storyModel!.endHourFlag != null &&
          widget.storyModel!.endHourFlag == 0 &&
          widget.storyModel!.endTimeStamp != null) {
        exatDateSelected = true;
        final newTime = widget.storyModel!.endTimeStamp!.replaceAll('/', '-');
        selectedEndDate = DateFormat('dd-MM-yyyy').parse(newTime);
        formattedEndDate = widget.storyModel!.endTimeStamp ?? '';
      }
    }
  }

  @override
  void dispose() {
    titleController.clear();
    //titleController.dispose();
    radiusController.clear();
    //radiusController.dispose();
    controller.clear();
    //controller.dispose();
    tagController.clear();
    textController.clear();
    //decadeController.dispose();
    decadeController.clear();
    //seasonController.dispose();
    seasonController.clear();
    timeResolutionController.clear();
    //timeResolutionController.dispose();

    super.dispose();
  }

  @override
  int get maxPageCount => 3;
  final formStoryKey = GlobalKey<FormState>();
  final formTimeKey = GlobalKey<FormState>();
  final formlocationKey = GlobalKey<FormState>();

  Future<bool> onPressedBack() async {
    FocusScope.of(context).unfocus();
    if (pageController.page == 0) return true;
    showBottomNav = true;
    previousPage();
    return false;
  }

  void onPressed() {
    // FocusScope.of(context).unfocus();

    final step = AddStoryStepType.fromValue(pageController.page!.toInt());

    switch (step) {
      case AddStoryStepType.story:
        if (!formStoryKey.currentState!.validate()) return;
        nextPage();
      case AddStoryStepType.time:
        nextPage();
      case AddStoryStepType.location:
        onPressSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<StoryCubit, StoryState>(
      onCubitReady: (cubit) {
        this.cubit = cubit;
        cubit.setContext(context);
      },
      builder: (context, cubit, state) {
        return BaseLoader(
          isLoading: locationLoading,
          child: WillPopScope(
            onWillPop: onPressedBack,
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: CustomAppBar(
                context,
                title: 'ADD STORY',
              ),
              body: GestureDetector(
                onTap: _focusNode.unfocus,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                      ),
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Form(
                            key: formStoryKey,
                            child: storyInfoWidget(),
                          ),
                          Form(
                            key: formTimeKey,
                            child: storyInfoTimeWidget(),
                          ),
                          Form(
                            key: formlocationKey,
                            child: storyLocationWidget(),
                          ),
                        ],
                      ),
                    ),
                    if (showBottomNav) buttonArea(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget storyLocationWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          MapLocationPicker(
            radiusList: radiusList.isEmpty ? [10] : radiusList,
            locations: selectedLocationsforMap,
            getSelectedLocations: () async {
              setState(() {
                selectedLocationsforMap = locations;
              });
            },
            apiKey: AppEnv.apiKey,
            currentLatLng: widget.myStories
                ? LatLng(
                    selectedLocationsforMap[0].latitude!,
                    selectedLocationsforMap[0].longitude!,
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
            bottomCardShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            hasLocationPermission: hasPermission,
            getLocation: () {
              getCurrentLocation();
            },
            additionalMarkers: additionalMarkers,
            additionalCircles: additionalCircles,
            additionalPolygons: additionalPolygones,
            additionalPolylines: additionalPolylines,
            isCircle: _isCircle,
            isPolygon: _isPolygon,
            isPolyline: _isPolyline,
            isPoint: _isPoint,
            polygonButtonPressed: () {
              polygoneindex++;
              setState(() {
                if (polygoneindex != 0) {
                  final addlist = <LatLng>[];
                  polygonList.add(addlist);
                }
                _isPolygon = true;
                _isPolyline = false;
                _isCircle = false;
                _isPoint = false;
              });
            },
            polylineButtonPressed: () {
              polylineindex++;
              setState(() {
                if (polylineindex != 0) {
                  final addlist = <LatLng>[];
                  polylineList.add(addlist);
                }
                _isPolygon = false;
                _isPolyline = true;
                _isCircle = false;
                _isPoint = false;
              });
            },
            circleButtonPressed: () {
              circleindex++;
              showRadiusSelection = true;
              setState(() {
                _isPolygon = false;
                _isPolyline = false;
                _isCircle = true;
                _isPoint = false;
              });
            },
            pointButtonPressed: () {
              setState(() {
                _isPolygon = false;
                _isPolyline = false;
                _isCircle = false;
                _isPoint = true;
              });
            },
            onTapPolygones: (points) {
              setState(() {
                polygonList[polygoneindex].add(points!);
                additionalPolygones?['$polygoneindex'] =
                    polygonList[polygoneindex];
              });
            },
            onTapPolylines: (points) {
              setState(() {
                polylineList[polylineindex].add(points!);
                additionalPolylines?['$polylineindex'] =
                    polylineList[polylineindex];
              });
            },
            onTapCircles: (point) {
              additionalCircles?['$circleindex'] =
                  LatLng(point!.latitude, point.longitude);
            },
            onTapMarkers: (position) {
              setState(() {
                _isPolygon = false;
                _isPolyline = false;
                _isCircle = false;
                _isPoint = true;
                index++;
                additionalMarkers?['$index'] =
                    LatLng(position!.latitude, position.longitude);
              });
            },
            deleteLocations: (index) {
              setState(() {
                if (locations[index].isCircle != null) {
                  additionalCircles
                      ?.removeWhere((key, value) => key == '$index');
                } else if (locations[index].isPolygon != null) {
                  polygonList[locations[index].isPolygon!].removeWhere(
                    (element) =>
                        element.latitude == locations[index].latitude! &&
                        element.longitude == locations[index].longitude!,
                  );
                } else if (locations[index].isPolyline != null) {
                  polylineList[locations[index].isPolyline!].removeWhere(
                    (element) =>
                        element.latitude == locations[index].latitude! &&
                        element.longitude == locations[index].longitude!,
                  );
                } else {
                  additionalMarkers
                      ?.removeWhere((key, value) => key == '$index');
                }
                locations.removeAt(index);
              });
            },
            onDecodeAddress: (GeocodingResult? result, LatLng? location) {
              setState(() {
                if (firstLocation) {
                  firstLocation = false;
                  return;
                }
                selectedLat = location!.latitude;
                selectedLng = location.longitude;
                selectedAddress = result!.formattedAddress ?? '';

                if (_isPoint) {
                  selectedLocation = LocationModel(
                    locationName: selectedAddress,
                    latitude: selectedLat,
                    longitude: selectedLng,
                    isPoint: 1,
                  );
                  if (selectedLocation != null) {
                    locations.add(selectedLocation!);
                  }
                } else if (_isCircle) {
                  selectedLocation = LocationModel(
                    locationName: selectedAddress,
                    latitude: selectedLat,
                    longitude: selectedLng,
                    isCircle: circleindex,
                    circleRadius: int.parse(radiusController.text),
                  );
                  if (selectedLocation != null) {
                    locations.add(selectedLocation!);
                  }
                } else if (_isPolygon) {
                  selectedLocation = LocationModel(
                    locationName: selectedAddress,
                    latitude: selectedLat,
                    longitude: selectedLng,
                    isPolygon: polygoneindex,
                  );
                  if (selectedLocation != null) {
                    locations.add(selectedLocation!);
                  }
                } else if (_isPolyline) {
                  selectedLocation = LocationModel(
                    locationName: selectedAddress,
                    latitude: selectedLat,
                    longitude: selectedLng,
                    isPolyline: polylineindex,
                  );
                  if (selectedLocation != null) {
                    locations.add(selectedLocation!);
                  }
                }

                selectedLocationsforMap = locations;
              });
            },
            onNext: (GeocodingResult? decodedAddress) {
              setState(() {
                selectedLat = decodedAddress!.geometry.location.lat;
                selectedLng = decodedAddress.geometry.location.lng;
                selectedAddress = decodedAddress.formattedAddress ?? '';

                selectedLocation = LocationModel(
                  locationName: selectedAddress,
                  latitude: selectedLat,
                  longitude: selectedLng,
                );
                if (selectedLocation != null) {
                  locations.add(selectedLocation!);
                }
              });
            },
          ),
          if (showRadiusSelection)
            Positioned(
              top: 70,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  border: Border.all(
                    color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: AppTextFormField(
                        controller: radiusController,
                        hintText: 'Write radius as meters',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showRadiusSelection = false;
                          radiusList.add(
                            radiusController.text != ''
                                ? int.parse(radiusController.text)
                                : 10,
                          );
                        });
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> permissionCheck() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {
        hasPermission = true;
        return;
      }
    }
  }

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

  Widget storyInfoWidget() {
    return GestureDetector(
      onTap: _focusNode.unfocus,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            AppTextFormField(
              controller: titleController,
              hintText: 'Add Title',
            ),
            BaseWidgets.lowerGap,
            AppTextFormField(
              controller: tagController,
              hintText: 'Add Tag/s (Divide with coma!)',
            ),
            BaseWidgets.lowerGap,
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                border: Border.all(color: context.appBarColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ToolBar.scroll(
                    mainAxisSize: MainAxisSize.max,
                    toolBarColor: _toolbarColor,
                    controller: controller,
                    padding: const EdgeInsets.all(8),
                    iconColor: _toolbarIconColor,
                    activeIconColor: Colors.greenAccent.shade400,
                    customButtons: const [],
                    toolBarConfig: customToolBarList,
                  ),
                  Expanded(
                    child: QuillHtmlEditor(
                      autoFocus: true,
                      text: story,
                      hintText: 'Write your story',
                      controller: controller,
                      minHeight: 500,
                      textStyle: _editorTextStyle,
                      hintTextStyle: _hintTextStyle,
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      hintTextPadding: const EdgeInsets.only(left: 20),
                      backgroundColor: _backgroundColor,
                      onTextChanged: (text) {
                        setState(() async {
                          story = text;
                          htmlText = await controller.getText();
                        });
                      },
                      onFocusChanged: (focus) {
                        debugPrint('has focus $focus');
                        setState(_focusNode.unfocus);
                      },
                      loadingBuilder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            BaseWidgets.dynamicGap(500),
          ],
        ),
      ),
    );
  }

  Widget storyInfoTimeWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            dropDownMenu(
              selectTimeResolutions,
              timeResolutions,
              'Select Time Resolutions',
              timeResolutionController,
              timeResolutions: true,
            ),
            BaseWidgets.lowerGap,
            if (exatDateSelected)
              AppButton(
                border: Border.all(color: context.appBarColor),
                backgroundColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black),
                label: formattedStartDate ?? 'Choose Date',
                onPressed: () async {
                  final dateTime = await dateTimePicker(
                    formattedStartDate,
                    selectedStartDate,
                    OmniDateTimePickerType.date,
                  );
                  setState(() {
                    selectedStartDate = dateTime!;
                    formattedStartDate =
                        DateFormat.yMd().format(selectedStartDate);
                  });
                },
              ),
            BaseWidgets.lowerGap,
            if (exactDateWithTimeSelected)
              AppButton(
                border: Border.all(color: context.appBarColor),
                backgroundColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black),
                label: formattedStartDateTime ?? 'Choose Date and Time',
                onPressed: () async {
                  final dateTime = await dateTimePicker(
                    formattedStartDateTime,
                    selectedStartDateTime,
                    OmniDateTimePickerType.dateAndTime,
                  );
                  setState(() {
                    selectedStartDateTime = dateTime!;
                    formattedStartDateTime =
                        DateFormat.yMd().add_jm().format(selectedStartDateTime);
                  });
                },
              ),
            BaseWidgets.lowerGap,
            if (decadeSelected)
              dropDownMenu(
                selectedSeason,
                season,
                'Choose Season',
                seasonController,
              ),
            BaseWidgets.lowerGap,
            if (decadeSelected)
              dropDownMenu(
                selectedDecade,
                decade,
                'Choose Decade',
                decadeController,
              ),
            BaseWidgets.lowerGap,
            if (dateRangeSelected)
              Column(
                children: [
                  AppButton(
                    labelStyle: const TextStyle(color: Colors.black),
                    border: Border.all(color: context.appBarColor),
                    backgroundColor: Colors.white,
                    label: formattedStartDate ?? 'Choose Start Date',
                    onPressed: () async {
                      final dateTime = await dateTimePicker(
                        formattedStartDate,
                        selectedStartDateTime,
                        OmniDateTimePickerType.date,
                      );
                      setState(() {
                        selectedStartDateTime = dateTime!;
                        formattedStartDate =
                            DateFormat.yMd().format(selectedStartDateTime);
                      });
                    },
                  ),
                  BaseWidgets.lowerGap,
                  AppButton(
                    labelStyle: const TextStyle(color: Colors.black),
                    border: Border.all(color: context.appBarColor),
                    backgroundColor: Colors.white,
                    label: formattedEndDate ?? 'Choose End Date',
                    onPressed: () async {
                      final dateTime = await dateTimePicker(
                        formattedEndDate,
                        selectedEndDateTime,
                        OmniDateTimePickerType.date,
                      );
                      setState(() {
                        selectedEndDateTime = dateTime ??
                            DateTime(
                              0,
                              0,
                              0,
                            );
                        formattedEndDate =
                            DateFormat.yMd().format(selectedEndDateTime);
                      });
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget dropDownMenu(
    String? selectedItem,
    List<String> menu,
    String title,
    TextEditingController controller, {
    bool timeResolutions = false,
  }) {
    return DropdownMenu<String>(
      controller: controller,
      hintText: title,
      width: MediaQuery.of(context).size.width * 0.92,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade900),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      menuStyle: MenuStyle(
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Colors.orange,
          ),
        ),
      ),
      onSelected: (String? value) {
        selectedItem = value;
        setState(() {
          selectedItem = value;
          if (timeResolutions) {
            final value = TimeResolutionType.fromValue(
              menu.indexOf(
                selectedItem!,
              ),
            );
            switch (value) {
              case TimeResolutionType.exactDate:
                exatDateSelected = true;
                exactDateWithTimeSelected = false;
                dateRangeSelected = false;
                decadeSelected = false;

              case TimeResolutionType.exactDateWithTime:
                exatDateSelected = false;
                exactDateWithTimeSelected = true;
                dateRangeSelected = false;
                decadeSelected = false;

              case TimeResolutionType.dateRange:
                exatDateSelected = false;
                exactDateWithTimeSelected = false;
                dateRangeSelected = true;
                decadeSelected = false;
              case TimeResolutionType.decade:
                exatDateSelected = false;
                exactDateWithTimeSelected = false;
                dateRangeSelected = false;
                decadeSelected = true;
            }
          }
        });
      },
      dropdownMenuEntries: menu.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
        );
      }).toList(),
    );
  }

  Future<DateTime?> dateTimePicker(
    String? formattedStartDate,
    DateTime selectedDateTime,
    OmniDateTimePickerType type,
  ) {
    return showOmniDateTimePicker(
      context: context,
      initialDate:
          formattedStartDate == null ? DateTime.now() : selectedDateTime,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      is24HourMode: true,
      minutesInterval: 1,
      isForce2Digits: false,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      type: type,
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
  }

  Align buttonArea(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0, 0.25, 0.75, 1],
            colors: [
              context.theme.scaffoldBackgroundColor.withOpacity(0),
              context.theme.scaffoldBackgroundColor,
              context.theme.scaffoldBackgroundColor,
              context.theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton.primary(
              context,
              centerLabel: true,
              label: 'Continue',
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onPressSubmit() async {
    final tagsList = tagController.text.split(',');
    var starttimecheck = false;
    var endtimecheck = false;
    /* var endTime = <String>[];
    var startTime = <String>[];
    if (dateRangeSelected) {
      if (selectedStartDateTime != DateTime(0)) {
        final parsedStartTime = selectedStartDateTime.toString();
        startTime = parsedStartTime.split(':00.000');
        starttimecheck = true;
      }

      if (selectedEndDateTime != DateTime(0)) {
        final parsedEndTime = selectedEndDateTime.toString();
        endTime = parsedEndTime.split(':00.000');
        endtimecheck = true;
      }
    } */

    if (selectedStartDateTime != DateTime(0)) {
      starttimecheck = true;
    }
    if (selectedEndDateTime != DateTime(0)) {
      endtimecheck = true;
    }

    final model = AddStoryModel(
      text: htmlText,
      title: titleController.text,
      labels: tagsList,
      season: seasonController.text != '' ? seasonController.text : null,
      decade: decadeController.text != '' ? decadeController.text : null,
/*       startTimeStamp: !starttimecheck ? null : startTime[0],
      endTimeStamp: !endtimecheck ? null : endTime[0], */
      startTimeStamp: starttimecheck
          ? exactDateWithTimeSelected
              ? selectedStartDateTime.toString()
              : selectedStartDate.toString()
          : selectedStartDate != DateTime(0)
              ? selectedStartDate.toString()
              : null,
      endTimeStamp: endtimecheck
          ? exactDateWithTimeSelected
              ? selectedEndDateTime.toString()
              : selectedEndDate.toString()
          : selectedEndDate != DateTime(0)
              ? selectedStartDate.toString()
              : null,
      startHourFlag: exactDateWithTimeSelected ? 1 : 0,
      endHourFlag:
          exactDateWithTimeSelected && selectedEndDateTime != DateTime(0)
              ? 1
              : 0,
      locations: locations,
    );
    if (widget.myStories) {
      await cubit.editStory(model, widget.storyModel!.id).then((value) {
        if (value) {
          Navigator.of(context).pop();
        }
      });
    } else {
      await cubit.addStory(model).then((value) {
        if (value) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  Future<String> getHtmlText() async {
    final htmlText = await controller.getText();
    debugPrint(htmlText);
    return htmlText;
  }

  Future<void> insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }

  Future<void> insertVideoURL(String url) async {
    await controller.embedVideo(url);
  }
}
