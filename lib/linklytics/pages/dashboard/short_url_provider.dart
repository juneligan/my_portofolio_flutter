import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/linklytics/be_integration/url_shortener_api.dart';

// Provider for submission state
final shortUrlProvider = StateNotifierProvider<ShortUrlNotifier, ShortUrlState>(
      (ref) => ShortUrlNotifier(ref.watch(urlShortenerApiProvider)),
);

// Notifier to handle API request
class ShortUrlNotifier extends StateNotifier<ShortUrlState> {
  final UrlShortenerApi urlShortenerApi;
  ShortUrlNotifier(this.urlShortenerApi) : super(ShortUrlInitial());

  Future<String?> createShortUrl(String url) async {
    if (url.isEmpty) {
      state = ShortUrlError("URL is required*");
      return null;
    }

    state = ShortUrlLoading();

    await Future.delayed(const Duration(seconds: 2)); // Simulated API call

    String? shortUrl = await urlShortenerApi.createShortenUrl(url);
    state = ShortUrlSuccess("Shortened URL created successfully!");
    return shortUrl;
  }
}

// States for the provider
abstract class ShortUrlState {}

class ShortUrlInitial extends ShortUrlState {}

class ShortUrlLoading extends ShortUrlState {}

class ShortUrlSuccess extends ShortUrlState {
  final String message;
  ShortUrlSuccess(this.message);
}

class ShortUrlError extends ShortUrlState {
  final String message;
  ShortUrlError(this.message);
}