part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

class DeleteLocation extends LocationEvent {}

class LocationSearchbarClicked extends LocationEvent {}

class LocationSearchbarClosed extends LocationEvent {}

class LocationSearch extends LocationEvent {}

class LocationSearchSubmit extends LocationEvent {}

class LocationClicked extends LocationEvent {}

class LocationDismissed extends LocationEvent {}

class LocationBeingScrolledUp extends LocationEvent {}

class LocationBeingScrolledDown extends LocationEvent {}

class LocationScrollingStopped extends LocationEvent {}

class AddLocation extends LocationEvent {}

class FindLocation extends LocationEvent {}

class EditLocation extends LocationEvent {}

class ReportLocation extends LocationEvent {}

class LikeLocation extends LocationEvent {}

class DislikeLocation extends LocationEvent {}

class RequestLocationPreview extends LocationEvent {}

class RequestDetails extends LocationEvent {}

class LocationAttributeSelected extends LocationEvent {}
