import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/api_route_names.dart';
import 'package:my_portfolio_flutter/linklytics/constants/config.dart';
import 'package:my_portfolio_flutter/linklytics/design_system/app_date_range_selector.dart';
import 'package:my_portfolio_flutter/linklytics/pages/dashboard/anaylytics_data.dart';
import 'package:my_portfolio_flutter/linklytics/provider/dio_provider.dart';
import 'package:my_portfolio_flutter/linklytics/provider/shared_preferences_provider.dart';
import 'package:my_portfolio_flutter/routes/linklytics_routes.dart';

import 'shorten_analytics_response.dart';
import 'shorten_url_response.dart';

final urlShortenerApiProvider = Provider<UrlShortenerApi>((ref) {
  final sharedPrefsAsync = ref.watch(sharedPreferencesProvider);
  final DioClient dioClient = ref.watch(dioProvider);

// If sharedPrefs is still loading, return a temporary instance that does nothing
  if (sharedPrefsAsync is AsyncLoading || !sharedPrefsAsync.hasValue) {
    return UrlShortenerApi(dioClient.getDio(), null);
  }
  final sharedPrefs = sharedPrefsAsync.value!;
  return UrlShortenerApi(dioClient.getDio(), sharedPrefs);
});

class UrlShortenerApi {
  final String _dateFormat = 'yyyy-MM-dd';
  final Dio _dio;
  final SharedPreferencesService? _prefsService;

  UrlShortenerApi(this._dio, this._prefsService);

  // Sample API response
  // final response1 = {
  //   "2024-07-01": 3,
  //   "2024-07-02": 5,
  //   "2024-07-03": 2,
  //   "2024-07-04": 10,
  //   "2024-07-05": 17,
  // };
  Future<List<TotalClickEventResponse>> getUrlAnalyticsData(
      DateRangeState? dateRange) async {
    String? token = _prefsService?.getJwtToken();
    try {
      Response response = await _dio.get('/api/urls/analytics/total-clicks',
          options: Options(headers: {'Authorization': 'Bearer $token'}),

          /// startDate=2025-01-10&endDate=2025-12-30
          queryParameters: dateRange == null ? null : {
            'startDate': DateFormat(_dateFormat).format(dateRange.startDate!),
            'endDate': DateFormat(_dateFormat).format(dateRange.endDate!),
          });

      // ✅ Print request method & URL
      print('Request Method: ${response.requestOptions.method}');
      print('Request URL: ${response.requestOptions.uri}');

      // ✅ Print request headers
      print('Headers: ${response.requestOptions.headers}');
      print('Params: ${response.requestOptions.queryParameters}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        // return TotalClickEventResponse.fromJson(response.data);
        final data = response.data as Map<String, dynamic>;
        return data.entries
            .map((entry) => TotalClickEventResponse(
                clickDate: entry.key, count: entry.value))
            .toList();
      }
    } on DioException catch (e) {
      print('⚠️ Dio Error Occurred!');
      print('⚠️ Dio Error Occurred!: ${e.error}');
      print('⚠️ Dio Error Occurred!: ${e.stackTrace}');

      // ✅ Print HTTP status code
      print('Status Code: ${e.response?.statusCode}');
      print('Status Msg: ${e.response?.statusMessage}');

      // ✅ Print error message
      print('Error Message: ${e.message}');

      // ✅ Print request method & URL
      print('Request Method: ${e.requestOptions.method}');
      print('Request URL: ${e.requestOptions.uri}');

      // ✅ Print request headers
      print('Headers: ${e.requestOptions.headers}');

      // ✅ Print response data (if available)
      print('Response Data: ${e.response?.data}');
    } on Exception catch (e) {
      print('ERROR exception: $e');
    }

    return [];
  }

  Future<String?> createShortenUrl(String url) async {
    String? token = _prefsService?.getJwtToken();

    Response? response = await performDioAction(() => _dio.post(
          ApiRouteNames.createShortenUrl,
          data: {'originalUrl': url},
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        ));

    if (response == null) {
      return null;
    }
    ShortenUrlResponse apiResponse = ShortenUrlResponse.fromJson(response.data);

    return '${LinkLyticsUri.uly.shortenPath }/${apiResponse.shortUrl}';
  }

  Future<List<ShortenUrlResponse>> getAllShorten() async {
    String? token = _prefsService?.getJwtToken();

    if (token == null || token.isEmpty) {
      return Future.value([]);
    }

    Response? response = await performDioAction(() => _dio.get(
          ApiRouteName.getShortenUrls.getFullPath(),
          queryParameters: {
            'startDate': '2025-01-10',
            'endDate': '2025-12-30',
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        ));

    if (response == null || response.data == null || response.data.isEmpty) {
      return Future.value([]);
    }

    final data = response.data as List<dynamic>;
    return data.map((o) => ShortenUrlResponse.fromJson(o)).toList();
  }

  Future<List<ShortenAnalyticsResponse>> getShortenAnalyticsByKey(
      String value) async {
    String? token = _prefsService?.getJwtToken();

    Response? response = await performDioAction(() => _dio.get(
          ApiRouteName.getAnalyticsShortenUrl
              .applyParams({'shortenKey': value}),
          queryParameters: {
            'startDate': '2025-01-10T00:00:00',
            'endDate': '2025-12-30T00:00:00',
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        ));

    if (response == null) {
      return [];
    }

    final data = response.data as List<dynamic>;
    return data.map((o) => ShortenAnalyticsResponse.fromJson(o)).toList();
  }

  Future<void> redirectToUrl(String value) async {
    String? token = _prefsService?.getJwtToken();

    Response? response = await performDioAction(() => _dio.get(
          ApiRouteName.redirectToUrl
              .applyParams({'shortUrl': value}),
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        ));

    if (response == null) {
      return;
    }

    return;
  }

  Future<Response?> performDioAction(
      Future<Response> Function() fetchFunction) async {
    try {
      Response response = await fetchFunction();

      // ✅ Print request method & URL
      print('Request Method: ${response.requestOptions.method}');
      print('Request URL: ${response.requestOptions.uri}');

      // ✅ Print request headers
      print('Headers: ${response.requestOptions.headers}');
      print('Params: ${response.requestOptions.queryParameters}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        return response;
      }
    } on DioException catch (e) {
      print('⚠️ Dio Error Occurred!');
      print('⚠️ Dio Error Occurred!: ${e.error}');
      print('⚠️ Dio Error Occurred!: ${e.stackTrace}');

      // ✅ Print HTTP status code
      print('Status Code: ${e.response?.statusCode}');
      print('Status Msg: ${e.response?.statusMessage}');

      // ✅ Print error message
      print('Error Message: ${e.message}');

      // ✅ Print request method & URL
      print('Request Method: ${e.requestOptions.method}');
      print('Request URL: ${e.requestOptions.uri}');

      // ✅ Print request headers
      print('Headers: ${e.requestOptions.headers}');

      // ✅ Print response data (if available)
      print('Response Data: ${e.response?.data}');
    } on Exception catch (e) {
      print('ERROR exception: $e');
    }
    return null;
  }
}
