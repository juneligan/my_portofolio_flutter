import 'package:intl/intl.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/shorten_analytics_response.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/shorten_url_response.dart';

class TotalClickEventResponse {
  final String clickDate; // Example: "2024-07-01"
  final int count;   // Example: 3

  TotalClickEventResponse({required this.clickDate, required this.count});

  factory TotalClickEventResponse.fromJson(MapEntry<String, dynamic> entry) {
    return TotalClickEventResponse(
      clickDate: entry.key,
      count: entry.value as int,
    );
  }
  factory TotalClickEventResponse.fromShortenAnalyticsResponse(ShortenAnalyticsResponse response) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(response.clickDate);
    return TotalClickEventResponse(
      clickDate: formattedDate,
      count:response.count,
    );
  }
}