import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:nativ/bloc/location/location_bloc.dart';

class RegionAndCitySearchBar extends StatefulWidget {
  String? hintText;
  RegionAndCitySearchBar({
    this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  State<RegionAndCitySearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<RegionAndCitySearchBar> {
  final FloatingSearchBarController controller = FloatingSearchBarController();

  @override
  void initState() {
    // TODO: implement initState

    KeyboardVisibilityController().onChange.listen((visible) {
      if (visible = false) {
        controller.close();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locationBloc = BlocProvider.of<LocationBloc>(context);

    return FloatingSearchBar(
      iconColor: const Color(0xfff37d64),
      queryStyle: const TextStyle(color: Colors.black87),
      backdropColor: Colors.black54,
      automaticallyImplyDrawerHamburger: false,
      controller: controller,
      hint: widget.hintText ?? 'Search..',
      openAxisAlignment: 0.0,
      width: 500,
      height: 48,
      scrollPadding: const EdgeInsets.only(top: 5, bottom: 100),
      elevation: 1.0,
      onFocusChanged: (focus) {
        if (focus == true) {
          locationBloc.add(LocationSearchbarClicked());
          print("Searchbar Focused**");
        } else if (focus == false) {
          locationBloc.add(LocationSearchbarClosed());
        }
      },
      onSubmitted: (query) {
        locationBloc
            .setSelectedLocation(locationBloc.searchResults.first.placeId!);
        //locationBloc.add(LocationSearch());
        locationBloc.add(LocationSearchSubmit());

        controller.close();
        //locationBloc.add(LocationSearchbarClosed());
      },
      onQueryChanged: (query) {
        if (query != '') {
          locationBloc.searchRegionsAndCities(query);
          BlocProvider.of<LocationBloc>(context).add(LocationSearch());
        }

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
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is LocationSearchStarted) {
                  return SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: locationBloc.searchResults.length,
                      itemBuilder: (context, index) {
                        if (locationBloc.searchResults.isNotEmpty) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () => {
                                  locationBloc.setSelectedLocation(locationBloc
                                      .searchResults[index].placeId!),
                                  locationBloc.add(LocationSearchSubmit()),
                                  controller.close(),
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
                        return const SizedBox(
                          height: 300,
                          child: Center(
                              child: Text(
                            'No results found..',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox(
                  height: 300,
                  child: Center(
                      child: Text(
                    'No results found..',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                );
              },
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
