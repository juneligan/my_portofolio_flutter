import 'package:json_annotation/json_annotation.dart';

part 'shorten_analytics_response.g.dart';

@JsonSerializable()
class ShortenAnalyticsResponse {
  final int count;
  final DateTime clickDate;

  ShortenAnalyticsResponse({
    required this.count,
    required this.clickDate,
  });

  factory ShortenAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$ShortenAnalyticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShortenAnalyticsResponseToJson(this);
}
