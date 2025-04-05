import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/shorten_analytics_response.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/shorten_url_response.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/url_shortener_api.dart';
import 'package:my_portfolio_flutter/linklytics/constants/config.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_date_range_selector.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_text.dart';
import 'package:my_portfolio_flutter/linklytics/pages/dashboard/analytics_page.dart';
import 'package:my_portfolio_flutter/linklytics/pages/dashboard/anaylytics_data.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';

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
    if (!mounted) {
      return;
    }
    try {
      // Simulating an API call
      await Future.delayed(const Duration(seconds: 2));

      final response = await _urlShortenerApi.getAllShorten();
      // Convert Map<String, int> → List<TotalClickEventResponse>

      if (!mounted) {
        // ✅ Check after async calls
        return;
      }
      state = AsyncData(response);
    } catch (e) {
      if (!mounted) {
        // ✅ Also guard here
        return;
      }
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
    print('URL ID --------->$urlId');
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
    super.key,
    required this.shortUrl,
    required this.originalUrl,
    required this.urlId,
    required this.clickCount,
    required this.creationDate,
  });

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
                      onTap: () => Clipboard.setData(copyToClipboard()),
                      child: Text('${LinkLyticsUri.uly.shortenPath}/$shortUrl',
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
                        await Clipboard.setData(copyToClipboard());
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
                data: (data) {
                  return data.isEmpty
                      ? AppText('No Record', type: TextType.md)
                      : buildGraph(
                          context,
                          ref,
                          data
                              .map((entry) => TotalClickEventResponse
                                  .fromShortenAnalyticsResponse(entry))
                              .toList(),
                          false,
                        );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Failed to load analytics'),
              ),
              // _buildDateRangeForSpecificUrl(ref, urlId)
            ],
          ],
        ),
      ),
    );
  }

  ClipboardData copyToClipboard() {
    return ClipboardData(text: '${LinkLyticsUri.uly.shortenPath}/$shortUrl');
  }

  _buildDateRangeForSpecificUrl(WidgetRef ref, int urlId) {
    final analyticDateRangeState = ref.watch(
      dateRangeProvider.select((state) =>
          state[DateRangeKey.shortAnalytics.getIndexedKey('$urlId')]),
    );

    // buildDateRange(context, ref, notifier, dateState, data)
  }
}
