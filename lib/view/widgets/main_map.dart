import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:nativ/bloc/location/location_bloc.dart';
import 'package:nativ/data/model/place.dart';
import 'package:nativ/view/widgets/location_searchbar.dart';

class MainMap extends StatefulWidget {
  const MainMap({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  final MapController mapController;

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  late StreamSubscription locationSubscription;
  late StreamSubscription currentLocationListener;

  @override
  void initState() {
    final LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);

    super.initState();
    locationSubscription = locationBloc.selectedLocation.stream.listen((place) {
      _goToPlace(place, widget.mapController);
    });
    currentLocationListener =
        locationBloc.currentLocationStream.listen((currentLocationData) {});
  }

  @override
  Widget build(BuildContext context) {
    var locationBloc = BlocProvider.of<LocationBloc>(context);
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        StreamBuilder<LocationMarkerPosition>(
            stream: locationBloc.getCurrentMarkerPosition,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                LatLng currentLocation =
                    LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                return BlocProvider(
                  create: (context) => LocationBloc(),
                  child: FlutterMap(
                    mapController: widget.mapController,
                    options: MapOptions(
                      center: currentLocation,
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
                            point: currentLocation,
                            builder: (ctx) => Container(
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
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        const IntrinsicHeight(child: LocationSearchBar()),
      ],
    );
  }

// * Move camera to searched place.
  Future<void> _goToPlace(Place place, MapController controller) async {
    final LatLng placeCoordinates = LatLng(
        place.geometry.locationResult.lat, place.geometry.locationResult.lng);

    Scaffold.of(context).showBottomSheet((context) => BottomSheet(
          onClosing: () {},
          builder: (_) {
            return DraggableScrollableSheet(
                builder: ((context, scrollController) {
              return Container();
            }));
          },
        ));

    // * Set zoom based on place type.
    if (place.type.contains('country') || place.type.contains('continent')) {
      controller.move(placeCoordinates, 5);
    } else if (place.type.contains('locality') ||
        place.type.contains('postal')) {
      controller.move(placeCoordinates, 10);
    } else {
      controller.move(placeCoordinates, 16.0);
    }
  }
}

// * Create bounds for camera.
LatLngBounds createBounds(List<LatLng> positions) {
  final southWestLat = positions
      .map((p) => p.latitude)
      .reduce((value, element) => value < element ? value : element);
  final southWestLng = positions
      .map((p) => p.longitude)
      .reduce((value, element) => value < element ? value : element);
  final northEastLat = positions
      .map((p) => p.latitude)
      .reduce((value, element) => value < element ? value : element);
  final northEastLng = positions
      .map((p) => p.longitude)
      .reduce((value, element) => value < element ? value : element);
  return LatLngBounds(
      LatLng(southWestLat, southWestLng), LatLng(northEastLat, northEastLng));
}
