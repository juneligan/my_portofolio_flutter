class ApiRouteNames {
  static const String baseUrl = 'https://amusing-open-javelin.ngrok-free.app/';
  // static const String baseUrl = 'http://localhost:8080';
  static const String otpLoginRegistration = '/api/auth/public/otp/login';
  static const String otpAuthentication = '/api/auth/public/otp/authenticate';
  static const String sendSms = '/api/sms/send';
  static const String totalClicks = '/api/urls/analytics/total-clicks';
  static const String createShortenUrl = '/api/urls/shorten';
}