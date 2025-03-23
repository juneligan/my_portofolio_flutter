import 'package:json_annotation/json_annotation.dart';

part 'generic_response.g.dart';

class GenericResponse<T> {
  T? data;

  GenericResponse({required this.data});

  factory GenericResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>?) fromJsonT,
  ) {
    return GenericResponse<T>(
      data: fromJsonT(json['data']),
    );
  }

  /// **Method for serialization**
  Map<String, dynamic> toJson(Map<String, dynamic>? Function(T) toJsonT) => {
        'data': data == null ? null : toJsonT(data as T),
      };
}

@JsonSerializable()
class OtpAuthResponse {
  String? accessToken;

  OtpAuthResponse({this.accessToken});

  factory OtpAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpAuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpAuthResponseToJson(this);
}
