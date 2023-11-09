import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_map_location_picker/map_location_picker.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/env/env.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/extensions/string_extensions.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/story/model/location_model.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_consumer.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';
import 'package:swe/_presentation/widgets/icon_with_label.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_wrapper.dart';

@RoutePage()
class StoryDetailsView extends StatefulWidget {
  final StoryModel model;
  final bool leadBackHome;
  const StoryDetailsView({
    required this.model,
    super.key,
    this.leadBackHome = false,
  });

  @override
  State<StoryDetailsView> createState() => _StoryDetailsViewState();
}

class _StoryDetailsViewState extends State<StoryDetailsView> {
  late final ExpansionTileController controller;
  late final ExpansionTileController controller2;
  late final ExpansionTileController controller3;
  late final ExpansionTileController controller4;
  late final ExpansionTileController controller5;
  late final ExpansionTileController controller6;

  late final StoryCubit cubit;
  bool addFavoriteTriggered = false;
  Map<String, LatLng> additionalMarkers = {};
  Map<String, List<LatLng>>? additionalPolylines = {};
  Map<String, List<LatLng>>? additionalPolygones = {};
  Map<String, LatLng>? additionalCircles = {};
  final circleLocations = <LocationModel>[];
  final polylineLocations = <LocationModel>[];
  final polygonLocations = <LocationModel>[];
  final pointLocations = <LocationModel>[];

  final List<List<LatLng>> polylineLatLng = [[]];
  final List<List<LatLng>> polygonLatLng = [[]];
  final List<LatLng> circleLatLng = [];
  final pointLatLng = <LatLng>[];
  int polygoneCount = 0;
  int polylineCount = 0;
  int circleCount = 0;
  int pointCount = 0;
  List<int> radiusList = [];

