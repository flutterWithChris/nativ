import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:nativ/bloc/geolocation/bloc/geolocation_bloc.dart';
import 'package:nativ/bloc/location/location_bloc.dart';
import 'package:nativ/bloc/settings/preferences.dart';
import 'package:nativ/bloc/settings/theme/bloc/theme_bloc.dart';
import 'package:nativ/data/model/place.dart';
import 'package:nativ/view/widgets/region_city_searchbar.dart';

class MainMap extends StatefulWidget {
  const MainMap({
    Key? key,
  }) : super(key: key);

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  late StreamSubscription locationSubscription;
  late StreamSubscription currentLocationListener;
  Stream<LatLng>? currentLocation;
  static Stream<LocationMarkerPosition>? _markerPosition;
  late final MapController mapController;

  var themeIndex;

  getThemeState() async {
    themeIndex = SharedPrefs().getThemeIndex;
  }

  @override
  void initState() {
    final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    mapController = MapController();
    super.initState();
    locationSubscription = locationBloc.selectedLocation.stream.listen((place) {
      _goToPlace(place, mapController, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var rng = Random();
    List<Marker> markers = [
      for (int i = 0; i < 1000; i++)
        Marker(
          width: 20.0,
          height: 20.0,
          point: LatLng(-90 + rng.nextDouble() * 90.0 * 2,
              -180 + rng.nextDouble() * 90.0 * 2),
          builder: (ctx) => AnimatedScale(
            duration: const Duration(milliseconds: 500),
            scale: mapController.zoom <= 5 ? 0.5 : 1.0,
            child: const SizedBox(child: Icon(FontAwesomeIcons.locationPin)),
          ),
        ),
    ];
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.themeData != current.themeData,
      builder: (context, state) {
        getThemeState();
        if (themeIndex == 0) {
          return BlocBuilder<GeolocationBloc, GeolocationState>(
              builder: (context, state) {
            if (state is GeolocationLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
            if (state is GeolocationLoaded) {
              ScrollController scrollController = ScrollController();

              var currentPosition =
                  LatLng(state.position.latitude, state.position.longitude);

              return Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      plugins: [MarkerClusterPlugin()],
                      maxBounds: LatLngBounds(
                          LatLng(-90, -180.0), LatLng(90.0, 180.0)),
                      screenSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                      center: currentPosition,
                      minZoom: 3.0,
                      zoom: 3.7,
                      interactiveFlags:
                          InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: dotenv.get('MAPBOX_API_URL'),
                        additionalOptions: {
                          'accessToken': dotenv.get('MAPBOX_MAGNOLIA'),
                          'id': 'mapbox.mapbox-streets-v8',
                        },
                      ),
                      MarkerClusterLayerOptions(
                        onMarkerTap: (p0) {
                          var locationBloc = context.read<LocationBloc>();
                          locationBloc.searchRegionsAndCities('Mexico');
                          locationBloc.setSelectedLocation(
                              locationBloc.searchResults.first.placeId!);
                          context
                              .read<LocationBloc>()
                              .add(LocationSearchSubmit());
                        },
                        //  circleSpiralSwitchover: 0,
                        maxClusterRadius: 120,
                        size: const Size(30, 30),
                        fitBoundsOptions: const FitBoundsOptions(
                          padding: EdgeInsets.all(50),
                        ),
                        markers: markers,
                        polygonOptions: const PolygonOptions(
                            borderColor: Colors.blueAccent,
                            color: Colors.black12,
                            borderStrokeWidth: 3),
                        builder: (context, markers) {
                          return CircleAvatar(
                            backgroundColor: const Color(0xfff37d64),
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 20.0,
                            height: 20.0,
                            point: LatLng(state.position.latitude,
                                state.position.longitude),
                            builder: (ctx) => AnimatedScale(
                              duration: const Duration(milliseconds: 500),
                              scale: mapController.zoom < 9.0 ? 0.4 : 1.0,
                              child: const FittedBox(
                                  child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.blue,
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
                    child: BlocBuilder<LocationBloc, LocationState>(
                      builder: ((context, state) {
                        if (state is LocationSearchbarFocused ||
                            state is LocationSearchStarted) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 400,
                            child: RegionAndCitySearchBar(
                              hintText: 'Search Regions & Cities...',
                            ),
                          );
                        } else {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 78,
                            child: RegionAndCitySearchBar(
                              hintText: 'Search Regions & Cities...',
                            ),
                          );
                        }
                      }),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: Text('Something Went Wrong...'),
              );
            }
          });
        }
        // * Dark Mode Map
        else {
          return BlocBuilder<GeolocationBloc, GeolocationState>(
              builder: (context, state) {
            if (state is GeolocationLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
            if (state is GeolocationLoaded) {
              ScrollController scrollController = ScrollController();
              var rng = Random();
              var currentPosition =
                  LatLng(state.position.latitude, state.position.longitude);

              return Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      plugins: [MarkerClusterPlugin()],
                      maxBounds: LatLngBounds(
                          LatLng(-90, -180.0), LatLng(90.0, 180.0)),
                      screenSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                      center: currentPosition,
                      minZoom: 3.0,
                      zoom: 3.7,
                      interactiveFlags:
                          InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: dotenv.get('MAPBOX_API_URL_DARK'),
                        additionalOptions: {
                          'accessToken': dotenv.get('MAPBOX_MAGNOLIA'),
                          'id': 'mapbox.mapbox-streets-v8',
                        },
                      ),
                      MarkerClusterLayerOptions(
                        onMarkerTap: (p0) {
                          var locationBloc = context.read<LocationBloc>();
                          locationBloc.searchRegionsAndCities('Mexico');
                          locationBloc.setSelectedLocation(
                              locationBloc.searchResults.first.placeId!);
                          context
                              .read<LocationBloc>()
                              .add(LocationSearchSubmit());
                        },
                        //  circleSpiralSwitchover: 0,
                        maxClusterRadius: 120,
                        size: const Size(30, 30),
                        fitBoundsOptions: const FitBoundsOptions(
                          padding: EdgeInsets.all(50),
                        ),
                        markers: markers,
                        polygonOptions: const PolygonOptions(
                            borderColor: Colors.blueAccent,
                            color: Colors.black12,
                            borderStrokeWidth: 3),
                        builder: (context, markers) {
                          return CircleAvatar(
                            backgroundColor: const Color(0xfff37d64),
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 20.0,
                            height: 20.0,
                            point: LatLng(state.position.latitude,
                                state.position.longitude),
                            builder: (ctx) => AnimatedScale(
                              duration: const Duration(milliseconds: 500),
                              scale: mapController.zoom < 9.0 ? 0.4 : 1.0,
                              child: const FittedBox(
                                  child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.blue,
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16.0),
                    child: BlocBuilder<LocationBloc, LocationState>(
                      builder: ((context, state) {
                        if (state is LocationSearchbarFocused ||
                            state is LocationSearchStarted) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 400,
                            child: RegionAndCitySearchBar(
                              hintText: 'Where are you traveling to?',
                            ),
                          );
                        } else {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 78,
                            child: RegionAndCitySearchBar(
                              hintText: 'Where are you going?',
                            ),
                          );
                        }
                      }),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: Text('Something Went Wrong...'),
              );
            }
          });
        }
      },
    );
  }

// * Move camera to searched place.
  Future<void> _goToPlace(
      Place place, MapController controller, bool fromMarker) async {
    final LatLng placeCoordinates = LatLng(
        place.geometry.locationResult.lat, place.geometry.locationResult.lng);

    // * Set zoom based on place types.
    if (place.types.contains('locality') ||
        place.types.contains('administrative_area_level_3') ||
        place.types.contains('sublocality') ||
        place.types.contains('postal_code')) {
      controller.move(placeCoordinates, fromMarker ? controller.zoom : 8);
    } else {
      controller.move(placeCoordinates, fromMarker ? controller.zoom : 5);
    }
  }
}
