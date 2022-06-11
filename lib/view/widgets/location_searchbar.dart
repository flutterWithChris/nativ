import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:nativ/bloc/location/location_bloc.dart';

class LocationSearchBar extends StatefulWidget {
  const LocationSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final FloatingSearchBarController controller = FloatingSearchBarController();

  @override
  void initState() {
    // TODO: implement initState

    KeyboardVisibilityNotification().addNewListener(
      onShow: () {},
      onHide: () {
        controller.close();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locationBloc = BlocProvider.of<LocationBloc>(context);

    return FloatingSearchBar(
      backdropColor: Colors.black54,
      automaticallyImplyDrawerHamburger: false,
      controller: controller,
      hint: 'Search..',
      openAxisAlignment: 0.0,
      width: 500,
      height: 48,
      scrollPadding: const EdgeInsets.only(top: 5, bottom: 5),
      elevation: 1.0,
      onFocusChanged: (focus) {},
      onSubmitted: (query) {
        locationBloc
            .setSelectedLocation(locationBloc.searchResults.first.placeId!);
        locationBloc.add(LocationSearch());
        controller.close();
      },
      onQueryChanged: (query) {
        locationBloc.searchPlaces(query);
        BlocProvider.of<LocationBloc>(context).add(LocationSearch());

        if (query == '') {
          controller.close();
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      transitionCurve: Curves.easeInOut,
      transitionDuration: const Duration(milliseconds: 500),
      builder: (context, transition) {
        return Stack(
          children: [
            SizedBox(
              height: 400,
              child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  if (state is LocationSearchStarted) {
                    return SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemCount: locationBloc.searchResults.length,
                        itemBuilder: (context, index) {
                          if (locationBloc.searchResults.isNotEmpty) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () => {
                                    locationBloc.setSelectedLocation(
                                        locationBloc
                                            .searchResults[index].placeId!),
                                    locationBloc.add(LocationSearch()),
                                    controller.close()
                                  },
                                  title: Text(
                                    locationBloc
                                        .searchResults[index].description!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.white,
                                ),
                              ],
                            );
                          }
                          return const Center(
                            child: Text('No results found..'),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(
                      child: Text(
                    'No results found..',
                    style: TextStyle(color: Colors.white),
                  ));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container(
      color: Colors.black45,
      height: 150,
    );
  }
}
