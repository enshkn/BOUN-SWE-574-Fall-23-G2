import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/map_location_picker.dart'
    hide Location;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_common/mixins/form_page_view_mixin.dart';
import 'package:swe/_core/env/env.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/widgets/base_loader.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/addStory_model.dart';
import 'package:swe/_domain/story/model/location_model.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/widgets/appBar/customAppBar.dart';
import 'package:swe/_presentation/widgets/app_button.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';
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
  decade(3),
  year(4);

  const TimeResolutionType(this.value);
  final int value;

  static TimeResolutionType fromValue(int value) {
    return TimeResolutionType.values.firstWhere((el) => el.value == value);
  }
}

@RoutePage()
class AddStoryView extends StatefulWidget {
  const AddStoryView({super.key});

  @override
  State<AddStoryView> createState() => _AddStoryViewState();
}

class _AddStoryViewState extends State<AddStoryView>
    with FormPageViewMixin, SingleTickerProviderStateMixin {
  late StoryCubit cubit;
  int index = 0;
  late TextEditingController titleController;
  late TextEditingController tagController;
  late TextEditingController textController;
  late QuillEditorController controller;
  late TextEditingController seasonController;
  late TextEditingController decadeController;
  late TextEditingController timeResolutionController;
  List<LatLng> selectedLocations = [];
  Map<String, LatLng>? additionalMarkers = {};
  List<LocationModel> selectedLocationsforMap = [];

  final customToolBarList = [
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
    ToolBarStyle.link,
    ToolBarStyle.image,
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
  String selectedAddress = 'null';
  double selectedLat = 0;
  double selectedLng = 0;
  final FocusNode _focusNode = FocusNode();
  late LatLng? _currentPosition = const LatLng(0, 0);
  final Location _locationController = Location();
  bool locationLoading = true;
  bool hasPermission = false;
  String? formattedStartDate;
  String? formattedEndDate;
  LocationModel? selectedLocation;
  late List<LocationModel> locations = [];
  String? htmlText;
  String? story;
  bool exatDateSelected = false;
  bool exactDateWithTimeSelected = false;
  bool dateRangeSelected = false;
  bool decadeSelected = false;
  bool yearSelected = false;

  late TabController _tabController;
  int currnetIndex = 0;
  bool showBottomNav = true;
  String? selectTimeResolutions;
  bool firstLocation = true;

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
    'Year',
  ];

  @override
  void initState() {
    super.initState();
    permissionCheck();
    getCurrentLocation();
    seasonController = TextEditingController();
    decadeController = TextEditingController();
    titleController = TextEditingController();
    tagController = TextEditingController();
    textController = TextEditingController();
    controller = QuillEditorController();
    timeResolutionController = TextEditingController();
    story = '';

    selectedStartDateTime = DateTime(
      0,
      0,
      0,
    );
    selectedEndDateTime = DateTime(
      0,
      0,
      0,
    );
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(tabListener);
  }

  void tabListener() {
    _tabController.addListener(() {
      if (currnetIndex != _tabController.index) {
        setState(() {
          currnetIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    titleController.clear();
    controller.clear();
    controller.dispose();
    tagController.clear();
    textController.clear();
    _tabController.removeListener(tabListener);
    _tabController.dispose();
    decadeController.dispose();
    decadeController.clear();
    seasonController.dispose();
    seasonController.clear();
    timeResolutionController.clear();
    timeResolutionController.dispose();

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
    FocusScope.of(context).unfocus();

    if (isLastPage) {
      return;
    }

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
      child: MapLocationPicker(
        locations: selectedLocationsforMap,
        getSelectedLocations: () async {
          setState(() {
            selectedLocationsforMap = locations;
          });
        },
        apiKey: AppEnv.apiKey,
        currentLatLng: _currentPosition,
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
        onTapMarkers: (position) {
          setState(() {
            index++;
            additionalMarkers?['marker$index'] =
                LatLng(position!.latitude, position.longitude);
          });
        },
        deleteLocations: (index) {
          setState(() {
            locations.removeAt(index);
            additionalMarkers
                ?.removeWhere((key, value) => key == 'marker$index');
          });
        },
        onDecodeAddress: (GeocodingResult? result) {
          setState(() {
            if (firstLocation) {
              firstLocation = false;
              return;
            }

            selectedLat = result!.geometry.location.lat;
            selectedLng = result.geometry.location.lng;
            selectedAddress = result.formattedAddress ?? '';
            selectedLocation = LocationModel(
              locationName: selectedAddress,
              latitude: selectedLat,
              longitude: selectedLng,
            );
            if (selectedLocation != null) {
              locations.add(selectedLocation!);
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
    return SingleChildScrollView(
      child: GestureDetector(
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
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(color: context.appBarColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ToolBar(
                      toolBarColor: _toolbarColor,
                      padding: const EdgeInsets.all(8),
                      iconColor: _toolbarIconColor,
                      activeIconColor: Colors.greenAccent.shade400,
                      controller: controller,
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
            if (exactDateWithTimeSelected)
              AppButton(
                border: Border.all(color: context.appBarColor),
                backgroundColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black),
                label: formattedStartDate ?? 'Choose Date and Time',
                onPressed: () async {
                  final dateTime = await dateTimePicker(
                    formattedStartDate,
                    selectedStartDateTime,
                    OmniDateTimePickerType.dateAndTime,
                  );
                  setState(() {
                    selectedStartDateTime = dateTime!;
                    formattedStartDate =
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
                    label: formattedStartDate ?? 'Choose Start Date and Time',
                    onPressed: () async {
                      final dateTime = await dateTimePicker(
                        formattedStartDate,
                        selectedStartDateTime,
                        OmniDateTimePickerType.date,
                      );
                      setState(() {
                        selectedStartDateTime = dateTime!;
                        formattedStartDate = DateFormat.yMd()
                            .add_jm()
                            .format(selectedStartDateTime);
                      });
                    },
                  ),
                  BaseWidgets.lowerGap,
                  AppButton(
                    labelStyle: const TextStyle(color: Colors.black),
                    border: Border.all(color: context.appBarColor),
                    backgroundColor: Colors.white,
                    label: formattedEndDate ?? 'Choose End Date and Time',
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
                        formattedEndDate = DateFormat.yMd()
                            .add_jm()
                            .format(selectedEndDateTime);
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
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
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
            color: Colors.blue,
          ),
        ),
      ),
      onSelected: (String? value) {
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
                yearSelected = false;
              case TimeResolutionType.exactDateWithTime:
                exatDateSelected = false;
                exactDateWithTimeSelected = true;
                dateRangeSelected = false;
                decadeSelected = false;
                yearSelected = false;
              case TimeResolutionType.dateRange:
                exatDateSelected = false;
                exactDateWithTimeSelected = false;
                dateRangeSelected = true;
                decadeSelected = false;
                yearSelected = false;
              case TimeResolutionType.decade:
                exatDateSelected = false;
                exactDateWithTimeSelected = false;
                dateRangeSelected = false;
                decadeSelected = true;
                yearSelected = false;
              case TimeResolutionType.year:
                exatDateSelected = false;
                exactDateWithTimeSelected = false;
                dateRangeSelected = false;
                decadeSelected = false;
                yearSelected = true;
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
            //BaseWidgets.lowerGap,
            //numberOfSection(),
          ],
        ),
      ),
    );
  }

  Widget numberOfSection() {
    const widthSize = 15.0;
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widthSize,
          child: Center(child: Text('${currentPage + 1}', style: textStyle)),
        ),
        const SizedBox(
          width: widthSize,
          child: Center(child: Text('/', style: textStyle)),
        ),
        SizedBox(
          width: widthSize,
          child: Center(
            child: Text('$maxPageCount', style: textStyle),
          ),
        ),
      ],
    );
  }

  Future<void> onPressSubmit() async {
    final tagsList = tagController.text.split(',');
    final parsedStartTime = selectedStartDateTime.toString();
    final startTime = parsedStartTime.split(':00.000');
    final parsedEndTime = selectedEndDateTime.toString();
    final endTime = parsedEndTime.split(':00.000');
    final model = AddStoryModel(
      text: htmlText,
      title: titleController.text,
      labels: tagsList,
      season: selectedSeason,
      decade: selectedDecade,
      startTimeStamp: startTime[0],
      endTimeStamp: endTime[0],
      locations: locations,
    );
    await cubit.addStory(model).then((value) {
      if (value) {
        Navigator.of(context).pop();
      }
    });
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
