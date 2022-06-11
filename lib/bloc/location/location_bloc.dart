import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nativ/data/model/place.dart';
import 'package:nativ/data/model/place_search.dart';
import 'package:nativ/data/services/places_service.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState>
    with ChangeNotifier {
  final PlacesService _placesService = PlacesService();
  List<PlaceSearch> searchResults = [];

  // * Stream for location search results
  BehaviorSubject<Place> selectedLocation = BehaviorSubject<Place>();

  BehaviorSubject<LocationData> currentLocationStream = BehaviorSubject();
  Location? currentLocation;
  LocationData? currentLocationData;
  BehaviorSubject<LocationMarkerPosition> currentLocationMarkerPositon =
      BehaviorSubject();

  Stream<LocationMarkerPosition> get getCurrentMarkerPosition =>
      currentLocationMarkerPositon.stream;
  Function(LocationMarkerPosition) get updateCurrentMarkerPosition =>
      currentLocationMarkerPositon.add;

  Stream<LocationData> get getCurrentLocation => currentLocationStream.stream;
  Function(LocationData) get updateCurrentLocation => currentLocationStream.add;

  void _setCurrentLocation() async {
    var currentLocation = await _intialLocationRequest();
    updateCurrentLocation(currentLocation!);
    updateCurrentMarkerPosition(LocationMarkerPosition(
        latitude: currentLocation.latitude!,
        longitude: currentLocation.longitude!,
        accuracy: 100));
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await _placesService.getAutoComplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    selectedLocation.add(await _placesService.getPlace(placeId));
    notifyListeners();
  }

  LocationBloc() : super(LocationInitial()) {
    _setCurrentLocation();

    on<LocationClicked>((event, emit) {
      emit(LocationRequested());
    });
    on<LocationBeingScrolledUp>(
      (event, emit) {
        emit(LocationScrollingUp());
        print("scrolling up!");
      },
    );
    on<LocationBeingScrolledDown>(
        (event, emit) => emit(LocationScrollingDown()));
    on<LocationScrollingStopped>(
      (event, emit) => emit(ResetLocationView()),
    );
    on<LocationDismissed>((event, emit) => emit(ResetLocationView()));
    on<LocationAttributeSelected>((event, emit) => {print('selected')});
    on(<LocationSearch>(event, emit) => emit(LocationSearchStarted()));
    //on(<AddLocation>(event, emit) => emit(MarkerPlaced()));
  }
}

// * Initial Location + Services & Permissions Request
Future<LocationData?> _intialLocationRequest() async {
  Location currentLocation = Location();
  _checkPermission();
  _checkService();
  return currentLocation.getLocation();
}

// * Location Service Check
Future<bool> _checkService() async {
  bool serviceEnabled;
  Location location = Location();

  try {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
  } on PlatformException catch (error) {
    print('error is code ${error.code} with msg: ${error.message}');
    serviceEnabled = false;
    await _checkService();
  }

  return serviceEnabled;
}

// * Permission Status Check
Future<PermissionStatus> _checkPermission() async {
  Location location = Location();
  PermissionStatus permissionGranted;

  try {
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
  } on PlatformException catch (error) {
    print('error is code ${error.code} with msg: ${error.message}');
    permissionGranted = PermissionStatus.denied;
    await _checkPermission();
  }

  return permissionGranted;
}

// * Get Current Location
void getCurrentLocation() async {
  Location location = Location();
}

// TODO: Dispose Method


