import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:nativ/bloc/location/location_bloc.dart';

class LocationSearchBar extends StatefulWidget {
  String? hintText;
  LocationSearchBar({
    this.hintText,
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
      hint: widget.hintText ?? 'Search..',
      openAxisAlignment: 0.0,
      width: 500,
      height: 48,
      scrollPadding: const EdgeInsets.only(top: 5, bottom: 5),
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
          locationBloc.searchPlaces(query);
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

class NativListView extends StatelessWidget {
  final ScrollController scrollController;
  const NativListView({
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      //mainAxisSize: MainAxisSize.min,
      children: [
        const SearchStickyHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 75.0, 8.0, 8.0),
          child: NativListTiles(scrollController: scrollController),
        ),
      ],
    );
  }
}

Widget buildDragHandle() => GestureDetector(
      child: Center(
        child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );

class SearchStickyHeader extends StatelessWidget {
  const SearchStickyHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 12,
            ),
            buildDragHandle(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '32 Nativ\'s Found Nearby',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(
                  height: 40,
                  width: 100,
                  child: FittedBox(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          fixedSize: const Size(100, 40)),
                      onPressed: () {
                        print('filter pressed');
                      },
                      child: const Text(
                        'Filter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NativListTiles extends StatelessWidget {
  const NativListTiles({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: ((context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.zbrushcentral.com/uploads/default/original/4X/7/9/6/7966865da1c1203fd5250ab05bb1fc00ba8133e9.jpeg'),
              ),
              title: const Text('Thorin Oakenshield'),
              subtitle: const Text('Auckland, NZ'),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4.0,
                children: const [
                  Text('4.5'),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ),
            const ListTile(
              trailing: Icon(
                FontAwesomeIcons.arrowRight,
                color: Colors.blueAccent,
              ),
              subtitle: Text(
                  'I\'m a born & raised New Zealander who love to hike & finding the best food'),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: SizedBox(
                height: 35,
                child: FittedBox(
                  child: Chip(
                    backgroundColor: Colors.orange,
                    label: Text('Top Rated',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        );
      }),
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
