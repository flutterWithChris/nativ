part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationSearchStarted extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {}

class LocationScrollingUp extends LocationState {}

class ResetLocationView extends LocationState {}

class LocationScrollingDown extends LocationState {}

class LocationFailed extends LocationState {}

class Loading extends LocationState {}

class LocationPreviewRequested extends LocationState {}

class LocationRequested extends LocationState {}

class LocationDetailsRequested extends LocationState {}

class LocationCreated extends LocationState {}

class LocationDeleted extends LocationState {}

class LocationUpdated extends LocationState {}

class LocationSearchbarFocused extends LocationState {}

class LocationSearchbarUnfocused extends LocationState {}
