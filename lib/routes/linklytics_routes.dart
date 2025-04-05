// path

import 'package:my_portfolio_flutter/linklytics/constants/config.dart';

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
  logout('/logout'),
  uly('/u.ly')
  ;

  const LinkLyticsUri(this.path);
  final String path;

  String get uri {
    if (this == LinkLyticsUri.base) {
      return LinkLyticsUri.base.path;
    }

    return '${LinkLyticsUri.base.path}$path';
  }

  String get fullPath {
    return '${getCurrentDomain()}/#$uri';
  }

  String get shortenPath {
    return '${getCurrentDomain()}/#$path';
  }
}
