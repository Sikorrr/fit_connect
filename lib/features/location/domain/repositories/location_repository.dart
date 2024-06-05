abstract class LocationRepository {
  Future<List<String>> fetchSuggestions(String input);
}
