// path

class LinklyticsPath {
  // static const String linklyticsBasePath = "/linklytics";
  static const String linklyticsHomePath = "";
  static const String registerPath = "/register";
  // static const String dashboardPath = "/dashboard";
  static const String loginPath = "/login";
  // static const String otpLoginPath = "/login/otp";
  static const List<String> linkLyticsPaths = [];

}

enum LinkLyticsUri {
  base('/linklytics'),
  otpLogin('/login/otp'),
  dashboard('/dashboard'),
  about('/about'),
  login('/login'),
  register('/register'),
  storybook('/storybook'),
  ;

  const LinkLyticsUri(this.path);
  final String path;

  String get uri {
    if (this == LinkLyticsUri.base) {
      return LinkLyticsUri.base.path;
    }

    return '${LinkLyticsUri.base.path}${this.path}';
  }
}
