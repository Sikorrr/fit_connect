abstract class LocationAutocompleteEvent {}

class LocationQueryChanged extends LocationAutocompleteEvent {
  final String query;

  LocationQueryChanged(this.query);
}

class ClearSuggestions extends LocationAutocompleteEvent {}
