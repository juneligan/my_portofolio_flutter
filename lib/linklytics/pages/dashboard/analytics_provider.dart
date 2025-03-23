import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/url_shortener_api.dart';

import 'anaylytics_data.dart';

final analyticsProvider = StateNotifierProvider<AnalyticsNotifier,
    AsyncValue<List<TotalClickEventResponse>>>(
  (ref) => AnalyticsNotifier(ref.watch(urlShortenerApiProvider)),
);

class AnalyticsNotifier
    extends StateNotifier<AsyncValue<List<TotalClickEventResponse>>> {
  final UrlShortenerApi _urlShortenerApi;

  AnalyticsNotifier(this._urlShortenerApi) : super(const AsyncLoading()) {
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    try {
      // Simulating an API call
      await Future.delayed(const Duration(seconds: 2));

      final response = await _urlShortenerApi.getUrlAnalyticsData();
      // Convert Map<String, int> → List<TotalClickEventResponse>

      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
