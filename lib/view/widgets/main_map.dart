import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:nativ/bloc/geolocation/bloc/geolocation_bloc.dart';
import 'package:nativ/bloc/location/location_bloc.dart';
import 'package:nativ/data/model/place.dart';
import 'package:nativ/view/widgets/location_searchbar.dart';

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
    return BlocBuilder<GeolocationBloc, GeolocationState>(
        builder: (context, state) {
      if (state is GeolocationLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is GeolocationLoaded) {
        return Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center:
                    LatLng(state.position.latitude, state.position.longitude),
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
                      point: LatLng(
                          state.position.latitude, state.position.longitude),
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
            const IntrinsicHeight(
              child: LocationSearchBar(),
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
