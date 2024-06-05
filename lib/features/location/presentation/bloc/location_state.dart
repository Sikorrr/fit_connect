abstract class LocationAutocompleteState {}

class LocationAutocompleteInitial extends LocationAutocompleteState {}

class LocationAutocompleteLoading extends LocationAutocompleteState {}

class LocationAutocompleteLoaded extends LocationAutocompleteState {
  final List<String> suggestions;

  LocationAutocompleteLoaded(this.suggestions);
}

class LocationAutocompleteError extends LocationAutocompleteState {
  final String errorMessage;

  LocationAutocompleteError(this.errorMessage);
}

class LocationAutocompleteEmpty extends LocationAutocompleteState {}
