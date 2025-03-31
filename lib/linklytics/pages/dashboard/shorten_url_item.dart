import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/shorten_analytics_response.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/shorten_url_response.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/url_shortener_api.dart';

final shortenUrlsProvider = StateNotifierProvider<ShortenUrlsNotifier,
    AsyncValue<List<ShortenUrlResponse>>>(
  (ref) => ShortenUrlsNotifier(ref.watch(urlShortenerApiProvider)),
);

class ShortenUrlsNotifier
    extends StateNotifier<AsyncValue<List<ShortenUrlResponse>>> {
  final UrlShortenerApi _urlShortenerApi;

  ShortenUrlsNotifier(this._urlShortenerApi) : super(const AsyncLoading()) {
    fetchAllShortenUrls();
  }

  Future<void> fetchAllShortenUrls() async {
    try {
      // Simulating an API call
      await Future.delayed(const Duration(seconds: 2));

      final response = await _urlShortenerApi.getAllShorten();
      // Convert Map<String, int> → List<TotalClickEventResponse>

      state = AsyncData(response);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

// Riverpod state for analytics visibility
final analyticsShortenProvider =
    StateNotifierProvider<AnalyticsShortenNotifier, Map<int, bool>>(
  (ref) => AnalyticsShortenNotifier(),
);

class AnalyticsShortenNotifier extends StateNotifier<Map<int, bool>> {
  AnalyticsShortenNotifier() : super({});

  void toggleAnalytics(int urlId) {
    state = {
      ...state,
      urlId: !(state[urlId] ?? false),
    };
  }
}

// Provider to fetch analytics data
final analyticsShortenDataProvider =
    FutureProvider.family<List<ShortenAnalyticsResponse>, String>(
        (ref, shortUrl) async {
  UrlShortenerApi urlShortenerApi = ref.watch(urlShortenerApiProvider);
  return await urlShortenerApi.getShortenAnalyticsByKey(shortUrl);
});

class ShortUrlBox extends ConsumerWidget {
  final String shortUrl;
  final String originalUrl;
  final int urlId;
  final int clickCount;
  final DateTime creationDate;

  const ShortUrlBox({
    Key? key,
    required this.shortUrl,
    required this.originalUrl,
    required this.urlId,
    required this.clickCount,
    required this.creationDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnalyticsVisible =
        ref.watch(analyticsShortenProvider)[urlId] ?? false;
    final analyticsData = ref.watch(analyticsShortenDataProvider(shortUrl));
    String formatted = DateFormat('MMM dd, yyyy').format(creationDate);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () =>
                          Clipboard.setData(ClipboardData(text: shortUrl)),
                      child: Text(shortUrl,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ),
                    Text(originalUrl, style: TextStyle(color: Colors.grey)),
                    Row(
                      children: [
                        Icon(Icons.bar_chart, size: 16, color: Colors.green),
                        SizedBox(width: 4),
                        Text('$clickCount Clicks'),
                        SizedBox(width: 10),
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(formatted),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: shortUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied to clipboard!')),
                        );
                      },
                      child: Text('Copy'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(analyticsShortenProvider.notifier)
                          .toggleAnalytics(urlId),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Analytics'),
                    ),
                  ],
                ),
              ],
            ),
            if (isAnalyticsVisible) ...[
              Divider(),
              analyticsData.when(
                data: (data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data
                      .map((entry) => Text(
                          'Date: ${entry.clickDate}, Clicks: ${entry.count}'))
                      .toList(),
                ),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Failed to load analytics'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
