class ApiRouteNames {
  static const String baseUrl = 'https://amusing-open-javelin.ngrok-free.app/';
  // static const String baseUrl = 'http://localhost:8080';
  static const String otpLoginRegistration = '/api/auth/public/otp/login';
  static const String otpAuthentication = '/api/auth/public/otp/authenticate';
  static const String sendSms = '/api/sms/send';
  static const String totalClicks = '/api/urls/analytics/total-clicks';
  static const String createShortenUrl = '/api/urls/shorten';
}

enum ApiRouteName {
  domain('https://amusing-open-javelin.ngrok-free.app'),
  // domain('http://localhost:8080'),
  baseUrl('/api'),
  otpLoginRegistration('/auth/public/otp/login'),
  otpAuthentication('/auth/public/otp/authenticate'),
  sendSms('/sms/send'),
  totalClicks('/urls/analytics/total-clicks'),
  getShortenUrls('/urls'),
  getAnalyticsShortenUrl('/urls/analytics/{shortenKey}'),
  ;

  const ApiRouteName(this.path);

  final String path;

  String applyParams(Map<String, String>? values) {
    if (values == null || values.isEmpty) {
      return path;
    }

    return values.entries.fold(path, (updatedUrl, entry) {
      return updatedUrl.replaceAll('{${entry.key}}', entry.value);
    });
  }

  String getFullUrl() {
    return '${domain.path}${baseUrl.path}${this.path}';
  }

  String getFullPath() {
    return '${baseUrl.path}${this.path}';
  }
}
