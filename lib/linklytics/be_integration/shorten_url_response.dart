import 'package:json_annotation/json_annotation.dart';

part 'shorten_url_response.g.dart';

@JsonSerializable()
class ShortenUrlResponse {
  final int id;
  final String originalUrl;
  final String shortUrl;
  final int clickCount;
  final DateTime createdDate;

  ShortenUrlResponse({
    required this.id,
    required this.clickCount,
    required this.createdDate,
    required this.originalUrl,
    required this.shortUrl,
  });

  factory ShortenUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$ShortenUrlResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShortenUrlResponseToJson(this);
}
