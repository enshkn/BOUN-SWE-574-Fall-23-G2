import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_common/mixins/form_page_view_mixin.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/widgets/appBar/customAppBar.dart';
import 'package:swe/_presentation/widgets/app_button.dart';
import 'package:swe/_presentation/widgets/drop_down_menu.dart';
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

@RoutePage()
class AddStoryView extends StatefulWidget {
  const AddStoryView({super.key});

  @override
  State<AddStoryView> createState() => _AddStoryViewState();
}

class _AddStoryViewState extends State<AddStoryView>
    with FormPageViewMixin, SingleTickerProviderStateMixin {
  late StoryCubit cubit;
  late TextEditingController titleController;
  late TextEditingController tagController;
  late TextEditingController textController;
  final QuillController _quillcontroller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  late String selectedSeason;
  late String selectedDecade;
  late String selectedMonth;
  late DateTime selectedStartDateTime;
  late DateTime selectedEndDateTime;
  //static const LatLng _pInitialCameraPos = LatLng(37.42223, -122.0848);

  String? formattedStartDate;
  String? formattedEndDate;

  late TabController _tabController;
  int currnetIndex = 0;

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
  ];
  List<String> month = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    tagController = TextEditingController();
    textController = TextEditingController();
    selectedSeason = season.first;
    selectedDecade = decade.first;
    selectedMonth = month.first;

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
    tagController.clear();
    textController.clear();
    _tabController.removeListener(tabListener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  int get maxPageCount => 3;
  final formStoryKey = GlobalKey<FormState>();
  final formTimeKey = GlobalKey<FormState>();
  final formlocationKey = GlobalKey<FormState>();

  Future<bool> onPressedBack() async {
    if (pageController.page == 0) return true;
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
        //onPressSubmit();
        break;
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
        return WillPopScope(
          onWillPop: onPressedBack,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              context,
              title: 'ADD STORY',
            ),
            body: Stack(
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
                buttonArea(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget storyLocationWidget() {
    return Container();
    /* const GoogleMap(
      initialCameraPosition:
          CameraPosition(target: _pInitialCameraPos, zoom: 13),
    ); */
  }

  Widget storyInfoWidget() {
    return SingleChildScrollView(
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
              decoration: BoxDecoration(
                border: Border.all(color: context.appBarColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  QuillToolbar.basic(
                    controller: _quillcontroller,
                    embedButtons: FlutterQuillEmbeds.buttons(
                      showVideoButton: false,
                    ),
                  ),
                  BaseWidgets.normalGap,
                  QuillEditor.basic(
                    controller: _quillcontroller,
                    readOnly: false,
                    embedBuilders: FlutterQuillEmbeds.builders(),
                  ),
                  BaseWidgets.highGap,
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
            DropDownMenu(
              list: season,
              hintText: 'Choose Season',
              selectedItem: selectedSeason,
            ),
            BaseWidgets.lowerGap,
            DropDownMenu(
              list: decade,
              hintText: 'Choose Decade',
              selectedItem: selectedDecade,
            ),
            BaseWidgets.lowerGap,
            DropDownMenu(
              list: month,
              hintText: 'Choose Month',
              selectedItem: selectedMonth,
            ),
            BaseWidgets.lowerGap,
            const Divider(
              color: Colors.black,
            ),
            BaseWidgets.lowerGap,
            SizedBox(
              height: 200,
              child: Column(
                children: [
                  buildTabs(context),
                  BaseWidgets.lowerGap,
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Column(
                          children: [
                            AppButton(
                              border: Border.all(color: context.appBarColor),
                              backgroundColor: Colors.white,
                              labelStyle: const TextStyle(color: Colors.black),
                              label:
                                  formattedStartDate ?? 'Choose Date and Time',
                              onPressed: () async {
                                final dateTime = await dateTimePicker(
                                  formattedStartDate,
                                  selectedStartDateTime,
                                );
                                setState(() {
                                  selectedStartDateTime = dateTime!;
                                  formattedStartDate = DateFormat.yMd()
                                      .add_jm()
                                      .format(selectedStartDateTime);
                                });
                              },
                            ),
                            BaseWidgets.dynamicGap(60),
                          ],
                        ),
                        Column(
                          children: [
                            AppButton(
                              labelStyle: const TextStyle(color: Colors.black),
                              border: Border.all(color: context.appBarColor),
                              backgroundColor: Colors.white,
                              label: formattedStartDate ??
                                  'Choose Start Date and Time',
                              onPressed: () async {
                                final dateTime = await dateTimePicker(
                                  formattedStartDate,
                                  selectedStartDateTime,
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
                              label: formattedEndDate ??
                                  'Choose End Date and Time',
                              onPressed: () async {
                                final dateTime = await dateTimePicker(
                                  formattedEndDate,
                                  selectedEndDateTime,
                                );
                                setState(() {
                                  selectedEndDateTime = dateTime!;
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildTabs(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        color: context.appBarColor,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: context.colors.inversePrimary,
        tabs: [
          Tab(
            child: Text(
              'Exact Date',
              style: TextStyle(
                color: Colors.white.withOpacity(currnetIndex == 0 ? 1 : 0.6),
              ),
            ),
          ),
          Tab(
            child: Text(
              'Date Range',
              style: TextStyle(
                color: Colors.white.withOpacity(currnetIndex == 1 ? 1 : 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> dateTimePicker(
    String? formattedStartDate,
    DateTime selectedDateTime,
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
            BaseWidgets.lowerGap,
            numberOfSection(),
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
}
