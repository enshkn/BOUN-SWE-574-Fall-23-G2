import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/map_location_picker.dart'
    hide Location;
import 'package:location/location.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/debouncer.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_consumer.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/app_search_bar.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/story_card.dart';
import 'package:swe/_presentation/widgets/mixins/scroll_anim_mixin.dart';
import 'package:swe/_presentation/widgets/modals.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_wrapper.dart';

@RoutePage()
class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with ScrollAnimMixin {
  final FocusNode _focusNode = FocusNode();
  final debouncer = Debouncer(milliseconds: 500);
  TextEditingController? _searchController;
  late LatLng? _currentPosition = const LatLng(0, 0);
  final Location _locationController = Location();
  bool locationLoading = true;

  @override
  void initState() {
    getCurrentLocation();

    super.initState();
  }

  Future<void> getCurrentLocation() async {
    LocationData currentLocation;
    Future.delayed(const Duration(seconds: 10), () async {
      currentLocation = await _locationController.getLocation();
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          locationLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseConsumer<SessionCubit, SessionState>(
      context,
      builder: (context, sessionCubit, sessionState) {
        final user = sessionState.authUser;
        return BaseView<StoryCubit, StoryState>(
          onCubitReady: (cubit) {
            cubit.setContext(context);
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
                          context.router.push(const AddStoryRoute());
                        },
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: AppSearchBar(
                      searchTerm: state.search,
                      onSearchControllerReady: (controller) {
                        _searchController = controller;
                      },
                      hintText: 'Search',
                      onChanged: (val) {
                        debouncer.run(() async {
                          setState(() {
                            isVisible = true;
                          });
                          _searchController?.text = val!;

                          await cubit.search(
                            term: val,
                          );
                        });
                      },
                      onPressedFilter: () async {
                        _focusNode.unfocus();

                        final filter = await showFilterModal(
                          context,
                          currentFilter: state.filter,
                          currentPosition: _currentPosition,
                        );
                        if (filter == null || filter.isEmpty) return;

                        //_searchController?.clear();
                        await cubit.getSearchResult(
                          filter,
                          _searchController?.text,
                        );
                      },
                    ),
                  ),
                  if (user != null)
                    Expanded(
                      child: BaseListView<StoryModel>(
                        controller: scrollController,
                        items: state.searchResultStories,
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
            );
          },
        );
      },
    );
  }
}
