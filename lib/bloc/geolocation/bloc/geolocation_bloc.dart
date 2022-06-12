import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nativ/data/repositories/geolocation/geolocation_repository.dart';

part 'geolocation_event.dart';
part 'geolocation_state.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  final GeoLocationRepository _geoLocationRepository;
  StreamSubscription? _geoLocationSubscription;

  GeolocationBloc({required GeoLocationRepository geoLocationRepository})
      : _geoLocationRepository = geoLocationRepository,
        super(GeolocationLoading()) {
    on<LoadGeolocation>((event, emit) async {
      _geoLocationSubscription?.cancel();
      final Position position =
          await _geoLocationRepository.getCurrentLocation();

      add(UpdateGeolocation(position: position));
    });
    on<UpdateGeolocation>((event, emit) {
      emit(GeolocationLoaded(position: event.position));
    });
  }

  @override
  Future<void> close() {
    _geoLocationSubscription?.cancel();
    return super.close();
  }
}
