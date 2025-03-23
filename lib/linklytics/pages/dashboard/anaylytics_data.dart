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
}