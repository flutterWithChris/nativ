import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:nativ/bloc/geolocation/bloc/geolocation_bloc.dart';
import 'package:nativ/bloc/location/location_bloc.dart';
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
  final MapController mapController = MapController();

  @override
  void initState() {
    final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    super.initState();
    locationSubscription = locationBloc.selectedLocation.stream.listen((place) {
      _goToPlace(place, mapController);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locationBloc = BlocProvider.of<LocationBloc>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state.themeData == ThemeData.light()) {
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
              var currentPosition =
                  LatLng(state.position.latitude, state.position.longitude);
              return Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  SafeArea(
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        maxBounds: LatLngBounds(
                            LatLng(-90, -180.0), LatLng(90.0, 180.0)),
                        screenSize: Size(MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height),
                        center: currentPosition,
                        minZoom: 2,
                        zoom: 11.0,
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
                        MarkerLayerOptions(
                          markers: [
                            Marker(
                              width: 20.0,
                              height: 20.0,
                              point: LatLng(state.position.latitude,
                                  state.position.longitude),
                              builder: (ctx) => AnimatedScale(
                                duration: const Duration(milliseconds: 500),
                                scale: mapController.zoom <= 5 ? 0.5 : 1.0,
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
        } else {
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
              var currentPosition =
                  LatLng(state.position.latitude, state.position.longitude);
              return Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  SafeArea(
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        maxBounds: LatLngBounds(
                            LatLng(-90, -180.0), LatLng(90.0, 180.0)),
                        screenSize: Size(MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height),
                        center: currentPosition,
                        minZoom: 2,
                        zoom: 11.0,
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
                        MarkerLayerOptions(
                          markers: [
                            Marker(
                              width: 20.0,
                              height: 20.0,
                              point: LatLng(state.position.latitude,
                                  state.position.longitude),
                              builder: (ctx) => AnimatedScale(
                                duration: const Duration(milliseconds: 500),
                                scale: mapController.zoom > 9 ? 1.0 : 0.4,
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
      },
    );
  }

// * Move camera to searched place.
  Future<void> _goToPlace(Place place, MapController controller) async {
    final LatLng placeCoordinates = LatLng(
        place.geometry.locationResult.lat, place.geometry.locationResult.lng);

    // * Set zoom based on place types.
    if (place.types.contains('locality') ||
        place.types.contains('administrative_area_level_3') ||
        place.types.contains('sublocality') ||
        place.types.contains('postal_code')) {
      controller.move(placeCoordinates, 10);
    } else {
      controller.move(placeCoordinates, 5);
    }
  }
}
