import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_domain/story/model/getNearbyStories_model.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_consumer.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/app_button.dart';
import 'package:swe/_presentation/widgets/base/base_header_title.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/story_card.dart';
import 'package:swe/_presentation/widgets/textformfield/app_text_form_field.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_wrapper.dart';
import 'package:geocoding/geocoding.dart';

@RoutePage()
class NearbyView extends StatefulWidget {
  const NearbyView({super.key});

  @override
  State<NearbyView> createState() => _NearbyViewState();
}

class _NearbyViewState extends State<NearbyView> {
  final FocusNode _focusNode = FocusNode();
  //final Location _locationController = Location();
  late TextEditingController _radiusController;
  String adress = '';
  Address? _currentAddress;
  GetNearbyStoriesModel model = const GetNearbyStoriesModel(
    radius: 0,
    latitude: 0,
    longitude: 0,
  );
  late LocationData currentLocation;
  Address? currentAddress;
  @override
  void initState() {
    _radiusController = TextEditingController();
    super.initState();
  }

  Future<void> getCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble('latitude');
    final longtitude = prefs.getDouble('longitude');
    if (latitude != null && longtitude != null) {
      currentLocation = LocationData.fromMap({
        'latitude': latitude,
        'longitude': longtitude,
      });
      model = GetNearbyStoriesModel(
        radius: 10,
        latitude: latitude,
        longitude: longtitude,
      );

      await placemarkFromCoordinates(latitude, longtitude).then((placemarks) {
        const output = 'No results found.';
        if (placemarks.isNotEmpty) {
          _currentAddress = Address(
            streetAddress: placemarks[0].street.toString(),
            city: placemarks[0].locality.toString(),
            region: placemarks[0].administrativeArea.toString(),
            countryCode: placemarks[0].isoCountryCode.toString(),
          );
        }

        setState(() {
          currentAddress = _currentAddress;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseConsumer<SessionCubit, SessionState>(
      context,
      builder: (context, sessionCubit, sessionState) {
        final user = sessionState.authUser;
        return BaseView<StoryCubit, StoryState>(
          onCubitReady: (cubit) async {
            cubit.setContext(context);
            cubit.init();

            await getCurrentLocation();
            await cubit.getNearbyStories(model);
          },
          builder: (context, cubit, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Image.asset(
                    'assets/images/2dutlukfinal.png',
                    fit: BoxFit.contain,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: IconButton.outlined(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _focusNode.unfocus();
                          context.router.push(AddStoryRoute());
                        },
                      ),
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await cubit.getNearbyStories(model);
                },
                child: BaseScrollView(
                  children: [
                    if (state.nearbyStories.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: BaseHeaderTitle(
                          title: 'Nearby Stories',
                          onShowAllButtonPressed: () {},
                        ),
                      ),
                    if (user != null)
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: AppTextFormField(
                                controller: _radiusController,
                                hintText: 'Write radius',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: AppButton(
                                backgroundColor: Colors.orange,
                                label: 'Search',
                                noIcon: true,
                                onPressed: () async {
                                  model = GetNearbyStoriesModel(
                                    radius: _radiusController.text != ''
                                        ? int.parse(_radiusController.text)
                                        : 10,
                                    latitude: currentLocation.latitude,
                                    longitude: currentLocation.longitude,
                                  );
                                  await cubit.getNearbyStories(model);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (currentAddress != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          child: Text(
                            '*Your Current Location: ${currentAddress!.city}, ${currentAddress!.streetAddress}, ${currentAddress!.region},  ${currentAddress!.countryCode} ',
                          ),
                        ),
                      ),
                    if (user != null)
                      SizedBox(
                        child: BaseListView<StoryModel>(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          items: state.nearbyStories,
                          itemBuilder: (item) {
                            return FavoriteWrapper(
                              userId: user.id!,
                              initialStateSave: item.savedBy != null
                                  ? item.savedBy!.contains(user.id)
                                  : false,
                              storyId: item.id,
                              builder: (
                                context,
                                addFavorite,
                                addSave,
                                isfavorite,
                                isSaved,
                                isLoading,
                                likeCount,
                              ) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  height: 450,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.router.push(
                                        StoryDetailsRoute(
                                          model: item,
                                        ),
                                      );
                                    },
                                    child: StoryCard(
                                      storyModel: item,
                                      showFavouriteButton: false,
                                      onTagSearch: (label) async {
                                        await context.router.push(
                                          TagSearchRoute(
                                            tag: label,
                                          ),
                                        );
                                      },
                                      isSaved: isSaved,
                                      isSavedLoading: isLoading,
                                      onSavedTap: () async {
                                        await addSave(
                                          storyId: item.id,
                                        );
                                      },
                                      /*  likeCount: likeCount,
                                                          isFavorite: isfavorite,
                                                          isFavoriteLoading:
                                                              isLoading,
                                                          onFavouriteTap: () async {
                                                            await addFavorite(
                                                              storyId: item.id,
                                                            );
                                                          }, */
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
