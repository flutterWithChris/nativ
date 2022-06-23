import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
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

  searchPlaces(String searchTerm) async {
    searchResults = await _placesService.getAutoComplete(searchTerm);
    notifyListeners();
  }

  searchRegionsAndCities(String searchTerm) async {
    searchResults =
        await _placesService.getAutoCompleteRegionsAndCities(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    selectedLocation.add(await _placesService.getPlace(placeId));
    notifyListeners();
  }

  LocationBloc() : super(LocationInitial()) {
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
    on<LocationSearch>((event, emit) => emit(LocationSearchStarted()));
    on<LocationSearchSubmit>((event, emit) => emit(LocationLoading()));
    on<LocationSearchbarClicked>(
        (event, emit) => emit(LocationSearchbarFocused()));
    on<LocationSearchbarClosed>(
        (event, emit) => emit(LocationSearchbarUnfocused()));
    //on(<AddLocation>(event, emit) => emit(MarkerPlaced()));
  }
}
