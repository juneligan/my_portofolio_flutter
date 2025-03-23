import 'package:json_annotation/json_annotation.dart';

part 'shorten_url_response.g.dart';

@JsonSerializable()
class ShortenUrlResponse {
  final String originalUrl;
  final String shortUrl;

  ShortenUrlResponse({required this.originalUrl, required this.shortUrl});

  factory ShortenUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$ShortenUrlResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShortenUrlResponseToJson(this);
}