  @override
  void initState() {
    controller = ExpansionTileController();
    controller2 = ExpansionTileController();
    controller3 = ExpansionTileController();
    controller4 = ExpansionTileController();
    controller5 = ExpansionTileController();
    controller6 = ExpansionTileController();

    final storyLocations = widget.model.locations;

    for (var i = 0; i < storyLocations!.length; i++) {
      if (storyLocations[i].isCircle != null &&
          storyLocations[i].circleRadius != null) {
        radiusList.add(storyLocations[i].circleRadius!);
      }
    }

    for (var i = 0; i < storyLocations.length; i++) {
      if (storyLocations[i].isPolygon != null) {
        polygonLocations.add(storyLocations[i]);
        polygoneCount = storyLocations[i].isPolygon!;
      } else if (storyLocations[i].isPolyline != null) {
        polylineLocations.add(storyLocations[i]);
        polylineCount = storyLocations[i].isPolyline!;
      } else if (storyLocations[i].isCircle != null) {
        circleLocations.add(storyLocations[i]);
        circleCount = storyLocations[i].isCircle!;
      } else {
        pointLocations.add(storyLocations[i]);
      }
    }

    for (var i = 0; i < pointLocations.length; i++) {
      additionalMarkers['$i'] = LatLng(
        pointLocations[i].latitude!,
        pointLocations[i].longitude!,
      );
    }
    for (var k = 0; k <= polygoneCount; k++) {
      if (k != 0) {
        final list = <LatLng>[];
        polygonLatLng.add(list);
      }
      for (var j = 0; j < polygonLocations.length; j++) {
        if (polygonLocations[j].isPolygon == k) {
          polygonLatLng[k].add(
            LatLng(
              polygonLocations[j].latitude!,
              polygonLocations[j].longitude!,
            ),
          );
          additionalPolygones?['$k'] = polygonLatLng[k];
        }
      }
    }
    for (var k = 0; k <= polylineCount; k++) {
      if (k != 0) {
        final list = <LatLng>[];
        polylineLatLng.add(list);
      }
      for (var j = 0; j < polylineLocations.length; j++) {
        if (polylineLocations[j].isPolygon == k) {
          polylineLatLng[k].add(
            LatLng(
              polylineLocations[j].latitude!,
              polylineLocations[j].longitude!,
            ),
          );
          additionalPolylines?['$k'] = polylineLatLng[k];
        }
      }
    }

    for (var k = 0; k < circleCount; k++) {
      for (var j = 0; j < circleLocations.length; j++) {
        circleLatLng.add(
          LatLng(
            circleLocations[j].latitude!,
            circleLocations[j].longitude!,
          ),
        );
        additionalCircles?['$j'] = circleLatLng[j];
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.model.text;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        title: Text(
          widget.model.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (widget.leadBackHome) {
              context.router.push(const HomeRoute());
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: context.appBarColor,
          ),
        ),
      ),
      body: BaseConsumer<SessionCubit, SessionState>(
        context,
        builder: (context, sessionCubit, sessionState) {
          final user = sessionState.authUser;
          return BaseView<StoryCubit, StoryState>(
            onCubitReady: (cubit) async {
              this.cubit = cubit;
            },
            builder: (context, cubit, state) {
              return SafeArea(
                child: BaseScrollView(
                  children: [
                    buildContent(
                      context,
                      text,
                      user!,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildContent(
    BuildContext context,
    String text,
    User user,
  ) {
    return FavoriteWrapper(
      initialState: widget.model.likes!.contains(user.id),
      builder: (
        context,
        addFavorite,
        isfavorite,
        isLoading,
      ) {
        var newlikes = widget.model.likes!.length;
        final initialState = widget.model.likes!.contains(user.id);

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.model.likes != null)
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: Center(
                          child: Row(
                            children: [
                              ButtonCard(
                                minScale: 0.8,
                                onPressed: () async {
                                  setState(() {
                                    addFavorite(storyId: widget.model.id);
                                    addFavoriteTriggered = true;
                                    newlikes = widget.model.likes!.length;
                                  });
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: isfavorite ? Colors.red : Colors.grey,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              if (addFavoriteTriggered)
                                Text(
                                  isfavorite & initialState
                                      ? (newlikes).toString()
                                      : isfavorite & !initialState
                                          ? (newlikes + 1).toString()
                                          : !isfavorite & initialState
                                              ? (newlikes - 1).toString()
                                              : (newlikes).toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              if (!addFavoriteTriggered)
                                Text(
                                  newlikes.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                            ],
                          ),
                        ),
                      ),
                    IconWithLabel(
                      spacing: 8,
                      icon: const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      label: widget.model.user!.username!,
                    ),
                  ],
                ),
              ),
              BaseWidgets.normalGap,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  controller: controller,
                  title: const Text(
                    'Time Variants',
                  ),
                  children: <Widget>[
                    if (widget.model.startTimeStamp != null)
                      Text(
                        'Start Time: ${widget.model.startTimeStamp}',
                        style: const TextStyles.body().copyWith(
                          letterSpacing: 0.016,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    BaseWidgets.lowerGap,
                    if (widget.model.endTimeStamp != null)
                      Text(
                        'End Time: ${widget.model.endTimeStamp}',
                        style: const TextStyles.body().copyWith(
                          letterSpacing: 0.016,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    BaseWidgets.lowerGap,
                    if (widget.model.decade != null)
                      Text(
                        'Decade: ${widget.model.decade!}',
                        style: const TextStyles.body().copyWith(
                          letterSpacing: 0.016,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    BaseWidgets.lowerGap,
                    if (widget.model.season != null)
                      Text(
                        'Season: ${widget.model.season!}',
                        style: const TextStyles.body().copyWith(
                          letterSpacing: 0.016,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    BaseWidgets.lowerGap,
                  ],
                ),
              ),
              BaseWidgets.lowerGap,
              if (widget.model.locations != null)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    controller: controller2,
                    title: const Text('Locations'),
                    initiallyExpanded: true,
                    children: <Widget>[
                      BaseWidgets.lowerGap,
                      if (polylineLocations.isNotEmpty)
                        ExpansionTile(
                          title: const Text('Polyline Locations'),
                          controller: controller3,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: SizedBox(
                                height: polylineLocations.length * 60,
                                child: Expanded(
                                  child: BaseListView(
                                    items: polylineLocations,
                                    itemBuilder: (item) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: Text(
                                              item.locationName!.toLocation(),
                                              style: const TextStyles.body()
                                                  .copyWith(
                                                letterSpacing: 0.016,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              final storyLocation = LatLng(
                                                item.latitude!,
                                                item.longitude!,
                                              );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MapView(
                                                    storyLocation:
                                                        storyLocation,
                                                    additionalMarkers:
                                                        additionalMarkers,
                                                    additionalPolygons:
                                                        additionalPolygones,
                                                    additionalPolylines:
                                                        additionalPolylines,
                                                    additionalCircles:
                                                        additionalCircles,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.location_on,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (polygonLocations.isNotEmpty) BaseWidgets.lowerGap,
                      if (polygonLocations.isNotEmpty)
                        ExpansionTile(
                          title: const Text('Polygon Locations'),
                          controller: controller4,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: SizedBox(
                                height: polygonLocations.length * 60,
                                child: Expanded(
                                  child: BaseListView(
                                    items: polygonLocations,
                                    itemBuilder: (item) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: Text(
                                              item.locationName!.toLocation(),
                                              style: const TextStyles.body()
                                                  .copyWith(
                                                letterSpacing: 0.016,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              final storyLocation = LatLng(
                                                item.latitude!,
                                                item.longitude!,
                                              );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MapView(
                                                    storyLocation:
                                                        storyLocation,
                                                    additionalMarkers:
                                                        additionalMarkers,
                                                    additionalPolygons:
                                                        additionalPolygones,
                                                    additionalPolylines:
                                                        additionalPolylines,
                                                    additionalCircles:
                                                        additionalCircles,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.location_on,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (circleLocations.isNotEmpty) BaseWidgets.lowerGap,
                      if (circleLocations.isNotEmpty)
                        ExpansionTile(
                          title: const Text('Circle Locations'),
                          controller: controller5,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: SizedBox(
                                height: circleLocations.length * 60,
                                child: Expanded(
                                  child: BaseListView(
                                    items: circleLocations,
                                    itemBuilder: (item) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: Text(
                                              item.locationName!.toLocation(),
                                              style: const TextStyles.body()
                                                  .copyWith(
                                                letterSpacing: 0.016,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              final storyLocation = LatLng(
                                                item.latitude!,
                                                item.longitude!,
                                              );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MapView(
                                                    storyLocation:
                                                        storyLocation,
                                                    additionalMarkers:
                                                        additionalMarkers,
                                                    additionalPolygons:
                                                        additionalPolygones,
                                                    additionalPolylines:
                                                        additionalPolylines,
                                                    additionalCircles:
                                                        additionalCircles,
                                                    radiusList:
                                                        radiusList.isEmpty
                                                            ? null
                                                            : radiusList,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.location_on,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (pointLocations.isNotEmpty) BaseWidgets.lowerGap,
                      if (pointLocations.isNotEmpty)
                        ExpansionTile(
                          title: const Text('Point Locations'),
                          controller: controller6,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: SizedBox(
                                height: pointLocations.length * 60,
                                child: Expanded(
                                  child: BaseListView(
                                    items: pointLocations,
                                    itemBuilder: (item) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: Text(
                                              item.locationName!.toLocation(),
                                              style: const TextStyles.body()
                                                  .copyWith(
                                                letterSpacing: 0.016,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              final storyLocation = LatLng(
                                                item.latitude!,
                                                item.longitude!,
                                              );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MapView(
                                                    storyLocation:
                                                        storyLocation,
                                                    additionalMarkers:
                                                        additionalMarkers,
                                                    additionalPolygons:
                                                        additionalPolygones,
                                                    additionalPolylines:
                                                        additionalPolylines,
                                                    additionalCircles:
                                                        additionalCircles,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.location_on,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              BaseWidgets.lowerGap,
              if (widget.model.labels != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 60,
                    child: BaseListView(
                      scrollDirection: Axis.horizontal,
                      items: widget.model.labels!,
                      itemBuilder: (item) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                _buildChip(item),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              const Divider(
                color: Colors.black,
              ),
              BaseWidgets.lowerGap,
              Text(
                widget.model.title,
                style: const TextStyles.title().copyWith(
                  letterSpacing: 0.016,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              BaseWidgets.lowerGap,
              SingleChildScrollView(
                child: Html(data: text),
              ),
              BaseWidgets.highGap,
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      labelPadding: const EdgeInsets.all(2),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      elevation: 4,
      padding: const EdgeInsets.all(8),
    );
  }
}

class MapView extends StatefulWidget {
  final LatLng? storyLocation;
  final Map<String, LatLng>? additionalMarkers;
  final Map<String, List<LatLng>>? additionalPolygons;
  final Map<String, List<LatLng>>? additionalPolylines;
  final Map<String, LatLng>? additionalCircles;
  final List<int>? radiusList;

  const MapView({
    this.storyLocation,
    super.key,
    this.additionalMarkers,
    this.additionalPolygons,
    this.additionalPolylines,
    this.additionalCircles,
    this.radiusList,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLocationPicker(
        apiKey: AppEnv.apiKey,
        currentLatLng: widget.storyLocation,
        hideLocationButton: true,
        hideMapTypeButton: true,
        hideMoreOptions: true,
        additionalMarkers: widget.additionalMarkers,
        additionalPolygons: widget.additionalPolygons,
        additionalPolylines: widget.additionalPolylines,
        additionalCircles: widget.additionalCircles,
        hideAreasList: true,
        hideLocationList: true,
        radiusList: widget.radiusList,
      ),
    );
  }
}
