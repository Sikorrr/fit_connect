import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/config.dart';
import '../../../../core/error/error_manager.dart';
import '../../domain/repositories/location_repository.dart';
import '../models/geocoding_response.dart';

@singleton
class LocationRepositoryImpl implements LocationRepository {
  final Dio _dio;
  final ErrorManager _errorManager;

  LocationRepositoryImpl(this._dio, this._errorManager);

  @override
  Future<List<String>> fetchSuggestions(String input) async {
    final String url = _buildUrl(input);

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return _parseResponse(response.data);
      } else {
        _errorManager.logError(
          'Error fetching suggestions: ${response.statusCode} ${response.statusMessage}',
        );
        return [];
      }
    } catch (e, s) {
      _errorManager.logError(
        'Error fetching suggestions: $e',
        exception: e,
        stackTrace: s,
      );
      return [];
    }
  }

  String _buildUrl(String input) {
    return '${LocationConfig.baseUrl}?api_key=${LocationConfig.apiKey}&text=$input&boundary.country=${LocationConfig.country}&sources=${LocationConfig.sources}&layers=${LocationConfig.layers}';
  }

  List<String> _parseResponse(Map<String, dynamic> data) {
    final GeocodingResponse geocodingResponse =
        GeocodingResponse.fromJson(data);
    return geocodingResponse.features
        .map((feature) => feature.properties.name)
        .toList();
  }
}
