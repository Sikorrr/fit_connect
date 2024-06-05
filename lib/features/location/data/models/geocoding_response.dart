import 'package:json_annotation/json_annotation.dart';

part 'geocoding_response.g.dart';

@JsonSerializable()
class GeocodingResponse {
  final List<Feature> features;

  GeocodingResponse({required this.features});

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) =>
      _$GeocodingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeocodingResponseToJson(this);
}

@JsonSerializable()
class Feature {
  final FeatureProperties properties;

  Feature({required this.properties});

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureToJson(this);
}

@JsonSerializable()
class FeatureProperties {
  final String name;

  FeatureProperties({required this.name});

  factory FeatureProperties.fromJson(Map<String, dynamic> json) =>
      _$FeaturePropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturePropertiesToJson(this);
}
